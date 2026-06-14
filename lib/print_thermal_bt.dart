import 'dart:async';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';

/// Helper class untuk menangani koneksi dan penemuan printer Bluetooth.
/// Digunakan oleh main.dart untuk mencari printer yang tersedia secara otomatis.
class BluetoothPrinterConnector {
  final String address;
  BluetoothPrinterConnector({required this.address});

  /// Mencari printer yang sudah di-pairing (bonded) atau yang tersedia di sekitar.
  /// Mendukung request "otomatis" dengan mencari perangkat yang aktif.
  static Future<List<PrinterBluetooth>> discoverBondedPrinters() async {
    PrinterBluetoothManager printerManager = PrinterBluetoothManager();

    final completer = Completer<List<PrinterBluetooth>>();
    StreamSubscription? subscription;

    try {
      // Mulai pemindaian printer Bluetooth selama 2 detik.
      printerManager.startScan(const Duration(seconds: 5));

      // Mendengarkan hasil scan dan menangani error agar tidak crash.
      subscription = printerManager.scanResults.listen((results) {
        if (results.isNotEmpty && !completer.isCompleted) {
          subscription?.cancel();
          printerManager.stopScan();
          completer.complete(results);
        }
      }, onError: (err) {
        if (!completer.isCompleted) {
          subscription?.cancel();
          printerManager.stopScan();
          completer.complete([]);
        }
      });
    } catch (e) {
      subscription?.cancel();
      printerManager.stopScan();
      if (!completer.isCompleted) completer.complete([]);
    }

    // Timeout sebagai jaring pengaman jika stream tidak memberikan hasil.
    Timer(const Duration(seconds: 7), () {
      if (completer.isCompleted) return;
      subscription?.cancel();
      printerManager.stopScan();
      if (!completer.isCompleted) completer.complete([]);
    });

    return completer.future;
  }
}

class ThermalPrinterService {
  /// Mencetak nota dengan format otomatis yang dioptimalkan untuk printer termal 80mm.
  static Future<void> printReceipt({
    required PrinterBluetooth printer,
    required String toko,
    required List<Map<String, dynamic>> items,
    required int total,
  }) async {
    PrinterBluetoothManager printerManager = PrinterBluetoothManager();
    
    // Menggunakan printer yang sudah ditemukan sebelumnya untuk efisiensi waktu.
    printerManager.selectPrinter(printer);

    // Generate struktur data nota (Ticket) menggunakan profil ESC/POS standar.
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    // Header Nota
    bytes += generator.text(toko,
        styles: const PosStyles(
          bold: true,
          align: PosAlign.center,
          height: PosTextSize.size2,
          width: PosTextSize.size2,
        ));
    bytes += generator.text('NOTA TOKO', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.hr();

    // Items
    for (final row in items) {
      final nama = (row['nama_barang'] ?? row['nama'] ?? '').toString();
      final harga = row['harga'];
      final hargaInt = harga is int ? harga : int.tryParse(harga.toString()) ?? 0;
      final hargaFmt = hargaInt.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');

      // Menggunakan row untuk perataan kolom otomatis (total lebar 12 unit).
      bytes += generator.row([
        PosColumn(text: nama, width: 8),
        PosColumn(
          text: 'Rp$hargaFmt',
          width: 4,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]);
    }

    final totalFmt = total.toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');

    bytes += generator.hr();
    bytes += generator.text('TOTAL: Rp$totalFmt',
        styles: const PosStyles(bold: true, align: PosAlign.right));
    bytes += generator.hr();
    bytes += generator.feed(1);
    bytes += generator.text('Terima kasih', styles: const PosStyles(align: PosAlign.center));
    bytes += generator.feed(2);
    bytes += generator.cut();

    // Eksekusi pengiriman data ke printer.
    final PosPrintResult res = await printerManager.printTicket(bytes);
    if (res != PosPrintResult.success) {
      throw Exception('Gagal mencetak: ${res.msg}');
    }
  }
}

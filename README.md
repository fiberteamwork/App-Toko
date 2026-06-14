# Nota Toko - Aplikasi Manajemen Toko Offline

Aplikasi Flutter untuk manajemen toko dengan database SQLite offline. Mendukung operasi CRUD lengkap untuk kategori, barang, dan pengguna serta pencetakan nota via printer Bluetooth.

## Fitur Utama

### 1. **Manajemen Kategori** (CRUD)
- ✅ **Create**: Tambah kategori baru
- ✅ **Read**: Lihat daftar semua kategori
- ✅ **Delete**: Hapus kategori (dengan validasi jika masih digunakan barang)

### 2. **Manajemen Barang** (CRUD)
- ✅ **Create**: Tambah barang baru dengan kategori, harga, dan stok
- ✅ **Read**: Lihat daftar barang dengan informasi kategori
- ✅ **Update**: Edit data barang (nama, kategori, harga, stok)
- ✅ **Delete**: Hapus barang dari sistem

### 3. **Manajemen Pengguna** (CRUD)
- ✅ **Create**: Tambah pengguna baru dengan username dan password
- ✅ **Read**: Lihat daftar semua pengguna
- ✅ **Update**: Edit data pengguna (nama, username, password)
- ✅ **Delete**: Hapus pengguna dari sistem

### 4. **Dashboard**
- Ringkasan jumlah kategori, barang, dan pengguna
- Akses cepat ke fungsi-fungsi utama

### 5. **Pencetakan Nota**
- Cetak nota ke printer Bluetooth termal
- Format otomatis untuk printer 80mm
- Menampilkan nama toko, items, dan total harga

### 6. **Pengaturan**
- Atur nama toko yang akan ditampilkan di nota
- Pengaturan disimpan di database

## Instalasi & Setup

### Prasyarat
- Flutter SDK >= 3.0.0
- Android SDK (untuk build Android)
- Dart SDK

### Langkah-Langkah

1. **Clone/Extract Project**
```bash
cd app_toko_extracted
```

2. **Install Dependencies**
```bash
flutter pub get
```

3. **Jalankan App**

#### Di Android Emulator/Device
```bash
flutter run
```

#### Di Web Browser
```bash
flutter run -d chrome
```

4. **Build APK (Release)**
```bash
flutter build apk --release
```

## Struktur Project

```
app_toko_extracted/
├── lib/
│   ├── main.dart                 # Main app, CRUD UI, Database layer
│   └── print_thermal_bt.dart     # Printer Bluetooth integration
├── test/
│   └── widget_test.dart
├── web/
│   ├── index.html
│   └── manifest.json
├── pubspec.yaml                  # Dependencies
├── analysis_options.yaml          # Lint rules
└── README.md
```

## Struktur Database

### Tabel `kategori`
```sql
CREATE TABLE kategori (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nama TEXT NOT NULL UNIQUE
);
```

### Tabel `barang`
```sql
CREATE TABLE barang (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nama TEXT NOT NULL,
  kategori_id INTEGER NOT NULL,
  harga INTEGER NOT NULL,
  stok INTEGER NOT NULL DEFAULT 0,
  FOREIGN KEY (kategori_id) REFERENCES kategori(id)
);
```

### Tabel `pengguna`
```sql
CREATE TABLE pengguna (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nama TEXT NOT NULL,
  username TEXT NOT NULL UNIQUE,
  password_b64 TEXT NOT NULL
);
```

### Tabel `pengaturan`
```sql
CREATE TABLE pengaturan (
  kunci TEXT PRIMARY KEY,
  nilai TEXT
);
```

## Penggunaan Aplikasi

### Dashboard
- Lihat ringkasan data toko (jumlah kategori, barang, pengguna)
- Tombol akses cepat ke menu utama

### Manajemen Kategori
- Menu → Kategori
- Tambah kategori baru
- Hapus kategori (jika tidak digunakan barang)

### Manajemen Barang
- Menu → Barang
- Tambah barang dengan kategori, harga, stok
- Edit data barang
- Hapus barang (dengan konfirmasi)

### Manajemen Pengguna
- Menu → Pengguna
- Tambah pengguna (nama, username, password)
- Edit pengguna
- Hapus pengguna

### Cetak Nota
- Menu → Nota
- Hubungkan printer Bluetooth
- Cetak nota daftar barang

### Pengaturan
- Menu → Pengaturan Toko
- Atur nama toko

## Dependencies

```yaml
dependencies:
  flutter: sdk
  sqflite: ^2.3.0
  path_provider: ^2.1.2
  image_picker: ^1.1.2
  esc_pos_bluetooth: ^0.5.0
  esc_pos_utils: ^0.1.0

dev_dependencies:
  flutter_test: sdk
  flutter_lints: ^3.0.0
```

## License
MIT License
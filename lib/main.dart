import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'print_thermal_bt.dart';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


void main() => runApp(const NotaApp());

class NotaApp extends StatelessWidget {
  const NotaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nota Toko')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Dashboard'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const DashboardPage()),
            ),
          ),
          ListTile(
            title: const Text('Kategori'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const KategoriPage()),
            ),
          ),
          ListTile(
            title: const Text('Barang'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const BarangPage()),
            ),
          ),
          ListTile(
            title: const Text('Pengguna'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PenggunaPage()),
            ),
          ),
          ListTile(
            title: const Text('Nota'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const NotaPage()),
              );
            },
          ),

          ListTile(
            title: const Text('Pengaturan Toko'),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PengaturanTokoPage()),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: FutureBuilder<Database>(
        future: AppDb.instance.database,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(
              child: Text('Gagal membuka database: ${snapshot.error}'),
            );
          }

          return FutureBuilder<Map<String, int>>(
            future: AppDb.instance.countAll(),
            builder: (context, countSnap) {
              if (countSnap.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }
              final data = countSnap.data ?? const {};
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Ringkasan', style: Theme.of(context).textTheme.headlineSmall),
                    const SizedBox(height: 12),
                    Text('Kategori: ${data['kategori'] ?? 0}'),
                    Text('Barang: ${data['barang'] ?? 0}'),
                    Text('Pengguna: ${data['pengguna'] ?? 0}'),
                    const SizedBox(height: 18),
                    ElevatedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const KategoriPage()),
                      ),
                      icon: const Icon(Icons.add),
                      label: const Text('Tambah / Kelola Barang'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PenggunaPage(),
                        ),
                      ),
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text('Tambah / Kelola Pengguna'),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class BarangPage extends StatefulWidget {
  const BarangPage({super.key});

  @override
  State<BarangPage> createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  Future<void> _refresh() async {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barang')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      final kategoriCount = await AppDb.instance.countKategori();
                      if (kategoriCount == 0) {
                        if (!mounted) return;
                        await Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const TambahKategoriPage()),
                        );
                        if (!mounted) return;
                      }
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const TambahBarangPage()),
                      ).then((_) => _refresh());
                    },
                    icon: const Icon(Icons.add_box_outlined),
                    label: const Text('Tambah Barang'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: AppDb.instance.listBarangJoinedKategori(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final rows = snapshot.data ?? [];
                if (rows.isEmpty) {
                  return const Center(
                    child: Text('Belum ada barang. Klik "Tambah Barang".'),
                  );
                }
                return ListView.separated(
                  itemCount: rows.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final r = rows[i];
                    final id = r['id'] as int;
                    return ListTile(
                      title: Text(r['nama_barang'] as String? ?? '-'),
                      subtitle: Text('Kategori: ${r['nama_kategori'] ?? '-'}'),
                      trailing: Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(_formatRupiah(r['harga'])),
                          IconButton(
                            tooltip: 'Edit',
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EditBarangPage(barangId: id),
                                ),
                              ).then((_) => _refresh());
                            },
                          ),
                          IconButton(
                            tooltip: 'Hapus',
                            icon: const Icon(Icons.delete_outline, size: 20),
                            onPressed: () async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Hapus Barang'),
                                  content: const Text('Barang ini akan dihapus permanen. Lanjutkan?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Hapus',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                              if (ok != true) return;

                              try {
                                await AppDb.instance.deleteBarang(id: id);
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Barang berhasil dihapus')),
                                );
                                _refresh();
                              } on AppDbException catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.message)),
                                );
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Gagal menghapus barang: $e')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TambahBarangPage extends StatefulWidget {
  const TambahBarangPage({super.key});

  @override
  State<TambahBarangPage> createState() => _TambahBarangPageState();
}

class _TambahBarangPageState extends State<TambahBarangPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController(text: '0');

  int? _kategoriId;
  bool _saving = false;

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Barang')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: AppDb.instance.listKategori(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final kategori = snapshot.data ?? [];
          final kategoriEmpty = kategori.isEmpty;

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (kategoriEmpty)
                    Card(
                      color: Colors.amber.withOpacity(0.15),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Kategori belum tersedia.',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            const Text('Klik tombol di bawah untuk menambah kategori dulu.'),
                            const SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => const TambahKategoriPage(),
                                  ),
                                );
                                if (!mounted) return;
                                setState(() {});
                              },
                              icon: const Icon(Icons.category_outlined),
                              label: const Text('Tambah Kategori Dulu'),
                            ),
                          ],
                        ),
                      ),
                    ),

                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(labelText: 'Nama Barang'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Nama barang wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<int>(
                    value: _kategoriId,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: kategori
                        .map(
                          (k) => DropdownMenuItem<int>(
                            value: k['id'] as int,
                            child: Text(k['nama'] as String),
                          ),
                        )
                        .toList(),
                    onChanged: kategoriEmpty
                        ? null
                        : (v) {
                            setState(() => _kategoriId = v);
                          },
                    validator: (_) {
                      if (kategoriEmpty) return 'Kategori belum tersedia';
                      if (_kategoriId == null) return 'Pilih kategori';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _hargaController,
                    decoration: const InputDecoration(labelText: 'Harga (angka)'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final s = v?.trim() ?? '';
                      if (s.isEmpty) return 'Harga wajib diisi';
                      final n = int.tryParse(s);
                      if (n == null) return 'Harga harus angka';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _stokController,
                    decoration: const InputDecoration(labelText: 'Stok (angka)'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final s = v?.trim() ?? '';
                      if (s.isEmpty) return 'Stok wajib diisi';
                      final n = int.tryParse(s);
                      if (n == null) return 'Stok harus angka';
                      if (n < 0) return 'Stok tidak boleh negatif';
                      return null;
                    },
                  ),
                  const SizedBox(height: 18),

                  ElevatedButton(
                    onPressed: _saving
                        ? null
                        : () async {
                            final valid = _formKey.currentState?.validate() ?? false;
                            if (!valid) return;
                            setState(() => _saving = true);
                            try {
                              final nama = _namaController.text.trim();
                              final harga = int.parse(_hargaController.text.trim());
                              final stok = int.parse(_stokController.text.trim());

                              await AppDb.instance.insertBarang(
                                nama: nama,
                                kategoriId: _kategoriId!,
                                harga: harga,
                                stok: stok,
                              );
                              if (!mounted) return;
                              Navigator.of(context).pop(true);
                            } finally {
                              if (mounted) setState(() => _saving = false);
                            }
                          },
                    child: _saving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Simpan'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class EditBarangPage extends StatefulWidget {
  final int barangId;
  const EditBarangPage({super.key, required this.barangId});

  @override
  State<EditBarangPage> createState() => _EditBarangPageState();
}

class _EditBarangPageState extends State<EditBarangPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _hargaController = TextEditingController();
  final _stokController = TextEditingController(text: '0');

  int? _kategoriId;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final barang = await AppDb.instance.getBarangById(widget.barangId);
    if (!mounted) return;
    setState(() {
      _namaController.text = barang['nama'] as String? ?? '';
      _hargaController.text = (barang['harga'] as int?)?.toString() ?? '0';
      _stokController.text = (barang['stok'] as int?)?.toString() ?? '0';
      _kategoriId = barang['kategori_id'] as int?;
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _hargaController.dispose();
    _stokController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Barang')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: AppDb.instance.listKategori(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          final kategori = snapshot.data ?? [];
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _namaController,
                    decoration: const InputDecoration(labelText: 'Nama Barang'),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Nama barang wajib diisi';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  DropdownButtonFormField<int>(
                    value: _kategoriId,
                    decoration: const InputDecoration(labelText: 'Kategori'),
                    items: kategori
                        .map(
                          (k) => DropdownMenuItem<int>(
                            value: k['id'] as int,
                            child: Text(k['nama'] as String),
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _kategoriId = v),
                    validator: (_) {
                      if (_kategoriId == null) return 'Pilih kategori';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _hargaController,
                    decoration: const InputDecoration(labelText: 'Harga (angka)'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final s = v?.trim() ?? '';
                      if (s.isEmpty) return 'Harga wajib diisi';
                      final n = int.tryParse(s);
                      if (n == null) return 'Harga harus angka';
                      if (n < 0) return 'Harga tidak boleh negatif';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),

                  TextFormField(
                    controller: _stokController,
                    decoration: const InputDecoration(labelText: 'Stok (angka)'),
                    keyboardType: TextInputType.number,
                    validator: (v) {
                      final s = v?.trim() ?? '';
                      if (s.isEmpty) return 'Stok wajib diisi';
                      final n = int.tryParse(s);
                      if (n == null) return 'Stok harus angka';
                      if (n < 0) return 'Stok tidak boleh negatif';
                      return null;
                    },
                  ),

                  const SizedBox(height: 18),

                  ElevatedButton(
                    onPressed: _saving
                        ? null
                        : () async {
                            final valid = _formKey.currentState?.validate() ?? false;
                            if (!valid) return;

                            setState(() => _saving = true);
                            try {
                              await AppDb.instance.updateBarang(
                                id: widget.barangId,
                                nama: _namaController.text.trim(),
                                kategoriId: _kategoriId!,
                                harga: int.parse(_hargaController.text.trim()),
                                stok: int.parse(_stokController.text.trim()),
                              );
                              if (!mounted) return;
                              Navigator.of(context).pop(true);
                            } finally {
                              if (mounted) setState(() => _saving = false);
                            }
                          },
                    child: _saving
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Simpan Perubahan'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class TambahKategoriPage extends StatefulWidget {
  const TambahKategoriPage({super.key});

  @override
  State<TambahKategoriPage> createState() => _TambahKategoriPageState();
}

class _TambahKategoriPageState extends State<TambahKategoriPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Kategori')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama Kategori'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return 'Nama kategori wajib diisi';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _saving
                    ? null
                    : () async {
                        final valid = _formKey.currentState?.validate() ?? false;
                        if (!valid) return;
                        setState(() => _saving = true);
                        try {
                          await AppDb.instance.insertKategori(
                            nama: _namaController.text.trim(),
                          );
                          if (!mounted) return;
                          Navigator.of(context).pop(true);
                        } finally {
                          if (mounted) setState(() => _saving = false);
                        }
                      },
                child: _saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class KategoriPage extends StatefulWidget {
  const KategoriPage({super.key});

  @override
  State<KategoriPage> createState() => _KategoriPageState();
}

class _KategoriPageState extends State<KategoriPage> {
  Future<void> _refresh() async {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Kategori')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton.icon(
              onPressed: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const TambahKategoriPage()))
                  .then((_) => _refresh()),
              icon: const Icon(Icons.add),
              label: const Text('Tambah Kategori'),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: AppDb.instance.listKategoriWithCount(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final rows = snapshot.data ?? [];
                if (rows.isEmpty) {
                  return const Center(child: Text('Belum ada kategori.'));
                }
                return ListView.separated(
                  itemCount: rows.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final r = rows[i];
                    final id = r['id'] as int;
                    final count = r['item_count'] as int;
                    return ListTile(
                      title: Text(r['nama'] as String),
                      subtitle: Text('$count barang menggunakan kategori ini'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () async {
                          final ok = await showDialog<bool>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('Hapus Kategori'),
                              content: const Text('Hapus kategori ini?'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Batal')),
                                TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Hapus')),
                              ],
                            ),
                          );

                          if (ok == true) {
                            try {
                              await AppDb.instance.deleteKategori(id);
                              _refresh();
                            } on AppDbException catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.message)),
                              );
                            } catch (e) {
                              if (!mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: $e')),
                              );
                            }
                          }
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PenggunaPage extends StatefulWidget {
  const PenggunaPage({super.key});

  @override
  State<PenggunaPage> createState() => _PenggunaPageState();
}

class _PenggunaPageState extends State<PenggunaPage> {
  Future<void> _refresh() async {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengguna')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (_) => const TambahPenggunaPage(),
                        ),
                      )
                          .then((_) => _refresh());
                    },
                    icon: const Icon(Icons.person_add_alt_1_outlined),
                    label: const Text('Tambah Pengguna'),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: AppDb.instance.listPengguna(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final rows = snapshot.data ?? [];
                if (rows.isEmpty) {
                  return const Center(child: Text('Belum ada pengguna.'));
                }
                return ListView.separated(
                  itemCount: rows.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final r = rows[i];
                    final id = r['id'] as int;
                    return ListTile(
                      title: Text(r['nama'] as String? ?? '-'),
                      subtitle: Text('Username: ${r['username'] ?? '-'}'),
                      trailing: Wrap(
                        spacing: 8,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          IconButton(
                            tooltip: 'Edit',
                            icon: const Icon(Icons.edit_outlined, size: 20),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => EditPenggunaPage(penggunaId: id),
                                ),
                              ).then((_) => _refresh());
                            },
                          ),
                          IconButton(
                            tooltip: 'Hapus',
                            icon: const Icon(Icons.delete_outline, size: 20),
                            onPressed: () async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: const Text('Hapus Pengguna'),
                                  content: const Text('Pengguna ini akan dihapus permanen. Lanjutkan?'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.of(context).pop(true),
                                      child: const Text('Hapus',
                                          style: TextStyle(color: Colors.red)),
                                    ),
                                  ],
                                ),
                              );
                              if (ok != true) return;

                              try {
                                await AppDb.instance.deletePengguna(id: id);
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Pengguna berhasil dihapus')),
                                );
                                _refresh();
                              } on AppDbException catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.message)),
                                );
                              } catch (e) {
                                if (!mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Gagal menghapus pengguna: $e')),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class TambahPenggunaPage extends StatefulWidget {
  const TambahPenggunaPage({super.key});

  @override
  State<TambahPenggunaPage> createState() => _TambahPenggunaPageState();
}

class _TambahPenggunaPageState extends State<TambahPenggunaPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Pengguna')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Nama wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (v) {
                  final s = v?.trim() ?? '';
                  if (s.isEmpty) return 'Username wajib diisi';
                  if (s.length < 3) return 'Username minimal 3 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (v) {
                  final s = v?.trim() ?? '';
                  if (s.isEmpty) return 'Password wajib diisi';
                  if (s.length < 4) return 'Password minimal 4 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _saving
                    ? null
                    : () async {
                        final valid = _formKey.currentState?.validate() ?? false;
                        if (!valid) return;

                        setState(() => _saving = true);
                        try {
                          await AppDb.instance.insertPengguna(
                            nama: _namaController.text.trim(),
                            username: _usernameController.text.trim(),
                            passwordRaw: _passwordController.text,
                          );
                          if (!mounted) return;
                          Navigator.of(context).pop(true);
                        } on AppDbException catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.message)),
                          );
                        } finally {
                          if (mounted) setState(() => _saving = false);
                        }
                      },
                child: _saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NotaPage extends StatefulWidget {
  const NotaPage({super.key});

  @override
  State<NotaPage> createState() => _NotaPageState();
}

class _NotaPageState extends State<NotaPage> {
  bool _printing = false;

  Future<void> _printDemoReceipt() async {
    // AUTO: attempt to print using first/paired printer.
    // NOTE: For real-world usage, Bluetooth connection requires picking paired device/address.
    // This app will try to print to a default target if OS provides it.
    setState(() => _printing = true);
    try {
      // We don't know the printer address automatically in all cases.
      // Provide a fallback: scan paired printers.
      final bonded = await BluetoothPrinterConnector.discoverBondedPrinters();
      if (bonded.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Printer Bluetooth tidak ditemukan (paired).')),
        );
        return;
      }

      // Choose first printer.
      final printer = bonded.first;

      final namaToko = await AppDb.instance.getSetting('nama_toko', 'Toko Saya');
      final items = await AppDb.instance
          .listBarangJoinedKategori()
          .timeout(const Duration(seconds: 5));

      if (items.isEmpty) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data barang kosong, tidak ada yang bisa dicetak.')),
        );
        return;
      }

      final total = items.fold<int>(
        0,
        (sum, e) => sum + (int.tryParse(e['harga']?.toString() ?? '0') ?? 0),
      );

      if (!mounted) return;

      await ThermalPrinterService.printReceipt(
        printer: printer,
        toko: namaToko,
        items: items,
        total: total,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Print berhasil')),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal print: $e')),
      );
    } finally {
      if (mounted) setState(() => _printing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nota / Print')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Cetak nota (demo) dari data barang tersimpan.',
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: _printing ? null : _printDemoReceipt,
              icon: _printing
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.print),
              label: const Text('Print ke Printer Termal (Bluetooth)'),
            ),
          ],
        ),
      ),
    );
  }
}

class PengaturanTokoPage extends StatefulWidget {
  const PengaturanTokoPage({super.key});

  @override
  State<PengaturanTokoPage> createState() => _PengaturanTokoPageState();
}

class _PengaturanTokoPageState extends State<PengaturanTokoPage> {
  final _controller = TextEditingController();
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final val = await AppDb.instance.getSetting('nama_toko', 'Toko Saya');
    _controller.text = val;
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pengaturan Toko')),
      body: _loading 
        ? const Center(child: CircularProgressIndicator())
        : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    labelText: 'Nama Toko (Akan muncul di Nota)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      await AppDb.instance.saveSetting('nama_toko', _controller.text.trim());
                      if (!mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pengaturan disimpan')),
                      );
                      Navigator.pop(context);
                    },
                    child: const Text('Simpan'),
                  ),
                )
              ],
            ),
          ),
    );
  }
}

class EditPenggunaPage extends StatefulWidget {

  final int penggunaId;
  const EditPenggunaPage({super.key, required this.penggunaId});

  @override
  State<EditPenggunaPage> createState() => _EditPenggunaPageState();
}

class _EditPenggunaPageState extends State<EditPenggunaPage> {
  final _formKey = GlobalKey<FormState>();
  final _namaController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final u = await AppDb.instance.getPenggunaById(widget.penggunaId);
    if (!mounted) return;
    setState(() {
      _namaController.text = u['nama'] as String? ?? '';
      _usernameController.text = u['username'] as String? ?? '';
      _passwordController.text = '';
    });
  }

  @override
  void dispose() {
    _namaController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Pengguna')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Nama wajib diisi';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
                validator: (v) {
                  final s = v?.trim() ?? '';
                  if (s.isEmpty) return 'Username wajib diisi';
                  if (s.length < 3) return 'Username minimal 3 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password (opsional, kosongkan jika tidak diubah)',
                ),
                obscureText: true,
                validator: (v) {
                  final s = v?.trim() ?? '';
                  if (s.isEmpty) return null;
                  if (s.length < 4) return 'Password minimal 4 karakter';
                  return null;
                },
              ),
              const SizedBox(height: 18),
              ElevatedButton(
                onPressed: _saving
                    ? null
                    : () async {
                        final valid = _formKey.currentState?.validate() ?? false;
                        if (!valid) return;

                        setState(() => _saving = true);
                        try {
                          await AppDb.instance.updatePengguna(
                            id: widget.penggunaId,
                            nama: _namaController.text.trim(),
                            username: _usernameController.text.trim(),
                            passwordRawOrNull: _passwordController.text.trim().isEmpty
                                ? null
                                : _passwordController.text,
                          );
                          if (!mounted) return;
                          Navigator.of(context).pop(true);
                        } on AppDbException catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(e.message)),
                          );
                        } finally {
                          if (mounted) setState(() => _saving = false);
                        }
                      },
                child: _saving
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Simpan Perubahan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AppDbException implements Exception {
  final String message;
  const AppDbException(this.message);
}

class AppDb {
  AppDb._();
  static final AppDb instance = AppDb._();

  Database? _db;

  Future<Database> get database async {
    if (_db != null) return _db!;

    final dbPath = await getDatabasesPath();
    final path = '$dbPath/nota_toko.db';

    _db = await openDatabase(
      path,
      version: 1,
      onConfigure: (db) async => await db.execute('PRAGMA foreign_keys = ON'),
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE kategori (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL UNIQUE
          );
        ''');

        await db.execute('''
          CREATE TABLE barang (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL,
            kategori_id INTEGER NOT NULL,
            harga INTEGER NOT NULL,
            stok INTEGER NOT NULL DEFAULT 0,
            FOREIGN KEY (kategori_id) REFERENCES kategori(id)
          );
        ''');

        await db.execute('''
          CREATE TABLE pengguna (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nama TEXT NOT NULL,
            username TEXT NOT NULL UNIQUE,
            password_b64 TEXT NOT NULL
          );
        ''');

        await db.execute('''
          CREATE TABLE pengaturan (
            kunci TEXT PRIMARY KEY,
            nilai TEXT
          );
        ''');
      },
    );

    return _db!;
  }

  Future<Map<String, int>> countAll() async {
    final db = await database;
    final kategori = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM kategori'),
        ) ??
        0;
    final barang = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM barang'),
        ) ??
        0;
    final pengguna = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM pengguna'),
        ) ??
        0;
    return {
      'kategori': kategori,
      'barang': barang,
      'pengguna': pengguna,
    };
  }

  Future<int> countKategori() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM kategori'),
        ) ??
        0;
  }

  Future<int> insertKategori({required String nama}) async {
    final db = await database;
    try {
      return await db.insert('kategori', {'nama': nama});
    } catch (_) {
      throw const AppDbException('Kategori sudah ada atau tidak valid');
    }
  }

  Future<List<Map<String, dynamic>>> listKategoriWithCount() async {
    final db = await database;
    return db.rawQuery('''
      SELECT k.id, k.nama, COUNT(b.id) as item_count
      FROM kategori k
      LEFT JOIN barang b ON k.id = b.kategori_id
      GROUP BY k.id
      ORDER BY k.nama ASC
    ''');
  }

  Future<List<Map<String, dynamic>>> listKategori() async {
    final db = await database;
    return db.query('kategori', orderBy: 'nama ASC');
  }

  Future<void> deleteKategori(int id) async {
    final db = await database;
    final count = Sqflite.firstIntValue(await db.rawQuery(
      'SELECT COUNT(*) FROM barang WHERE kategori_id = ?', [id]
    )) ?? 0;
    if (count > 0) {
      throw const AppDbException('Gagal: Kategori masih digunakan oleh barang');
    }
    await db.delete('kategori', where: 'id = ?', whereArgs: [id]);
  }

  Future<String> getSetting(String key, String defaultValue) async {
    final db = await database;
    final res = await db.query('pengaturan', where: 'kunci = ?', whereArgs: [key]);
    if (res.isEmpty) return defaultValue;
    return res.first['nilai'] as String? ?? defaultValue;
  }

  Future<void> saveSetting(String key, String value) async {
    final db = await database;
    await db.insert('pengaturan', {'kunci': key, 'nilai': value},
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> insertBarang({
    required String nama,
    required int kategoriId,
    required int harga,
    required int stok,
  }) async {
    final db = await database;
    return db.insert('barang', {
      'nama': nama,
      'kategori_id': kategoriId,
      'harga': harga,
      'stok': stok,
    });
  }

  Future<List<Map<String, dynamic>>> listBarangJoinedKategori() async {
    final db = await database;
    return db.rawQuery('''
      SELECT 
        b.id as id,
        b.nama as nama_barang,
        b.harga as harga,
        b.stok as stok,
        k.nama as nama_kategori
      FROM barang b
      JOIN kategori k ON k.id = b.kategori_id
      ORDER BY b.id DESC
    ''');
  }

  Future<Map<String, dynamic>> getBarangById(int id) async {
    final db = await database;
    final rows = await db.query(
      'barang',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) {
      throw const AppDbException('Barang tidak ditemukan');
    }
    return rows.first;
  }

  Future<int> updateBarang({
    required int id,
    required String nama,
    required int kategoriId,
    required int harga,
    required int stok,
  }) async {
    final db = await database;
    return db.update(
      'barang',
      {
        'nama': nama,
        'kategori_id': kategoriId,
        'harga': harga,
        'stok': stok,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteBarang({required int id}) async {
    final db = await database;
    return db.delete('barang', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> insertPengguna({
    required String nama,
    required String username,
    required String passwordRaw,
  }) async {
    final db = await database;

    final passwordB64 = base64Encode(utf8.encode(passwordRaw));

    try {
      return await db.insert('pengguna', {
        'nama': nama,
        'username': username,
        'password_b64': passwordB64,
      });
    } catch (_) {
      throw const AppDbException('Username sudah dipakai');
    }
  }

  Future<List<Map<String, dynamic>>> listPengguna() async {
    final db = await database;
    return db.query('pengguna', orderBy: 'id DESC');
  }

  Future<Map<String, dynamic>> getPenggunaById(int id) async {
    final db = await database;
    final rows = await db.query(
      'pengguna',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) {
      throw const AppDbException('Pengguna tidak ditemukan');
    }
    return rows.first;
  }

  Future<int> updatePengguna({
    required int id,
    required String nama,
    required String username,
    String? passwordRawOrNull,
  }) async {
    final db = await database;

    final data = <String, Object?>{
      'nama': nama,
      'username': username,
    };

    if (passwordRawOrNull != null) {
      data['password_b64'] = base64Encode(utf8.encode(passwordRawOrNull));
    }

    try {
      return db.update(
        'pengguna',
        data,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (_) {
      throw const AppDbException('Username sudah dipakai');
    }
  }

  Future<int> deletePengguna({required int id}) async {
    final db = await database;
    return db.delete('pengguna', where: 'id = ?', whereArgs: [id]);
  }
}

String _formatRupiah(dynamic value) {
  int n = 0;
  try {
    if (value is int) {
      n = value;
    } else if (value is double) {
      n = value.toInt();
    } else if (value != null) {
      n = int.tryParse(value.toString()) ?? 0;
    }
  } catch (_) {
    n = 0;
  }

  String formatted = n.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.');
  return 'Rp$formatted';
}

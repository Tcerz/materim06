import 'package:flutter/material.dart';
import 'package:materim06/M09/profile_backend.dart'; // Import backend
import 'package:materim06/M09/profile_widget.dart'; // Import components

class EditProfilScreen extends StatefulWidget {
  final String uid;
  const EditProfilScreen({super.key, required this.uid});

  @override
  _EditProfilScreenState createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = ProfilService();

  final namaC = TextEditingController();
  final alamatC = TextEditingController();
  DateTime? tanggalLahir;

  List<String> hobiList = [];
  final hobiC = TextEditingController();

  List<Map<String, String>> riwayatList = [];
  final jenisC = TextEditingController();
  final ketC = TextEditingController();

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      final data = await _service.loadProfil(widget.uid);
      if (data != null) {
        namaC.text = data["nama"];
        alamatC.text = data["alamat"];
        tanggalLahir = data["tanggal_lahir"];
        hobiList = data["hobi"];
        riwayatList = data["riwayat"];
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("$e"), backgroundColor: Colors.red),
        );
      }
    } finally {
      setState(() => loading = false);
    }
  }

  Future<void> saveData() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await _service.saveProfil(
        uid: widget.uid,
        nama: namaC.text,
        alamat: alamatC.text,
        tanggalLahir: tanggalLahir,
        hobi: hobiList,
        riwayat: riwayatList,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Profil berhasil disimpan!"),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("$e"), backgroundColor: Colors.red),
      );
    }
  }

  void _showEditRiwayatDialog(int index) {
    final editJenisC = TextEditingController(text: riwayatList[index]["jenis"]);
    final editKetC = TextEditingController(
      text: riwayatList[index]["keterangan"],
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Edit Riwayat"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: editJenisC,
              decoration: const InputDecoration(
                labelText: "Jenis",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: editKetC,
              decoration: const InputDecoration(
                labelText: "Keterangan",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () {
              if (editJenisC.text.isNotEmpty && editKetC.text.isNotEmpty) {
                setState(() {
                  riwayatList[index] = {
                    "jenis": editJenisC.text,
                    "keterangan": editKetC.text,
                  };
                });
                Navigator.pop(context);
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text("Edit Profil"),
        elevation: 0,
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Data Pribadi
                    const SectionHeader(
                      icon: Icons.person,
                      title: "Data Pribadi",
                    ),
                    const SizedBox(height: 12),
                    NamaField(controller: namaC),
                    const SizedBox(height: 16),
                    AlamatField(controller: alamatC),
                    const SizedBox(height: 16),
                    TanggalLahirField(
                      tanggalLahir: tanggalLahir,
                      onDateSelected: (date) =>
                          setState(() => tanggalLahir = date),
                    ),
                    const SizedBox(height: 24),

                    // Hobi
                    const SectionHeader(icon: Icons.favorite, title: "Hobi"),
                    const SizedBox(height: 12),
                    HobiSection(
                      controller: hobiC,
                      hobiList: hobiList,
                      onAdd: () {
                        if (hobiC.text.isNotEmpty) {
                          setState(() {
                            hobiList.add(hobiC.text);
                            hobiC.clear();
                          });
                        }
                      },
                      onDelete: (hobi) => setState(() => hobiList.remove(hobi)),
                    ),
                    const SizedBox(height: 24),

                    // Riwayat
                    const SectionHeader(
                      icon: Icons.history_edu,
                      title: "Riwayat",
                    ),
                    const SizedBox(height: 12),
                    RiwayatSection(
                      jenisController: jenisC,
                      ketController: ketC,
                      riwayatList: riwayatList,
                      onAdd: () {
                        if (jenisC.text.isNotEmpty && ketC.text.isNotEmpty) {
                          setState(() {
                            riwayatList.add({
                              "jenis": jenisC.text,
                              "keterangan": ketC.text,
                            });
                            jenisC.clear();
                            ketC.clear();
                          });
                        }
                      },
                      onEdit: (index) => _showEditRiwayatDialog(index),
                      onDelete: (index) =>
                          setState(() => riwayatList.removeAt(index)),
                    ),
                    const SizedBox(height: 32),

                    // Tombol Simpan
                    SaveButton(onPressed: saveData),
                  ],
                ),
              ),
            ),
    );
  }

  @override
  void dispose() {
    namaC.dispose();
    alamatC.dispose();
    hobiC.dispose();
    jenisC.dispose();
    ketC.dispose();
    super.dispose();
  }
}

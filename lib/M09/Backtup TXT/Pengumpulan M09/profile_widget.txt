import 'package:flutter/material.dart';

// Widget untuk Section Header
class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;

  const SectionHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.blue.shade600, size: 24),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}

// Widget untuk Field Nama
class NamaField extends StatelessWidget {
  final TextEditingController controller;

  const NamaField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Nama Lengkap",
        prefixIcon: const Icon(Icons.badge),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Nama tidak boleh kosong";
        }
        return null;
      },
    );
  }
}

// Widget untuk Field Alamat
class AlamatField extends StatelessWidget {
  final TextEditingController controller;

  const AlamatField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: "Alamat",
        prefixIcon: const Icon(Icons.home),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      maxLines: 2,
    );
  }
}

// Widget untuk Field Tanggal Lahir
class TanggalLahirField extends StatelessWidget {
  final DateTime? tanggalLahir;
  final Function(DateTime?) onDateSelected;

  const TanggalLahirField({
    super.key,
    required this.tanggalLahir,
    required this.onDateSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, color: Colors.blue.shade600),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tanggal Lahir",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 4),
                Text(
                  tanggalLahir == null
                      ? "Belum dipilih"
                      : "${tanggalLahir!.day}/${tanggalLahir!.month}/${tanggalLahir!.year}",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () async {
              DateTime? date = await showDatePicker(
                context: context,
                initialDate: tanggalLahir ?? DateTime(2000, 1, 1),
                firstDate: DateTime(1950),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                onDateSelected(date);
              }
            },
            icon: const Icon(Icons.edit_calendar, size: 18),
            label: const Text("Pilih"),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Widget untuk Section Hobi
class HobiSection extends StatelessWidget {
  final TextEditingController controller;
  final List<String> hobiList;
  final VoidCallback onAdd;
  final Function(String) onDelete;

  const HobiSection({
    super.key,
    required this.controller,
    required this.hobiList,
    required this.onAdd,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    hintText: "Tambah hobi baru...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          if (hobiList.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: hobiList
                  .map(
                    (h) => Chip(
                      label: Text(h),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () => onDelete(h),
                      backgroundColor: Colors.blue.shade50,
                      labelStyle: TextStyle(color: Colors.blue.shade700),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}

// Widget untuk Section Riwayat
class RiwayatSection extends StatelessWidget {
  final TextEditingController jenisController;
  final TextEditingController ketController;
  final List<Map<String, String>> riwayatList;
  final VoidCallback onAdd;
  final Function(int) onEdit;
  final Function(int) onDelete;

  const RiwayatSection({
    super.key,
    required this.jenisController,
    required this.ketController,
    required this.riwayatList,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: jenisController,
                  decoration: InputDecoration(
                    hintText: "Jenis",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: ketController,
                  decoration: InputDecoration(
                    hintText: "Keterangan",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Icon(Icons.add),
              ),
            ],
          ),
          if (riwayatList.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: riwayatList.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = riwayatList[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade600,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item["jenis"]!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item["keterangan"]!,
                              style: TextStyle(
                                color: Colors.grey.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue.shade600,
                          size: 20,
                        ),
                        onPressed: () => onEdit(index),
                        tooltip: "Edit",
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                          size: 20,
                        ),
                        onPressed: () => onDelete(index),
                        tooltip: "Hapus",
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}

// Widget untuk Tombol Simpan
class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const SaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.save),
        label: const Text(
          "Simpan Profil",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }
}

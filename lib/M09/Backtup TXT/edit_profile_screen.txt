// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class EditProfilScreen extends StatefulWidget {
//   final String uid;
//   const EditProfilScreen({super.key, required this.uid});

//   @override
//   _EditProfilScreenState createState() => _EditProfilScreenState();
// }

// class _EditProfilScreenState extends State<EditProfilScreen> {
//   final _formKey = GlobalKey<FormState>();

//   // Controllers
//   final namaC = TextEditingController();
//   final alamatC = TextEditingController();
//   DateTime? tanggalLahir;

//   // Hobi
//   List<String> hobiList = [];
//   final hobiC = TextEditingController();

//   // Riwayat
//   List<Map<String, String>> riwayatList = [];
//   final jenisC = TextEditingController();
//   final ketC = TextEditingController();

//   bool loading = true;

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   Future<void> loadData() async {
//     final doc = await FirebaseFirestore.instance
//         .collection("mahasiswa")
//         .doc(widget.uid)
//         .get();

//     if (doc.exists) {
//       final data = doc.data() ?? {};

//       namaC.text = data["nama"] ?? "";
//       alamatC.text = data["alamat"] ?? "";

//       // TANGGAL LAHIR
//       if (data["tanggal_lahir"] is Timestamp) {
//         tanggalLahir = (data["tanggal_lahir"] as Timestamp).toDate();
//       }

//       // HOBI (list aman)
//       if (data["hobi"] is List) {
//         hobiList = List<String>.from(data["hobi"]);
//       }

//       // RIWAYAT (aman)
//       if (data["riwayat"] is List) {
//         riwayatList = (data["riwayat"] as List).map((item) {
//           return {
//             "jenis": item["jenis"]?.toString() ?? "",
//             "keterangan": item["keterangan"] == null
//                 ? ""
//                 : item["keterangan"].toString(),
//           };
//         }).toList();
//       }
//     }

//     setState(() => loading = false);
//   }

//   Future<void> saveData() async {
//     if (!_formKey.currentState!.validate()) return;

//     try {
//       await FirebaseFirestore.instance
//           .collection("mahasiswa")
//           .doc(widget.uid)
//           .set({
//             "nama": namaC.text,
//             "alamat": alamatC.text,
//             "tanggal_lahir": tanggalLahir,
//             "hobi": hobiList,
//             "riwayat": riwayatList,
//           });

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Profil berhasil disimpan!"),
//           backgroundColor: Colors.green,
//         ),
//       );

//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text("Gagal menyimpan: $e"),
//           backgroundColor: Colors.red,
//         ),
//       );
//     }
//   }

//   void _showEditRiwayatDialog(int index) {
//     final editJenisC = TextEditingController(text: riwayatList[index]["jenis"]);
//     final editKetC = TextEditingController(
//       text: riwayatList[index]["keterangan"],
//     );

//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text("Edit Riwayat"),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             TextField(
//               controller: editJenisC,
//               decoration: const InputDecoration(
//                 labelText: "Jenis",
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 12),
//             TextField(
//               controller: editKetC,
//               decoration: const InputDecoration(
//                 labelText: "Keterangan",
//                 border: OutlineInputBorder(),
//               ),
//               maxLines: 2,
//             ),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Batal"),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               if (editJenisC.text.isNotEmpty && editKetC.text.isNotEmpty) {
//                 setState(() {
//                   riwayatList[index] = {
//                     "jenis": editJenisC.text,
//                     "keterangan": editKetC.text,
//                   };
//                 });
//                 Navigator.pop(context);
//               }
//             },
//             child: const Text("Simpan"),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       appBar: AppBar(
//         title: const Text("Edit Profil"),
//         elevation: 0,
//         backgroundColor: Colors.blue.shade600,
//         foregroundColor: Colors.white,
//       ),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : SingleChildScrollView(
//               padding: const EdgeInsets.all(20),
//               child: Form(
//                 key: _formKey,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // SECTION: Data Pribadi
//                     _buildSectionHeader(Icons.person, "Data Pribadi"),
//                     const SizedBox(height: 12),

//                     // Nama
//                     TextFormField(
//                       controller: namaC,
//                       decoration: InputDecoration(
//                         labelText: "Nama Lengkap",
//                         prefixIcon: const Icon(Icons.badge),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return "Nama tidak boleh kosong";
//                         }
//                         return null;
//                       },
//                     ),
//                     const SizedBox(height: 16),

//                     // Alamat
//                     TextFormField(
//                       controller: alamatC,
//                       decoration: InputDecoration(
//                         labelText: "Alamat",
//                         prefixIcon: const Icon(Icons.home),
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         filled: true,
//                         fillColor: Colors.white,
//                       ),
//                       maxLines: 2,
//                     ),
//                     const SizedBox(height: 16),

//                     // Tanggal Lahir
//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             Icons.calendar_today,
//                             color: Colors.blue.shade600,
//                           ),
//                           const SizedBox(width: 12),
//                           Expanded(
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   "Tanggal Lahir",
//                                   style: TextStyle(
//                                     fontSize: 12,
//                                     color: Colors.grey.shade600,
//                                   ),
//                                 ),
//                                 const SizedBox(height: 4),
//                                 Text(
//                                   tanggalLahir == null
//                                       ? "Belum dipilih"
//                                       : "${tanggalLahir!.day}/${tanggalLahir!.month}/${tanggalLahir!.year}",
//                                   style: const TextStyle(
//                                     fontSize: 16,
//                                     fontWeight: FontWeight.w500,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           ElevatedButton.icon(
//                             onPressed: () async {
//                               DateTime? date = await showDatePicker(
//                                 context: context,
//                                 initialDate:
//                                     tanggalLahir ?? DateTime(2000, 1, 1),
//                                 firstDate: DateTime(1950),
//                                 lastDate: DateTime.now(),
//                               );
//                               if (date != null) {
//                                 setState(() => tanggalLahir = date);
//                               }
//                             },
//                             icon: const Icon(Icons.edit_calendar, size: 18),
//                             label: const Text("Pilih"),
//                             style: ElevatedButton.styleFrom(
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(8),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // SECTION: Hobi
//                     _buildSectionHeader(Icons.favorite, "Hobi"),
//                     const SizedBox(height: 12),

//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: TextField(
//                                   controller: hobiC,
//                                   decoration: InputDecoration(
//                                     hintText: "Tambah hobi baru...",
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     contentPadding: const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 8,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   if (hobiC.text.isNotEmpty) {
//                                     setState(() {
//                                       hobiList.add(hobiC.text);
//                                       hobiC.clear();
//                                     });
//                                   }
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   padding: const EdgeInsets.all(12),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 child: const Icon(Icons.add),
//                               ),
//                             ],
//                           ),
//                           if (hobiList.isNotEmpty) ...[
//                             const SizedBox(height: 12),
//                             Wrap(
//                               spacing: 8,
//                               runSpacing: 8,
//                               children: hobiList
//                                   .map(
//                                     (h) => Chip(
//                                       label: Text(h),
//                                       deleteIcon: const Icon(
//                                         Icons.close,
//                                         size: 18,
//                                       ),
//                                       onDeleted: () {
//                                         setState(() => hobiList.remove(h));
//                                       },
//                                       backgroundColor: Colors.blue.shade50,
//                                       labelStyle: TextStyle(
//                                         color: Colors.blue.shade700,
//                                       ),
//                                     ),
//                                   )
//                                   .toList(),
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 24),

//                     // SECTION: Riwayat
//                     _buildSectionHeader(Icons.history_edu, "Riwayat"),
//                     const SizedBox(height: 12),

//                     Container(
//                       padding: const EdgeInsets.all(16),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         border: Border.all(color: Colors.grey.shade300),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               Expanded(
//                                 child: TextField(
//                                   controller: jenisC,
//                                   decoration: InputDecoration(
//                                     hintText: "Jenis",
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     contentPadding: const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 8,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               Expanded(
//                                 child: TextField(
//                                   controller: ketC,
//                                   decoration: InputDecoration(
//                                     hintText: "Keterangan",
//                                     border: OutlineInputBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                     contentPadding: const EdgeInsets.symmetric(
//                                       horizontal: 12,
//                                       vertical: 8,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               const SizedBox(width: 8),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   if (jenisC.text.isNotEmpty &&
//                                       ketC.text.isNotEmpty) {
//                                     setState(() {
//                                       riwayatList.add({
//                                         "jenis": jenisC.text,
//                                         "keterangan": ketC.text,
//                                       });
//                                       jenisC.clear();
//                                       ketC.clear();
//                                     });
//                                   }
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   padding: const EdgeInsets.all(12),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                 ),
//                                 child: const Icon(Icons.add),
//                               ),
//                             ],
//                           ),

//                           if (riwayatList.isNotEmpty) ...[
//                             const SizedBox(height: 16),
//                             const Divider(),
//                             const SizedBox(height: 8),
//                             ListView.separated(
//                               shrinkWrap: true,
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemCount: riwayatList.length,
//                               separatorBuilder: (_, __) =>
//                                   const SizedBox(height: 8),
//                               itemBuilder: (context, index) {
//                                 final item = riwayatList[index];
//                                 return Container(
//                                   padding: const EdgeInsets.all(12),
//                                   decoration: BoxDecoration(
//                                     color: Colors.grey.shade50,
//                                     borderRadius: BorderRadius.circular(8),
//                                   ),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         width: 8,
//                                         height: 8,
//                                         decoration: BoxDecoration(
//                                           color: Colors.blue.shade600,
//                                           shape: BoxShape.circle,
//                                         ),
//                                       ),
//                                       const SizedBox(width: 12),
//                                       Expanded(
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               item["jenis"]!,
//                                               style: const TextStyle(
//                                                 fontWeight: FontWeight.bold,
//                                                 fontSize: 15,
//                                               ),
//                                             ),
//                                             const SizedBox(height: 2),
//                                             Text(
//                                               item["keterangan"]!,
//                                               style: TextStyle(
//                                                 color: Colors.grey.shade700,
//                                                 fontSize: 14,
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                       IconButton(
//                                         icon: Icon(
//                                           Icons.edit,
//                                           color: Colors.blue.shade600,
//                                           size: 20,
//                                         ),
//                                         onPressed: () =>
//                                             _showEditRiwayatDialog(index),
//                                         tooltip: "Edit",
//                                       ),
//                                       IconButton(
//                                         icon: const Icon(
//                                           Icons.delete,
//                                           color: Colors.red,
//                                           size: 20,
//                                         ),
//                                         onPressed: () {
//                                           setState(() {
//                                             riwayatList.removeAt(index);
//                                           });
//                                         },
//                                         tooltip: "Hapus",
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ],
//                         ],
//                       ),
//                     ),

//                     const SizedBox(height: 32),

//                     // Tombol Simpan
//                     SizedBox(
//                       width: double.infinity,
//                       child: ElevatedButton.icon(
//                         onPressed: saveData,
//                         icon: const Icon(Icons.save),
//                         label: const Text(
//                           "Simpan Profil",
//                           style: TextStyle(
//                             fontSize: 16,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           backgroundColor: Colors.blue.shade600,
//                           foregroundColor: Colors.white,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//     );
//   }

//   Widget _buildSectionHeader(IconData icon, String title) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.blue.shade600, size: 24),
//         const SizedBox(width: 8),
//         Text(
//           title,
//           style: const TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     namaC.dispose();
//     alamatC.dispose();
//     hobiC.dispose();
//     jenisC.dispose();
//     ketC.dispose();
//     super.dispose();
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';

class MahasiswaModel {
  final String? nama;
  final String? alamat;
  final DateTime? tanggalLahir;
  final List<String> hobi;
  final List<Map<String, String>> riwayat;

  MahasiswaModel({
    this.nama,
    this.alamat,
    this.tanggalLahir,
    this.hobi = const [],
    this.riwayat = const [],
  });

  // 🔥 Convert Firestore → Model
  factory MahasiswaModel.fromFirestore(Map<String, dynamic> data) {
    return MahasiswaModel(
      nama: data["nama"],
      alamat: data["alamat"],
      tanggalLahir: data["tanggal_lahir"] is Timestamp
          ? (data["tanggal_lahir"] as Timestamp).toDate()
          : null,
      hobi: data["hobi"] != null ? List<String>.from(data["hobi"]) : [],
      riwayat: data["riwayat"] != null
          ? List<Map<String, String>>.from(
              (data["riwayat"] as List).map(
                (item) => {
                  "jenis": item["jenis"]?.toString() ?? "",
                  "keterangan": item["keterangan"]?.toString() ?? "",
                },
              ),
            )
          : [],
    );
  }

  // 🔥 Convert Model → Firestore
  Map<String, dynamic> toFirestore() {
    return {
      "nama": nama,
      "alamat": alamat,
      "tanggal_lahir": tanggalLahir,
      "hobi": hobi,
      "riwayat": riwayat,
    };
  }
}

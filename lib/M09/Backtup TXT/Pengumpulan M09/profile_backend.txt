import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fungsi untuk memuat data profil dari Firestore
  Future<Map<String, dynamic>?> loadProfil(String uid) async {
    try {
      final doc = await _firestore.collection("mahasiswa").doc(uid).get();

      if (!doc.exists) return null;

      final data = doc.data() ?? {};

      return {
        "nama": data["nama"] ?? "",
        "alamat": data["alamat"] ?? "",
        "tanggal_lahir": data["tanggal_lahir"] is Timestamp
            ? (data["tanggal_lahir"] as Timestamp).toDate()
            : null,
        "hobi": data["hobi"] is List
            ? List<String>.from(data["hobi"])
            : <String>[],
        "riwayat": data["riwayat"] is List
            ? (data["riwayat"] as List).map((item) {
                return {
                  "jenis": item["jenis"]?.toString() ?? "",
                  "keterangan": item["keterangan"]?.toString() ?? "",
                };
              }).toList()
            : <Map<String, String>>[],
      };
    } catch (e) {
      throw Exception("Gagal memuat data: $e");
    }
  }

  // Fungsi untuk menyimpan data profil ke Firestore
  Future<void> saveProfil({
    required String uid,
    required String nama,
    required String alamat,
    required DateTime? tanggalLahir,
    required List<String> hobi,
    required List<Map<String, String>> riwayat,
  }) async {
    try {
      await _firestore.collection("mahasiswa").doc(uid).set({
        "nama": nama,
        "alamat": alamat,
        "tanggal_lahir": tanggalLahir,
        "hobi": hobi,
        "riwayat": riwayat,
      });
    } catch (e) {
      throw Exception("Gagal menyimpan data: $e");
    }
  }
}

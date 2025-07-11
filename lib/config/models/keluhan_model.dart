class KeluhanModel {
  final int id;
  final String judul;
  final String isi;
  final String tanggal;
  final String? filePendukung;
  final String? fileHasil;
  final String lokasi;
  final String kategori;
  final String? status;
  final String idAkun;
  final DateTime createdAt;
  final DateTime updatedAt;

  KeluhanModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.tanggal,
    required this.status,
    this.filePendukung,
    this.fileHasil,
    required this.lokasi,
    required this.kategori,
    required this.idAkun,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KeluhanModel.fromJson(Map<String, dynamic> json) {
    return KeluhanModel(
      id: json['id'],
      judul: json['judul'],
      isi: json['isi'],
      tanggal: json['tanggal'],
      filePendukung: json['file_pendukung'],
      fileHasil: json['file_hasil'],
      lokasi: json['lokasi'],
      kategori: json['kategori'],
      idAkun: json['id_akun'].toString(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class AspirasiModel {
  final int id;
  final String judul;
  final String isi;
  final String? filePendukung;
  final String? fileHasil;
  final String status;
  final String idAkun;
  final DateTime createdAt;
  final DateTime updatedAt;

  AspirasiModel({
    required this.id,
    required this.judul,
    required this.isi,
    required this.status,
    this.filePendukung,
    this.fileHasil,
    required this.idAkun,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AspirasiModel.fromJson(Map<String, dynamic> json) {
    return AspirasiModel(
      id: json['id'],
      judul: json['judul'],
      isi: json['isi'],
      filePendukung: json['file_pendukung'],
      fileHasil: json['file_hasil'],
      idAkun: json['id_akun'].toString(),
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

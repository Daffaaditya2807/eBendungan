class IzinUsahaModel {
  final int id;
  final String nama;
  final String tempatLahir;
  final String tanggalLahir;
  final String pekerjaan;
  final String nik;
  final String alamat;
  final String usaha;
  final String status;
  final String? filePendukung;
  final String? fileHasil;
  final String idAkun;
  final String createdAt;
  final String updatedAt;

  IzinUsahaModel({
    required this.id,
    required this.nama,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.pekerjaan,
    required this.nik,
    required this.alamat,
    required this.usaha,
    required this.status,
    this.filePendukung,
    this.fileHasil,
    required this.idAkun,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IzinUsahaModel.fromJson(Map<String, dynamic> json) {
    return IzinUsahaModel(
      id: json['id'],
      nama: json['nama'],
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'],
      pekerjaan: json['pekerjaan'],
      nik: json['NIK'],
      alamat: json['alamat'],
      usaha: json['usaha'],
      status: json['status'],
      filePendukung: json['file_pendukung'],
      fileHasil: json['file_hasil'],
      idAkun: json['id_akun'].toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

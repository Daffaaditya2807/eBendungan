class SkckModel {
  final int id;
  final String nama;
  final String tanggalLahir;
  final String tempatLahir;
  final String jenisKelamin;
  final String statusPerkawinan;
  final String suku;
  final String agama;
  final String pendidikan;
  final String pekerjaan;
  final String nik;
  final String alamat;
  final String filePendukung;
  final String status;
  final String? fileHasil;
  final String idAkun;
  final String createdAt;
  final String? updatedAt;

  SkckModel({
    required this.id,
    required this.nama,
    required this.tanggalLahir,
    required this.tempatLahir,
    required this.jenisKelamin,
    required this.statusPerkawinan,
    required this.suku,
    required this.agama,
    required this.pendidikan,
    required this.pekerjaan,
    required this.nik,
    required this.alamat,
    required this.filePendukung,
    required this.status,
    this.fileHasil,
    required this.idAkun,
    required this.createdAt,
    this.updatedAt,
  });

  factory SkckModel.fromJson(Map<String, dynamic> json) {
    return SkckModel(
      id: json['id'],
      nama: json['nama'],
      tanggalLahir: json['tanggal_lahir'],
      tempatLahir: json['tempat_lahir'],
      jenisKelamin: json['jenis_kelamin'],
      statusPerkawinan: json['status_perkawinan'],
      suku: json['suku'],
      agama: json['agama'],
      pendidikan: json['pendidikan'],
      pekerjaan: json['pekerjaan'],
      nik: json['NIK'],
      alamat: json['alamat'],
      filePendukung: json['file_pendukung'],
      status: json['status'],
      fileHasil: json['file_hasil'],
      idAkun: json['id_akun'].toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

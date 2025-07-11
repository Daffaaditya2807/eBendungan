class IzinPembelianSolarModel {
  final int id;
  final String nama;
  final String tempatLahir;
  final String tanggalLahir;
  final String nik;
  final String? filePendukung;
  final String status;
  final String? fileHasil;
  final String alamat;
  final String idAkun;
  final String createdAt;
  final String updatedAt;

  IzinPembelianSolarModel({
    required this.id,
    required this.nama,
    required this.tempatLahir,
    required this.tanggalLahir,
    required this.nik,
    this.filePendukung,
    required this.status,
    this.fileHasil,
    required this.alamat,
    required this.idAkun,
    required this.createdAt,
    required this.updatedAt,
  });

  factory IzinPembelianSolarModel.fromJson(Map<String, dynamic> json) {
    return IzinPembelianSolarModel(
      id: json['id'],
      nama: json['nama'],
      tempatLahir: json['tempat_lahir'],
      tanggalLahir: json['tanggal_lahir'],
      nik: json['NIK'],
      filePendukung: json['file_pendukung'],
      status: json['status'],
      fileHasil: json['file_hasil'],
      alamat: json['alamat'],
      idAkun: json['id_akun'].toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

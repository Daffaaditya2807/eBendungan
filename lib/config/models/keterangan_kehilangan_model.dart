class KeteranganKehilanganModel {
  final int id;
  final String tanggalLahir;
  final String tempatLahir;
  final String jenisKelamin;
  final String agama;
  final String pekerjaan;
  final String nama;
  final String nik;
  final String alamat;
  final String filePendukung;
  final String status;
  String? fileHasil;
  final String keterangan;
  final String idAkun;
  final String createdAt;
  final String? updatedAt;

  KeteranganKehilanganModel({
    required this.id,
    required this.tanggalLahir,
    required this.tempatLahir,
    required this.jenisKelamin,
    required this.agama,
    required this.pekerjaan,
    required this.nama,
    required this.nik,
    required this.alamat,
    required this.filePendukung,
    required this.status,
    this.fileHasil,
    required this.keterangan,
    required this.idAkun,
    required this.createdAt,
    this.updatedAt,
  });

  factory KeteranganKehilanganModel.fromJson(Map<String, dynamic> json) {
    return KeteranganKehilanganModel(
      id: json['id'],
      tanggalLahir: json['tanggal_lahir'],
      tempatLahir: json['tempat_lahir'],
      jenisKelamin: json['jenis_kelamin'],
      agama: json['agama'],
      pekerjaan: json['pekerjaan'],
      nama: json['nama'],
      nik: json['NIK'],
      alamat: json['alamat'],
      filePendukung: json['file_pendukung'],
      status: json['status'],
      fileHasil: json['file_hasil'],
      keterangan: json['keterangan'],
      idAkun: json['id_akun'].toString(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

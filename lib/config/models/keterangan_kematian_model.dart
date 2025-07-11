class KeteranganKematianModel {
  final int id;
  final String nama;
  final String usia;
  final String jenisKelamin;
  final String alamatTerakhir;
  final String hari;
  final String tanggalKematian;
  final String bertempat;
  final String disebabkan;
  final String? filePendukung;
  final String status;
  final String? fileHasil;
  final String idAkun;
  final String createdAt;
  final String updatedAt;

  KeteranganKematianModel({
    required this.id,
    required this.nama,
    required this.usia,
    required this.jenisKelamin,
    required this.alamatTerakhir,
    required this.hari,
    required this.tanggalKematian,
    required this.bertempat,
    required this.disebabkan,
    this.filePendukung,
    required this.status,
    this.fileHasil,
    required this.idAkun,
    required this.createdAt,
    required this.updatedAt,
  });

  factory KeteranganKematianModel.fromJson(Map<String, dynamic> json) {
    return KeteranganKematianModel(
      id: json['id'],
      nama: json['nama'],
      usia: json['usia'].toString(),
      jenisKelamin: json['jenis_kelamin'],
      alamatTerakhir: json['alamat_terakhir'],
      hari: json['hari'],
      tanggalKematian: json['tanggal_kematian'],
      bertempat: json['bertempat'],
      disebabkan: json['disebabkan'],
      filePendukung: json['file_pendukung'],
      status: json['status'],
      fileHasil: json['file_hasil'],
      idAkun: json['id_akun'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}

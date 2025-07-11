class InformationModel {
  final int id;
  final String tanggal;
  final String judul;
  final String isi;
  final String kategori;
  final String idAkun;
  final String? urlGambar;

  InformationModel(
      {required this.id,
      required this.tanggal,
      required this.judul,
      required this.isi,
      required this.kategori,
      required this.idAkun,
      this.urlGambar});

  factory InformationModel.fromJson(Map<String, dynamic> json) {
    return InformationModel(
        id: json['id'],
        tanggal: json['created_at'],
        judul: json['judul'],
        isi: json['isi_berita'],
        kategori: json['kategori_berita'],
        idAkun: json['id_akun'].toString(),
        urlGambar: json['gambar_url']);
  }
}

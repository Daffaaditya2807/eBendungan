class Users {
  final int idUser;
  final String password;
  final String email;
  final String nama;
  final String noTelp;
  final String fotoProfil;

  Users(
      {required this.idUser,
      required this.password,
      required this.email,
      required this.nama,
      required this.noTelp,
      required this.fotoProfil});

  factory Users.fromJson(Map<String, dynamic> json) {
    return Users(
        idUser: json['id'],
        password: json['password'],
        email: json['email'],
        nama: json['nama'],
        noTelp: json['no_telepon'],
        fotoProfil: json['foto_profil']);
  }
  Map<String, dynamic> toJson() {
    return {
      'id': idUser,
      'password': password,
      'email': email,
      'nama': nama,
      'no_telepon': noTelp,
      'foto_profil': fotoProfil
    };
  }
}

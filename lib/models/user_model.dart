class User {
  final String id;
  final String nama;
  final String email;
  final String roleId;
  final String fotoUrl;

  User({
    required this.id, 
    required this.nama, 
    required this.email,
    required this.roleId,
    required this.fotoUrl
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(),
      nama: json['nama'],
      email: json['email'] ?? "",
      roleId: json['role_id'].toString(),
      fotoUrl: json['foto_url'] ?? "",
    );
  }
}
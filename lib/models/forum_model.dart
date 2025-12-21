class ForumModel {
  final String id;
  final String userId;
  String judul;
  String deskripsi;
  final String? gambar;
  final String createdAt;
  final String namaPenulis;
  final String fotoProfilUrl;
  final String? gambarUrl;
  
  int totalKomentar; 
  int totalLikes;
  bool isLikedByMe;

  ForumModel({
    required this.id,
    required this.userId,
    required this.judul,
    required this.deskripsi,
    this.gambar,
    required this.createdAt,
    required this.namaPenulis,
    required this.fotoProfilUrl,
    this.gambarUrl,
    required this.totalKomentar,
    required this.totalLikes,
    required this.isLikedByMe,
  });

  factory ForumModel.fromJson(Map<String, dynamic> json) {
    return ForumModel(
      id: json['id'].toString(),
      userId: json['user_id'].toString(),
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      gambar: json['gambar'],
      createdAt: json['created_at'] ?? '',
      namaPenulis: json['nama'] ?? 'Tanpa Nama',
      fotoProfilUrl: json['foto_profil_url'] ?? '',
      gambarUrl: json['gambar_url'],
      totalKomentar: int.parse(json['total_komentar'].toString()),
      totalLikes: int.parse(json['total_likes'].toString()),
      isLikedByMe: int.parse(json['is_liked_by_me'].toString()) > 0,
    );
  }
}
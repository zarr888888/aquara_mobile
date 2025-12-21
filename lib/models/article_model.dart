class Article {
  final String id;
  final String judul;
  final String konten;
  final String gambarUrl;
  final String penulis;
  final String tanggal;

  Article({
    required this.id,
    required this.judul,
    required this.konten,
    required this.gambarUrl,
    required this.penulis,
    required this.tanggal,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'].toString(),
      judul: json['judul'] ?? "Tanpa Judul",
      // Ambil konten bersih (tanpa tag HTML) jika ada, atau konten biasa
      konten: json['konten_bersih'] ?? json['konten'] ?? "",
      gambarUrl: json['gambar_url'] ?? "", 
      penulis: json['penulis'] ?? "Admin",
      tanggal: json['created_at'] ?? "",
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/article_provider.dart';
import '../models/article_model.dart';
import 'article_detail_screen.dart';

class ArticleScreen extends StatefulWidget {
  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  @override
  void initState() {
    super.initState();
    // Otomatis panggil data saat halaman dibuka
    Future.microtask(() =>
        Provider.of<ArticleProvider>(context, listen: false).fetchArticles());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Artikel Terkini", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF013746), // Teal Tua
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF0F4F8),
      body: Consumer<ArticleProvider>(
        builder: (context, provider, child) {
          // 1. Loading State
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator(color: Color(0xFF3F8686)));
          }

          // 2. Empty State
          if (provider.articles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.article_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text("Belum ada artikel.", style: GoogleFonts.poppins(color: Colors.grey)),
                ],
              ),
            );
          }

          // 3. Data List State
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: provider.articles.length,
            itemBuilder: (context, index) {
              final article = provider.articles[index];
              return _buildArticleCard(article);
            },
          );
        },
      ),
    );
  }

  Widget _buildArticleCard(Article article) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1), 
              blurRadius: 10, 
              offset: Offset(0, 5)
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GAMBAR ARTIKEL
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                article.gambarUrl,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, stack) => Container(
                  height: 180,
                  color: Colors.grey[200],
                  child: Center(
                    child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey)
                  ),
                ),
              ),
            ),
            
            // KONTEN TEKS
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(
                    article.judul,
                    style: GoogleFonts.poppins(
                      fontSize: 18, 
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF013746),
                      height: 1.3,
                    ),
                  ),
                  SizedBox(height: 8),
                  
                  // Isi Singkat
                  Text(
                    article.konten,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 13),
                  ),
                  
                  SizedBox(height: 16),
                  
                  // Footer (Penulis & Tanggal)
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 10,
                        backgroundColor: Color(0xFF3F8686),
                        child: Icon(Icons.person, size: 12, color: Colors.white),
                      ),
                      SizedBox(width: 6),
                      Text(
                        article.penulis, 
                        style: GoogleFonts.poppins(fontSize: 12, fontWeight: FontWeight.w500)
                      ),
                      Spacer(),
                      Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                      SizedBox(width: 4),
                      // Ambil tanggal saja (YYYY-MM-DD)
                      Text(
                        article.tanggal.length > 10 
                            ? article.tanggal.substring(0, 10) 
                            : article.tanggal,
                        style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
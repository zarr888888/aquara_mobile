import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart'; 
import 'dart:ui'; 

// IMPORT SCREEN
import 'login_screen.dart';
import 'profile_screen.dart';
import 'article_screen.dart';
import 'forum_screen.dart';
import 'calculator_screen.dart'; 
import 'event_screen.dart'; 

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String userName = "";
  String userFoto = "";
  late AnimationController _headerAnimCtrl;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _headerAnimCtrl = AnimationController(
      vsync: this, 
      duration: Duration(seconds: 1)
    )..forward();
  }

  // UPDATE: FUNGSI LOAD DATA LEBIH KUAT
  _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.reload(); // Paksa refresh data dari disk agar tidak nyangkut
    setState(() {
      userName = prefs.getString('userName') ?? "Sobat AQUARA";
      userFoto = prefs.getString('userFoto') ?? "";
    });
  }

  Future<void> _openWhatsApp() async {
    String phoneNumber = "6285321820026"; 
    String message = "Halo Pakar AQUARA, saya ingin berkonsultasi mengenai budidaya ikan.";
    final Uri url = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal membuka WhatsApp atau WA tidak terinstall."))
      );
    }
  }

  void _confirmLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Konfirmasi Logout", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: Text("Apakah Anda yakin ingin keluar dari aplikasi?", style: GoogleFonts.poppins()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: Text("Batal", style: GoogleFonts.poppins(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx); 
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (c) => LoginScreen())
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: Text("Ya, Keluar", style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _headerAnimCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF0F4F8),
      body: Stack(
        children: [
          // HEADER WAVE ANIMATED
          SlideTransition(
            position: Tween<Offset>(begin: Offset(0, -0.5), end: Offset.zero)
                .animate(CurvedAnimation(parent: _headerAnimCtrl, curve: Curves.elasticOut)),
            child: ClipPath(
              clipper: ModernWaveClipper(),
              child: Container(
                height: 320, 
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF013746), Color(0xFF3F8686)],
                  ),
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // TOP BAR: Salam & Profil
                Padding(
                  padding: EdgeInsets.fromLTRB(24, 20, 24, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start, 
                        children: [
                          Text("Selamat Datang,", style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14)),
                          SizedBox(height: 4),
                          Text(
                            userName, 
                            style: GoogleFonts.poppins(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)
                          ),
                        ],
                      ),
                      
                      // UPDATE: NAVIGASI PROFIL
                      GestureDetector(
                        onTap: () async {
                          // Pakai 'await' supaya Home MENUNGGU sampai user selesai edit profil
                          await Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (c) => ProfileScreen())
                          );
                          // Setelah user kembali, JALANKAN INI:
                          _loadUserData(); 
                        },
                        child: Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, 
                            border: Border.all(color: Colors.cyanAccent, width: 2),
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)]
                          ),
                          child: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: userFoto.isNotEmpty 
                                ? NetworkImage(userFoto) 
                                : AssetImage('assets/images/default.png') as ImageProvider,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // BANNER CARD
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: FadeTransition(
                    opacity: _headerAnimCtrl,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(color: Color(0xFF013746).withOpacity(0.15), blurRadius: 20, offset: Offset(0, 10))
                        ],
                      ),
                      child: Row(children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, 
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(color: Color(0xFFE0F7FA), borderRadius: BorderRadius.circular(8)),
                                child: Text("Edukasi & Komunitas", style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF013746))),
                              ),
                              SizedBox(height: 10),
                              Text("Budidaya Modern\nHasil Melimpah!", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF013746))),
                            ]
                          )
                        ),
                        Image.asset(
                          'assets/images/logo.png', 
                          width: 70, 
                          errorBuilder: (c,e,s) => Icon(Icons.water, size: 50, color: Colors.teal)
                        ),
                      ]),
                    ),
                  ),
                ),

                SizedBox(height: 30),
                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24), 
                  child: Text("Layanan Utama", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromARGB(0xFF013746, 0, 0, 0))),
                ),
                SizedBox(height: 16),

                // GRID MENU
                Expanded(
                  child: GridView.count(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    crossAxisCount: 2, 
                    crossAxisSpacing: 16, 
                    mainAxisSpacing: 16, 
                    childAspectRatio: 1.3,
                    children: [
                      _buildBouncyCard(Icons.article_rounded, "Artikel", Colors.blue, 0, () { 
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleScreen()));
                      }),
                      
                      _buildBouncyCard(Icons.forum_rounded, "Forum", Colors.orange, 1, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ForumScreen()));
                      }),
                      
                      _buildBouncyCard(Icons.event_available_rounded, "Event", Colors.purple, 2, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EventScreen()));
                      }),

                      _buildBouncyCard(Icons.support_agent_rounded, "Konsultasi", Colors.green, 3, () {
                        _openWhatsApp(); 
                      }),
                      
                      _buildBouncyCard(Icons.calculate_rounded, "Kalkulator", Colors.red, 4, () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CalculatorScreen()));
                      }),
                      
                      _buildBouncyCard(Icons.logout_rounded, "Logout", Colors.grey, 5, () {
                        _confirmLogout(); 
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBouncyCard(IconData icon, String label, Color color, int index, VoidCallback onTap) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + (index * 100)),
      curve: Curves.easeOutBack,
      builder: (context, double value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(opacity: value.clamp(0.0, 1.0), child: child),
        );
      },
      child: BouncyButton(
        onTap: () {
          if (label != "Konsultasi" && label != "Logout") {
             _showModernNotif(label); 
          }
          onTap();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 10, offset: Offset(0, 5))],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              SizedBox(height: 12),
              Text(label, style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87)),
            ],
          ),
        ),
      ),
    );
  }

  void _showModernNotif(String menu) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Color(0xFF013746),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      content: Row(children: [
        Icon(Icons.touch_app, color: Colors.cyanAccent),
        SizedBox(width: 10),
        Text("Membuka $menu...", style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ]),
      duration: Duration(seconds: 1),
    ));
  }
}

class BouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  const BouncyButton({required this.child, required this.onTap});
  @override
  _BouncyButtonState createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.1, 
    );
    _controller.addListener(() { setState(() {}); });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double scale = 1 - _controller.value;

    return GestureDetector(
      onTapDown: (_) => _controller.forward(),
      onTapUp: (_) { 
        _controller.reverse(); 
        widget.onTap(); 
      },
      onTapCancel: () => _controller.reverse(),
      child: Transform.scale(
        scale: scale, 
        child: widget.child
      ),
    );
  }
}

class ModernWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 4, size.height, size.width / 2, size.height - 50);
    path.quadraticBezierTo(3 * size.width / 4, size.height - 100, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
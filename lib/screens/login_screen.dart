import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/auth_provider.dart';
import 'home_screen.dart';
import 'register_screen.dart'; 

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with TickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  // Animation Controllers
  late AnimationController _bgController;
  late AnimationController _logoController;
  late Animation<double> _logoScale;
  bool _isObscure = true;

  @override
  void initState() {
    super.initState();
    // 1. Animasi Background Berputar
    _bgController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();

    // 2. Animasi Logo "Bernafas"
    _logoController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _logoScale = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _bgController.dispose();
    _logoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // BACKGROUND ANIMASI
          AnimatedBuilder(
            animation: _bgController,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF013746), // Teal Tua
                      Color(0xFF004d61),
                      Color(0xFF013746),
                    ],
                    transform: GradientRotation(_bgController.value * 2 * pi),
                  ),
                ),
              );
            },
          ),
          
          // Partikel Mengambang (Hiasan)
          Positioned(top: -50, left: -50, child: _buildGlowingCircle(200)),
          Positioned(bottom: -50, right: -50, child: _buildGlowingCircle(250)),

          // KONTEN
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo Animasi
                  ScaleTransition(
                    scale: _logoScale,
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        boxShadow: [
                          BoxShadow(color: Color(0xFF3F8686).withOpacity(0.6), blurRadius: 30, spreadRadius: 5)
                        ],
                        border: Border.all(color: Colors.white.withOpacity(0.2)),
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 80, height: 80,
                        errorBuilder: (c,e,s) => Icon(Icons.water_drop, size: 60, color: Colors.cyanAccent),
                      ),
                    ),
                  ),
                  SizedBox(height: 25),
                  
                  Text("AQUARA",
                    style: GoogleFonts.orbitron( // Font Futuristik
                      fontSize: 40, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 3,
                      shadows: [Shadow(color: Colors.cyan, blurRadius: 15)]
                    ),
                  ),
                  Text("Future of Aqua-Farming",
                    style: GoogleFonts.poppins(color: Colors.cyanAccent, fontSize: 14, letterSpacing: 1),
                  ),
                  
                  SizedBox(height: 50),

                  // Form Glassmorphism
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.all(30),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.05),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withOpacity(0.1)),
                        ),
                        child: Column(
                          children: [
                            _buildNeonInput(_emailController, Icons.email_rounded, "Email Address", false),
                            SizedBox(height: 20),
                            _buildNeonInput(_passwordController, Icons.lock_rounded, "Password", true),
                            SizedBox(height: 30),

                            // Tombol Login
                            SizedBox(
                              width: double.infinity,
                              height: 55,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF3F8686),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                                  elevation: 10,
                                  shadowColor: Colors.cyanAccent.withOpacity(0.5),
                                ),
                                onPressed: authProvider.isLoading ? null : () async {
                                  if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
                                    _showCustomNotif(context, "Isi email & password dulu!", isError: true);
                                    return;
                                  }
                                  bool success = await authProvider.login(_emailController.text, _passwordController.text);
                                  if (success) {
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (c) => HomeScreen()));
                                  } else {
                                    _showCustomNotif(context, "Login Gagal. Cek data lagi.", isError: true);
                                  }
                                },
                                child: authProvider.isLoading
                                    ? CircularProgressIndicator(color: Colors.white)
                                    : Text("MASUK SISTEM", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                              ),
                            ),
                            
                            // 2. BAGIAN NAVIGASI KE REGISTER
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Belum punya akun? ", style: TextStyle(color: Colors.white70)),
                                GestureDetector(
                                  onTap: () {
                                    // Pindah ke Halaman Register
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                                    );
                                  },
                                  child: Text(
                                    "Daftar",
                                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.cyanAccent), // Pakai cyanAccent biar terlihat di background gelap
                                  ),
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlowingCircle(double size) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [Colors.cyanAccent.withOpacity(0.2), Colors.transparent]),
      ),
    );
  }

  Widget _buildNeonInput(TextEditingController controller, IconData icon, String hint, bool isPass) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPass ? _isObscure : false,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.cyanAccent),
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white38),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
          suffixIcon: isPass ? IconButton(
            icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.white38),
            onPressed: () => setState(() => _isObscure = !_isObscure),
          ) : null,
        ),
      ),
    );
  }

  // Notifikasi Kustom (Futuristik)
  void _showCustomNotif(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      content: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isError ? Color(0xFF8B0000).withOpacity(0.9) : Color(0xFF004d61).withOpacity(0.9),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isError ? Colors.redAccent : Colors.cyanAccent),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
        ),
        child: Row(children: [
          Icon(isError ? Icons.error_outline : Icons.check_circle_outline, color: Colors.white),
          SizedBox(width: 10),
          Expanded(child: Text(message, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600))),
        ]),
      ),
    ));
  }
}
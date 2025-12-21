import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart'; 

class CalculatorScreen extends StatefulWidget {
  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Controller Input
  final TextEditingController _jumlahIkanController = TextEditingController();
  final TextEditingController _targetBeratController = TextEditingController(); // gram per ekor
  final TextEditingController _hargaPakanController = TextEditingController(); // per kg
  
  // Hasil Perhitungan
  double _estimasiPanenKg = 0;
  double _kebutuhanPakan = 0;
  double _biayaPakan = 0;
  bool _hasCalculated = false;

  // Rumus Standar Budidaya (FCR - Feed Conversion Ratio)
  // Kita pakai standar FCR 1.2 (1.2 kg pakan jadi 1 kg daging ikan)
  final double fcr = 1.2; 
  // Estimasi tingkat kematian (SR - Survival Rate) misal 5% mati
  final double mortalityRate = 0.05;

  void _hitung() {
    // Validasi input
    if (_jumlahIkanController.text.isEmpty || 
        _targetBeratController.text.isEmpty || 
        _hargaPakanController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Mohon isi semua data dulu ya!"))
      );
      return;
    }

    // Ambil data dari input
    double jumlahTebar = double.parse(_jumlahIkanController.text);
    double targetSize = double.parse(_targetBeratController.text); // dalam gram
    double hargaPakan = double.parse(_hargaPakanController.text);

    setState(() {
      // 1. Hitung Ikan Hidup (dikurangi kematian 5%)
      double ikanHidup = jumlahTebar - (jumlahTebar * mortalityRate);

      // 2. Total Berat Panen (Tonase) dalam Kg
      // (Jumlah Hidup * Berat per ekor) / 1000
      _estimasiPanenKg = (ikanHidup * targetSize) / 1000;

      // 3. Kebutuhan Pakan Total (Kg)
      // Rumus: Tonase * FCR
      _kebutuhanPakan = _estimasiPanenKg * fcr;

      // 4. Estimasi Biaya Pakan (Rp)
      _biayaPakan = _kebutuhanPakan * hargaPakan;

      _hasCalculated = true;
      
      // Tutup keyboard setelah hitung
      FocusScope.of(context).unfocus();
    });
  }

  // Format Rupiah
  String _formatCurrency(double amount) {
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    return currencyFormatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kalkulator Pakan", style: GoogleFonts.poppins()),
        backgroundColor: Color(0xFF013746),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // CARD INPUT
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              elevation: 2,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Masukan Data Budidaya", 
                      style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF013746))),
                    SizedBox(height: 20),
                    
                    _buildInput("Jumlah Tebar Ikan (Ekor)", "Contoh: 1000", _jumlahIkanController, Icons.waves),
                    SizedBox(height: 15),
                    _buildInput("Target Berat Panen (Gram/Ekor)", "Contoh: 500 (untuk 1/2 kg)", _targetBeratController, Icons.scale),
                    SizedBox(height: 15),
                    _buildInput("Harga Pakan per Kg (Rp)", "Contoh: 12000", _hargaPakanController, Icons.monetization_on),
                    
                    SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _hitung,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF013746),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text("HITUNG ESTIMASI", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 20),

            // CARD HASIL (Muncul setelah tombol hitung ditekan)
            if (_hasCalculated)
              Column(
                children: [
                  Text("Hasil Analisa", style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[700])),
                  SizedBox(height: 10),
                  
                  // HASIL 1: TOTAL PANEN
                  _buildResultCard(
                    "Estimasi Panen", 
                    "${_estimasiPanenKg.toStringAsFixed(1)} Kg", 
                    "Total berat ikan yang akan dipanen (setelah dipotong estimasi kematian 5%)",
                    Colors.green
                  ),

                  // HASIL 2: KEBUTUHAN PAKAN
                  _buildResultCard(
                    "Total Pakan Dibutuhkan", 
                    "${_kebutuhanPakan.toStringAsFixed(1)} Kg", 
                    "Jumlah pakan yang harus disiapkan sampai panen (Asumsi FCR 1.2)",
                    Colors.orange
                  ),

                  // HASIL 3: BIAYA
                  _buildResultCard(
                    "Estimasi Biaya Pakan", 
                    _formatCurrency(_biayaPakan), 
                    "Modal yang harus disiapkan untuk membeli pakan.",
                    Colors.blue
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }

  Widget _buildInput(String label, String hint, TextEditingController controller, IconData icon) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: Color(0xFF013746)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildResultCard(String title, String value, String desc, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border(left: BorderSide(color: color, width: 5)),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), blurRadius: 5, offset: Offset(0, 3))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.poppins(color: Colors.grey[600], fontSize: 12)),
                SizedBox(height: 5),
                Text(value, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                SizedBox(height: 5),
                Text(desc, style: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 10, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          Icon(Icons.check_circle_outline, color: color.withOpacity(0.5), size: 40),
        ],
      ),
    );
  }
}
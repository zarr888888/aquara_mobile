import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Import plugin launcher
import '../models/event_model.dart';

class EventDetailScreen extends StatelessWidget {
  final EventModel event;
  const EventDetailScreen({Key? key, required this.event}) : super(key: key);

  // Fungsi buka Link Pendaftaran
  Future<void> _openLink(BuildContext context) async {
    if (event.linkPendaftaran.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Link pendaftaran tidak tersedia.")));
      return;
    }

    final Uri url = Uri.parse(event.linkPendaftaran);
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal membuka link.")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Detail Event"), backgroundColor: Color(0xFF013746), foregroundColor: Colors.white),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(event.gambarUrl, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(height: 200, color: Colors.grey)),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul
                  Text(event.judul, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF013746))),
                  SizedBox(height: 15),
                  
                  // Info Rows
                  _infoRow(Icons.calendar_today, "Waktu Mulai", event.tanggalMulai),
                  _infoRow(Icons.location_pin, "Lokasi", event.lokasi),
                  _infoRow(Icons.laptop_mac, "Tipe Event", event.tipe),
                  
                  SizedBox(height: 20),
                  Text("Deskripsi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 8),
                  Text(event.deskripsi, style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey[800])),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, boxShadow: [BoxShadow(blurRadius: 10, color: Colors.black12)]),
        child: ElevatedButton(
          onPressed: () => _openLink(context), // Panggil fungsi buka link
          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF013746), foregroundColor: Colors.white, padding: EdgeInsets.symmetric(vertical: 15)),
          child: Text("DAFTAR SEKARANG"),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(padding: const EdgeInsets.only(bottom: 10), child: Row(children: [Icon(icon, color: Colors.teal, size: 20), SizedBox(width: 10), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(fontSize: 10, color: Colors.grey)), Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14))])]));
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import 'event_detail_screen.dart';

class EventScreen extends StatefulWidget {
  @override
  _EventScreenState createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => 
      Provider.of<EventProvider>(context, listen: false).fetchEvents()
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda & Event"),
        backgroundColor: Color(0xFF013746),
        foregroundColor: Colors.white,
      ),
      backgroundColor: Color(0xFFF5F5F5),
      body: Consumer<EventProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return Center(child: CircularProgressIndicator());
          if (provider.events.isEmpty) return Center(child: Text("Belum ada event."));

          return ListView.builder(
            padding: EdgeInsets.all(15),
            itemCount: provider.events.length,
            itemBuilder: (context, index) {
              final event = provider.events[index];
              return Card(
                margin: EdgeInsets.only(bottom: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                elevation: 3,
                child: InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c) => EventDetailScreen(event: event)));
                  },
                  borderRadius: BorderRadius.circular(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                        child: Image.network(
                          event.gambarUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (c,e,s) => Container(height: 150, color: Colors.grey[300], child: Icon(Icons.broken_image)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: [
                            // Kotak Tanggal
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: Color(0xFFE0F7FA),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: Colors.cyan),
                              ),
                              child: Column(
                                children: [
                                  Text(event.tglDisplay, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF013746))),
                                  Text(event.blnDisplay, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            SizedBox(width: 15),
                            // Info Judul & Lokasi
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(event.judul, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 2, overflow: TextOverflow.ellipsis),
                                  SizedBox(height: 5),
                                  Row(children: [
                                    Icon(Icons.location_on, size: 14, color: Colors.red), 
                                    SizedBox(width: 4), 
                                    Expanded(child: Text(event.lokasi, style: TextStyle(fontSize: 12, color: Colors.grey[600]), maxLines: 1))
                                  ]),
                                  SizedBox(height: 5),
                                  // Label Tipe (Online/Offline)
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: event.tipe == 'Online' ? Colors.green[100] : Colors.orange[100],
                                      borderRadius: BorderRadius.circular(5)
                                    ),
                                    child: Text(event.tipe, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.black87)),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
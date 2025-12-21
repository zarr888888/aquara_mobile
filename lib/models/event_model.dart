class EventModel {
  final String id;
  final String judul;
  final String deskripsi;
  final String gambarUrl;
  final String tipe;             
  final String lokasi;
  final String tanggalMulai;
  final String linkPendaftaran;
  
  // Data tambahan untuk UI (Tanggal & Bulan)
  final String tglDisplay;
  final String blnDisplay;

  EventModel({
    required this.id,
    required this.judul,
    required this.deskripsi,
    required this.gambarUrl,
    required this.tipe,
    required this.lokasi,
    required this.tanggalMulai,
    required this.linkPendaftaran,
    required this.tglDisplay,
    required this.blnDisplay,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'].toString(),
      judul: json['judul'] ?? '',
      deskripsi: json['deskripsi'] ?? '',
      gambarUrl: json['gambar_url'] ?? '',
      tipe: json['tipe'] ?? 'Online',
      lokasi: json['lokasi'] ?? '-',
      tanggalMulai: json['tanggal_mulai'] ?? '',
      linkPendaftaran: json['link_pendaftaran'] ?? '',
      tglDisplay: json['tgl_display'] ?? '01',
      blnDisplay: json['bln_display'] ?? 'JAN',
    );
  }
}
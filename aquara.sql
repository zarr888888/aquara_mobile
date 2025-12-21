-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 20, 2025 at 10:24 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `aquara`
--

-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE `articles` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `category_id` int(11) NOT NULL,
  `judul` varchar(255) NOT NULL,
  `konten` text NOT NULL,
  `gambar` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `articles`
--

INSERT INTO `articles` (`id`, `user_id`, `category_id`, `judul`, `konten`, `gambar`, `created_at`, `updated_at`) VALUES
(7, 9, 1, 'Revolusi Akuakultur: Penerapan Teknologi Kincir Air untuk Meningkatkan Produktivitas Tambak', 'Di era modern ini, budidaya perikanan tidak lagi hanya mengandalkan metode tradisional. Penggunaan teknologi seperti kincir air (paddle wheel aerator) telah terbukti mampu meningkatkan kadar oksigen terlarut dalam air secara signifikan. Hal ini berdampak langsung pada kesehatan ikan, percepatan pertumbuhan, dan memungkinkan penebaran benih dengan kepadatan yang lebih tinggi. Artikel ini akan membahas cara kerja, manfaat, serta tips memilih kincir air yang tepat untuk tambak Anda agar hasil panen lebih maksimal.', 'artikel_1762704908.jpg', '2025-11-09 23:15:08', '2025-11-09 23:15:08'),
(8, 9, 3, 'Strategi Sukses Panen Lele Melimpah: Dari Persiapan Kolam Hingga Pemasaran', 'Momen panen adalah saat yang paling dinanti oleh setiap pembudidaya. Namun, panen yang sukses tidak terjadi begitu saja. Diperlukan strategi yang matang mulai dari manajemen pakan, pemantauan kualitas air, hingga teknik pemanenan yang tepat agar ikan tidak stres atau rusak. Dalam artikel ini, kami akan membagikan rahasia para peternak sukses dalam menghasilkan panen lele berkualitas tinggi yang siap bersaing di pasaran dengan harga terbaik.', 'artikel_1762704969.jpg', '2025-11-09 23:16:09', '2025-11-09 23:16:09'),
(9, 9, 1, 'Menggali Potensi Emas Biru: Optimalisasi Lahan Tambak Tradisional untuk Hasil Berkelanjutan', 'Indonesia memiliki garis pantai yang panjang dengan potensi lahan tambak yang sangat luas. Sayangnya, masih banyak lahan tambak tradisional yang belum dimanfaatkan secara optimal. Artikel ini akan mengulas bagaimana cara mengubah lahan tambak tidur atau kurang produktif menjadi aset yang menguntungkan melalui penerapan sistem budidaya polikultur (udang dan bandeng) serta manajemen lingkungan yang berkelanjutan untuk menjaga kelestarian ekosistem pesisir.', 'artikel_1762705026.jpeg', '2025-11-09 23:17:06', '2025-11-09 23:17:06'),
(10, 9, 1, 'Waspada Kematian Massal Ikan: Penyebab Utama dan Langkah Pencegahan Dini yang Wajib Diketahui', 'Kematian massal ikan secara mendadak adalah mimpi buruk bagi setiap pembudidaya. Fenomena ini seringkali disebabkan oleh faktor lingkungan yang ekstrem, seperti upwelling (naiknya massa air dasar yang minim oksigen), ledakan populasi alga beracun, atau serangan penyakit akut. Artikel ini akan mengupas tuntas tanda-tanda awal yang harus diwaspadai, langkah pertolongan pertama saat terjadi kematian massal, serta strategi jangka panjang untuk mencegah kerugian besar di kemudian hari.', 'artikel_1762705075.jpg', '2025-11-09 23:17:55', '2025-11-09 23:17:55'),
(11, 9, 1, 'IKAN', 'TESTING', 'artikel_1763000130.png', '2025-11-13 09:15:30', '2025-11-13 09:15:30');

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `nama`) VALUES
(1, 'ARTIKEL'),
(2, 'BERITA'),
(3, 'TIPS');

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `judul` varchar(255) NOT NULL,
  `deskripsi` text NOT NULL,
  `gambar` varchar(255) DEFAULT NULL,
  `tipe` enum('Online','Offline') NOT NULL DEFAULT 'Online',
  `lokasi` varchar(255) DEFAULT NULL,
  `tanggal_mulai` datetime NOT NULL,
  `tanggal_selesai` datetime DEFAULT NULL,
  `link_pendaftaran` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `events`
--

INSERT INTO `events` (`id`, `judul`, `deskripsi`, `gambar`, `tipe`, `lokasi`, `tanggal_mulai`, `tanggal_selesai`, `link_pendaftaran`, `created_at`) VALUES
(13, 'BUDIDAYA', 'Ayooo ditungguuu kehadirannya', 'event_1766113461.png', 'Offline', 'Alun-Alun Indramayu', '2025-12-21 10:03:00', NULL, 'https://forms.gle/KKoH5fxuakEAMzSW8', '2025-12-19 03:04:21');

-- --------------------------------------------------------

--
-- Table structure for table `forum_replies`
--

CREATE TABLE `forum_replies` (
  `id` int(11) NOT NULL,
  `topic_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `konten` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `forum_replies`
--

INSERT INTO `forum_replies` (`id`, `topic_id`, `user_id`, `konten`, `created_at`, `updated_at`) VALUES
(9, 7, 11, 'Halo rekan Ahmad Uzumaki, izin beri pendapat ya.\r\n\r\nBudidaya di KJA memang tantangannya beda dengan kolam tanah, terutama soal pakan yang harus benar-benar efisien biar nggak rugi tenggelam.\r\n\r\nKalau soal merek, sebenarnya banyak yang bagus seperti seri 781, Comfeed, atau Sinta, asalkan proteinnya di atas 28% untuk pembesaran. Saran saya, pilih yang paling mudah didapat di daerah Anda supaya suplainya lancar.\r\n\r\nTrik saya biar hemat tapi tumbuh cepat di KJA bukan ganti pakannya jadi murahan, tapi optimalkan penyerapannya. Coba pakannya dibibis dulu pakai probiotik + sedikit molase sekitar 15-30 menit sebelum ditebar. Ikannya jadi lebih lahap, pencernaan lancar, dan kotorannya nggak terlalu mengotori air.\r\n\r\nHati-hati kalau pakai pakan alternatif racikan sendiri di KJA ya, kalau gampang hancur malah nanti airnya cepat rusak dan mengundang penyakit.\r\n\r\nSukses terus untuk budidayanya!', '2025-11-09 23:42:20', '2025-11-09 23:42:20'),
(10, 6, 11, 'Halo rekan pembudidaya. Apa yang Anda alami itu sering disebut harvesting stress yang berujung pada kematian mendadak.\r\n\r\nFaktor yang Anda sebutkan (suhu dan penanganan) memang dua penyebab utamanya, ditambah satu lagi: kualitas air saat panen.\r\n\r\nSaat air kolam tanah disurutkan dan ikan digiring, lumpur dasar kolam akan naik. Ini menyebabkan:\r\n\r\nOksigen terlarut drop drastis (karena proses oksidasi bahan organik di lumpur).\r\n\r\nInsang tertutup partikel lumpur, sehingga ikan megap-megap (gasping) meskipun masih di dalam air.\r\n\r\nSolusi teknisnya: Pastikan proses penggiringan ikan dilakukan perlahan agar lumpur tidak terlalu naik. Jika memungkinkan, alirkan air baru yang bersih secara terus-menerus ke titik pengumpulan ikan saat panen berlangsung. Ini akan sangat membantu menyuplai oksigen darurat bagi ikan yang sedang terkumpul di jaring.\r\n\r\nHindari juga mengangkat jaring terlalu tinggi dan lama di udara. Ikan mas tidak punya alat pernapasan tambahan seperti lele, jadi mereka sangat cepat lemas jika tidak terendam air.', '2025-11-09 23:45:07', '2025-11-09 23:45:07'),
(11, 8, 11, 'Ditunggu kehadiran wahai para suhu pembudidaya, SALAM AQUARA!!!', '2025-11-09 23:48:25', '2025-11-09 23:48:25'),
(12, 8, 3, 'SIAP PAKKKK', '2025-11-09 23:51:02', '2025-11-09 23:51:02'),
(13, 7, 3, 'Terima kasih pak Alfatih Ronaldo atas masukkannya, Semoga anda selalu sukses kedepannya', '2025-11-09 23:51:56', '2025-11-09 23:51:56'),
(14, 6, 3, 'Terima kasih sekalai lagi pakkkkk sarannya sangat manjur', '2025-11-09 23:53:01', '2025-11-09 23:53:01'),
(15, 8, 14, 'Halo', '2025-11-13 08:57:02', '2025-11-13 08:57:02'),
(16, 7, 14, 'oke', '2025-11-13 08:57:38', '2025-11-13 08:57:38'),
(17, 8, 11, 'IYA ADA APA', '2025-11-28 10:00:50', '2025-11-28 10:00:50'),
(18, 9, 11, 'SIAP', '2025-11-28 10:01:07', '2025-11-28 10:01:07'),
(20, 9, 15, '@Alfatih Ronaldo TERIMA KASIH PAK', '2025-12-05 04:49:52', '2025-12-05 04:49:52'),
(21, 6, 15, '@Alfatih Ronaldo SIAP', '2025-12-05 05:02:46', '2025-12-05 05:02:46'),
(22, 14, 3, 'hallo', '2025-12-18 08:16:56', '2025-12-18 08:16:56'),
(23, 15, 15, 'y', '2025-12-18 08:20:42', '2025-12-18 08:20:42'),
(27, 15, 15, 'yek', '2025-12-19 07:14:49', '2025-12-19 07:14:49'),
(28, 12, 15, 'wooo', '2025-12-19 07:14:56', '2025-12-19 07:14:56'),
(30, 15, 15, 'p', '2025-12-19 07:42:11', '2025-12-19 07:42:11'),
(31, 14, 15, 'y', '2025-12-19 07:42:22', '2025-12-19 07:42:22'),
(32, 12, 15, 'lo', '2025-12-19 07:42:30', '2025-12-19 07:42:30'),
(34, 15, 15, 'wong liyoo', '2025-12-19 08:00:11', '2025-12-19 08:00:11'),
(35, 17, 15, 'bismillah', '2025-12-19 08:01:12', '2025-12-19 08:01:12'),
(36, 17, 15, '@Kevin diks gaskennn', '2025-12-19 08:06:46', '2025-12-19 08:06:46'),
(38, 17, 15, 'yp', '2025-12-19 08:35:43', '2025-12-19 08:35:43'),
(39, 14, 15, '@Ahmad Uzumaki y', '2025-12-19 08:42:35', '2025-12-19 08:42:35'),
(40, 18, 15, 'mantapp', '2025-12-19 08:43:22', '2025-12-19 08:43:22'),
(41, 18, 18, 'mantap', '2025-12-19 10:29:41', '2025-12-19 10:29:41');

-- --------------------------------------------------------

--
-- Table structure for table `forum_topics`
--

CREATE TABLE `forum_topics` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `judul` varchar(255) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `gambar` varchar(255) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `forum_topics`
--

INSERT INTO `forum_topics` (`id`, `user_id`, `judul`, `deskripsi`, `gambar`, `created_at`, `updated_at`) VALUES
(6, 3, 'Sharing Pengalaman: Merek Pakan Ikan Nila Terbaik untuk Pertumbuhan Cepat?', 'Halo rekan-rekan pembudidaya semua,\r\n\r\nSaya sedang mencoba budidaya ikan nila di sistem keramba jaring apung (seperti di foto). Saat ini saya sedang bingung memilih pakan yang paling efektif.\r\n\r\nKira-kira merek pakan apa yang teman-teman rekomendasikan untuk mempercepat pertumbuhan ikan nila di fase pembesaran? Apakah ada racikan pakan alternatif yang lebih hemat biaya tapi hasilnya tetap bagus? Mohon sharing pengalamannya ya, terima kasih!', 'topic_6910c2fbdc6077.44965836.jpg', '2025-11-09 23:36:11', '2025-11-09 23:36:11'),
(7, 3, 'TANYA: Cara Mengatasi Ikan Mas yang Stres dan Banyak Mati Saat Dipanen?', 'Selamat siang para senior,\r\n\r\nSaya baru saja melakukan panen ikan mas di kolam tanah. Namun, saya mengalami masalah di mana banyak ikan yang terlihat stres (megap-megap) dan beberapa bahkan mati setelah diangkat dari jaring.\r\n\r\nApakah ada teknik khusus saat memanen agar ikan tetap segar dan tidak mudah stres? Apakah faktor suhu air atau cara penanganan saat di jaring berpengaruh besar? Mohon saran dan tipsnya dari para suhu di sini. Terima kasih sebelumnya.', 'topic_6910c36bedc168.28155477.jpeg', '2025-11-09 23:38:03', '2025-11-09 23:38:03'),
(8, 11, '🔥 [OFFICIAL THREAD] Diskusi Pra-Event: Bedah Tuntas Teknologi Budidaya Modern Bersama Pakar', 'Halo rekan-rekan pembudidaya AQUARA!\r\n\r\nMenyambut event webinar eksklusif kita minggu depan (sesuai poster di menu Event), thread ini dibuka khusus untuk diskusi awal.\r\n\r\nBagi yang sudah mendaftar, silakan tuliskan satu pertanyaan terbesar Anda terkait topik webinar ini di kolom komentar. Pertanyaan yang paling banyak muncul akan kami prioritaskan untuk dibahas tuntas oleh pemateri kita nanti.\r\n\r\nYuk, manfaatkan kesempatan ini untuk menggali ilmu langsung dari ahlinya!', 'topic_6910c571d2b930.19484371.png', '2025-11-09 23:46:41', '2025-11-09 23:46:41'),
(9, 14, 'Info Tambak Di Indramayu', 'Testing', NULL, '2025-11-13 08:58:57', '2025-11-13 08:58:57'),
(10, 11, 'WORO WORO WEBINAR', 'INFOOO', 'topic_69320dc89bcf38.78364127.png', '2025-11-28 10:01:37', '2025-12-05 05:40:08'),
(12, 15, 'INDRAMAYU', 'BISMILLAHHH', 'topic_693204c29e01f5.17990016.png', '2025-12-05 04:51:18', '2025-12-05 05:01:38'),
(14, 3, 'Indramayu This Is Fish Waterr', 'Indramayu banyak tambak yg merajalela', 'topic_69435016d8a72.jpg', '2025-12-18 07:51:34', '2025-12-18 07:51:34'),
(15, 3, 'y', 'p', NULL, '2025-12-18 08:20:21', '2025-12-18 08:20:21'),
(17, 15, 'AFTERSHINE', 'Sewates Konco', 'topic_6944b11d32e83.jpg', '2025-12-19 08:00:53', '2025-12-19 08:57:49'),
(18, 15, 'LAVORA', 'Rasah Bali 2', 'topic_6944b0e401b0a.jpg', '2025-12-19 08:43:05', '2025-12-19 08:58:06');

-- --------------------------------------------------------

--
-- Table structure for table `kalkulator_history`
--

CREATE TABLE `kalkulator_history` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `tipe_kalkulator` varchar(50) NOT NULL,
  `input_data` text NOT NULL,
  `hasil_data` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `kalkulator_history`
--

INSERT INTO `kalkulator_history` (`id`, `user_id`, `tipe_kalkulator`, `input_data`, `hasil_data`, `created_at`) VALUES
(1, 3, 'budidaya_ikan', '{\"luas_kolam\":\"100\",\"jenis_ikan\":\"bawal\",\"jumlah_bibit\":\"1000\",\"harga_bibit\":\"1000\",\"harga_pakan\":\"10000\",\"durasi\":\"3\"}', '{\"total_biaya\":\"15100000\",\"estimasi_pendapatan\":\"5950000\",\"estimasi_keuntungan\":\"-9150000\",\"roi\":\"-60.60\"}', '2025-11-06 10:32:38'),
(2, 3, 'budidaya_ikan', '{\"luas_kolam\":\"100\",\"jenis_ikan\":\"bawal\",\"jumlah_bibit\":\"3000\",\"harga_bibit\":\"1000\",\"harga_pakan\":\"9500\",\"durasi\":\"4\"}', '{\"total_biaya\":\"55100000\",\"estimasi_pendapatan\":\"17850000\",\"estimasi_keuntungan\":\"-37250000\",\"roi\":\"-67.60\"}', '2025-11-06 10:40:55'),
(3, 3, 'budidaya_ikan', '{\"luas_kolam\":\"100\",\"jenis_ikan\":\"bawal\",\"jumlah_bibit\":\"3000\",\"harga_bibit\":\"1000\",\"harga_pakan\":\"9500\",\"durasi\":\"4\"}', '{\"total_biaya\":\"55100000\",\"estimasi_pendapatan\":\"17850000\",\"estimasi_keuntungan\":\"-37250000\",\"roi\":\"-67.60\"}', '2025-11-06 10:41:23'),
(4, 11, 'budidaya_ikan', '{\"luas_kolam\":\"100\",\"jenis_ikan\":\"nila\",\"jumlah_bibit\":\"6000\",\"harga_bibit\":\"800\",\"harga_pakan\":\"9000\",\"durasi\":\"4\"}', '{\"total_biaya\":\"102800000\",\"estimasi_pendapatan\":\"22950000\",\"estimasi_keuntungan\":\"-79850000\",\"roi\":\"-77.68\"}', '2025-11-08 12:05:00'),
(5, 11, 'budidaya_ikan', '{\"luas_kolam\":\"100\",\"jenis_ikan\":\"nila\",\"jumlah_bibit\":\"6000\",\"harga_bibit\":\"800\",\"harga_pakan\":\"9000\",\"durasi\":\"4\"}', '{\"total_biaya\":\"102800000\",\"estimasi_pendapatan\":\"22950000\",\"estimasi_keuntungan\":\"-79850000\",\"roi\":\"-77.68\"}', '2025-11-08 12:05:17'),
(6, 12, 'budidaya_ikan', '{\"luas_kolam\":\"800\",\"jenis_ikan\":\"lele\",\"jumlah_bibit\":\"5000\",\"harga_bibit\":\"500\",\"harga_pakan\":\"8000\",\"durasi\":\"3\"}', '{\"total_biaya\":\"61300000\",\"estimasi_pendapatan\":\"10625000\",\"estimasi_keuntungan\":\"-50675000\",\"roi\":\"-82.67\"}', '2025-11-08 12:18:53'),
(7, 14, 'budidaya_ikan', '{\"luas_kolam\":\"400\",\"jenis_ikan\":\"gurame\",\"jumlah_bibit\":\"5000\",\"harga_bibit\":\"1500\",\"harga_pakan\":\"10000\",\"durasi\":\"6\"}', '{\"total_biaya\":\"147300000\",\"estimasi_pendapatan\":\"51000000\",\"estimasi_keuntungan\":\"-96300000\",\"roi\":\"-65.38\"}', '2025-11-13 09:02:24'),
(8, 15, 'budidaya_ikan', '{\"luas_kolam\":\"1000\",\"jenis_ikan\":\"nila\",\"jumlah_bibit\":\"500\",\"harga_bibit\":\"800\",\"harga_pakan\":\"9000\",\"durasi\":\"4\"}', '{\"total_biaya\":\"16500000\",\"estimasi_pendapatan\":\"1912500\",\"estimasi_keuntungan\":\"-14587500\",\"roi\":\"-88.41\"}', '2025-12-04 11:07:45'),
(9, 15, 'budidaya_ikan', '{\"luas_kolam\":\"100\",\"jenis_ikan\":\"lele\",\"jumlah_bibit\":\"100\",\"harga_bibit\":\"500\",\"harga_pakan\":\"8000\",\"durasi\":\"3\"}', '{\"total_biaya\":\"1730000\",\"estimasi_pendapatan\":\"212500\",\"estimasi_keuntungan\":\"-1517500\",\"roi\":\"-87.72\"}', '2025-12-04 11:08:36'),
(10, 11, 'budidaya_ikan', '{\"luas_kolam\":\"100\",\"jenis_ikan\":\"bawal\",\"jumlah_bibit\":\"5000\",\"harga_bibit\":\"1000\",\"harga_pakan\":\"9500\",\"durasi\":\"4\"}', '{\"total_biaya\":\"91300000\",\"estimasi_pendapatan\":\"29750000\",\"estimasi_keuntungan\":\"-61550000\",\"roi\":\"-67.42\"}', '2025-12-04 11:22:14');

-- --------------------------------------------------------

--
-- Table structure for table `konsultasi`
--

CREATE TABLE `konsultasi` (
  `id` int(11) NOT NULL,
  `anggota_id` int(11) NOT NULL,
  `pakar_id` int(11) NOT NULL,
  `topik` varchar(255) NOT NULL,
  `ahli` varchar(100) DEFAULT NULL,
  `pesan` text NOT NULL,
  `jawaban` text DEFAULT NULL,
  `tanggal_jawaban` datetime DEFAULT NULL,
  `pengirim` enum('anggota','pakar') NOT NULL,
  `status` enum('pending','answered','closed','dibatalkan') DEFAULT 'pending',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `konsultasi`
--

INSERT INTO `konsultasi` (`id`, `anggota_id`, `pakar_id`, `topik`, `ahli`, `pesan`, `jawaban`, `tanggal_jawaban`, `pengirim`, `status`, `created_at`, `updated_at`) VALUES
(3, 3, 9, '', NULL, 'Topik: budidaya ikan nila\n\nKENAPA IKAN LELE SAYA PENGENNYA MAKAN BANGKAI AYAM', 'iya bisa ahmad uzumaki', '2025-11-05 22:06:31', 'anggota', 'answered', '2025-10-31 15:25:35', '2025-11-05 22:06:31'),
(12, 14, 11, '', NULL, 'Topik: Ikan Air Tawar yang berkualitas\n\ninfo nya donggg bang pakar', 'kasih air', '2025-11-13 09:06:37', 'anggota', 'answered', '2025-11-13 09:01:16', '2025-11-13 09:06:37'),
(13, 14, 11, '', NULL, 'Topik: cara menjernihkan air tambak\n\njelaskannnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnnn', 'siapppppp', '2025-11-28 09:54:59', 'anggota', 'answered', '2025-11-28 09:53:41', '2025-11-28 09:54:59'),
(17, 15, 11, '', NULL, 'Topik: cara menjernihkan air tambak\n\nBISMILLAHHHHHHHHHHHHHHHHHHHHHHHH', 'BISMILLAH', '2025-12-04 11:48:59', 'anggota', 'answered', '2025-12-04 11:43:15', '2025-12-04 11:48:59'),
(18, 15, 11, '', NULL, 'Topik: cara menjernihkan air tambak\n\nYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY', 'BISAAAAAAA', '2025-12-04 11:48:29', 'anggota', 'answered', '2025-12-04 11:45:31', '2025-12-04 11:48:29'),
(19, 15, 11, '', NULL, 'Topik: cara menjernihkan air tambak\n\ntuyuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuuu', 'ggggggggggggg', '2025-12-04 12:14:52', 'anggota', 'answered', '2025-12-04 12:12:27', '2025-12-04 12:14:52'),
(20, 15, 11, '', NULL, 'Topik: cara menjernihkan air tambak\n\nBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB', NULL, NULL, 'anggota', 'dibatalkan', '2025-12-04 12:41:28', '2025-12-04 12:41:37'),
(22, 15, 11, '', NULL, 'Topik: cara menjernihkan air tambak\n\nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX', NULL, NULL, 'anggota', 'dibatalkan', '2025-12-04 12:45:34', '2025-12-05 04:02:44'),
(23, 15, 11, '', NULL, 'Topik: cara menjernihkan air tambak\n\npirloooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooo', NULL, NULL, 'anggota', 'dibatalkan', '2025-12-05 04:02:20', '2025-12-05 04:02:58');

-- --------------------------------------------------------

--
-- Table structure for table `post_likes`
--

CREATE TABLE `post_likes` (
  `id` int(11) NOT NULL,
  `post_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `post_likes`
--

INSERT INTO `post_likes` (`id`, `post_id`, `user_id`, `created_at`) VALUES
(16, 6, 3, '2025-11-09 23:36:23'),
(17, 7, 3, '2025-11-09 23:38:08'),
(18, 7, 11, '2025-11-09 23:43:07'),
(19, 6, 11, '2025-11-09 23:43:10'),
(20, 8, 11, '2025-11-09 23:46:52'),
(21, 8, 3, '2025-11-09 23:50:45'),
(22, 8, 14, '2025-11-13 08:56:28'),
(23, 7, 14, '2025-11-13 08:56:30'),
(24, 6, 14, '2025-11-13 08:56:32'),
(25, 9, 14, '2025-11-13 08:59:03'),
(26, 9, 11, '2025-11-13 09:05:21'),
(27, 10, 11, '2025-11-28 10:01:41'),
(30, 9, 15, '2025-12-05 04:15:12'),
(32, 7, 15, '2025-12-05 04:15:15'),
(34, 12, 15, '2025-12-05 04:51:23'),
(35, 10, 15, '2025-12-05 05:42:00'),
(36, 12, 11, '2025-12-05 05:42:22'),
(37, 12, 16, '2025-12-05 11:15:48'),
(38, 6, 16, '2025-12-06 09:41:06'),
(39, 14, 15, '2025-12-18 07:51:58'),
(44, 6, 15, '2025-12-19 07:41:38'),
(52, 8, 15, '2025-12-19 08:35:56'),
(53, 17, 15, '2025-12-19 08:35:58'),
(54, 15, 15, '2025-12-19 08:42:47'),
(57, 18, 15, '2025-12-19 08:59:45'),
(58, 18, 18, '2025-12-19 10:29:52'),
(59, 17, 18, '2025-12-19 10:29:54'),
(60, 15, 18, '2025-12-19 10:49:25');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(11) NOT NULL,
  `role_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `role_name`) VALUES
(1, 'admin'),
(2, 'anggota'),
(3, 'pakar');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `telepon` varchar(20) DEFAULT NULL,
  `foto_profil` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role_id` int(11) NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `nama`, `email`, `telepon`, `foto_profil`, `password`, `role_id`, `created_at`, `updated_at`) VALUES
(1, 'alfajar', 'alfajarislamiakbar@gmail.com', NULL, NULL, '$2y$10$VuMKuPvzYBPbxnpohdw6d.3iSlNmTAvFqkz2Sa0VcllnLThqKFddu', 2, '2025-10-30 08:27:55', '2025-10-30 08:27:55'),
(3, 'Ahmad Uzumaki', 'alfajar@gmail.com', NULL, 'user_3_1761871412.jpg', '$2y$10$6Q/YGTTzYEl96m.0gyACnu42wqhCgC32ThS1zcMYosh2/QB85e6Be', 2, '2025-10-30 10:17:12', '2025-10-31 07:57:21'),
(4, 'Ahmad Budiman', 'ahmad.pakar@aquara.com', NULL, NULL, '$2y$10$TKh8H1.PfQx37YgCzwiHw.uej0aGgrIdNA/./.UpmXfXoWPFAC5sS', 3, '2025-10-30 11:46:37', '2025-10-30 11:46:37'),
(5, 'Herlina Muti', 'herlina.pakar@aquara.com', NULL, NULL, '$2y$10$TKh8H1.PfQx37YgCzwiHw.uej0aGgrIdNA/./.UpmXfXoWPFAC5sS', 3, '2025-10-30 11:46:37', '2025-10-30 11:46:37'),
(9, 'Admin1 AQUARA', 'admin@aquara.com', NULL, NULL, '$2y$10$umQaGXXmCAS6rq8m8m5TU.AHTaDjWa6emb9uqLDn8F2G7prnCAl46', 1, '2025-11-05 14:51:05', '2025-11-06 08:24:15'),
(11, 'Alfatih Ronaldo', 'alfatih.pakar@aquara.com', NULL, 'user_11_1762580070.png', '$2y$10$Lhhh8ubTtnYZJx6QTdRELOaeqZ4.0vfgaWTrDBWMR7QUNaqO0RX1u', 3, '2025-11-06 12:15:44', '2025-11-08 12:34:59'),
(12, 'Dembele', 'dembele@gmail.com', NULL, NULL, '$2y$10$OKnpedNwGSAG1cbr626wmekkLtZgQuy6uja2QcX57fLKtlscMZZiO', 2, '2025-11-08 12:16:38', '2025-12-06 11:49:20'),
(13, 'Erling Haaland', 'haland@gmail.com', NULL, NULL, '$2y$10$vCBCL1p3UGzRlU0VFxx88O4JrPs/Fw5T6m3NY0bA17V1BV8WIkqjW', 2, '2025-11-13 08:49:16', '2025-11-13 08:49:16'),
(14, 'POLINDRA RPL', 'polindra@gmail.com', NULL, 'user_14_1762999393.png', '$2y$10$tJtp987HKPP6.Wcl3xD7D.wQT5upwt82BjclFRGtpdMuCAKCbAXsG', 2, '2025-11-13 08:54:56', '2025-11-13 09:03:33'),
(15, 'Kevin diks', 'kevins@gmail.com', NULL, '1764734110_IMG-20251122-WA0000.jpg', '$2y$10$.k6otDWrY7cJQQGwcbhMIuTL7JGZ.HyndWNgICiKpnkkEQmgaBH1y', 2, '2025-11-30 11:25:11', '2025-12-05 08:21:59'),
(16, 'Alfajar Islami', 'user_google@gmail.com', NULL, 'user_16_1764898136.png', '$2y$10$tLTcgoV25vYgAaW.FvXBg.UG7QQaoMM6VLJzdygAXpKnSi74/ADNy', 2, '2025-12-05 08:04:22', '2025-12-05 08:31:31'),
(18, 'Ole Romeny', 'romeny@gmail.com', NULL, '1766116943_455f6b786640b7b51f5ddd9e8fb88ee82ea02855de9b3cd375ccda6eb278865e.0.png', '$2y$10$Avs4Ao/MfPeEjvMopHzkuuT7DGAlCNk0lZaiMzDqR6G.IgkI0NRKq', 2, '2025-12-19 10:28:18', '2025-12-19 11:02:54'),
(19, 'Jay Idzes', 'idzes@gmail.com', NULL, '1766117038_FC-Bayern-Munchen-emblem.png', '$2y$10$5CRv3r12rgqmvjK6o7FH2upStlpD2icsoqQcj7ijcHa7KmFDUXh3K', 2, '2025-12-19 11:03:23', '2025-12-19 11:03:58');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `category_id` (`category_id`);
ALTER TABLE `articles` ADD FULLTEXT KEY `judul` (`judul`,`konten`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nama` (`nama`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `forum_replies`
--
ALTER TABLE `forum_replies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `topic_id` (`topic_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `forum_topics`
--
ALTER TABLE `forum_topics`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);
ALTER TABLE `forum_topics` ADD FULLTEXT KEY `judul` (`judul`,`deskripsi`);

--
-- Indexes for table `kalkulator_history`
--
ALTER TABLE `kalkulator_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `konsultasi`
--
ALTER TABLE `konsultasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `konsultasi_ibfk_1` (`anggota_id`),
  ADD KEY `konsultasi_ibfk_2` (`pakar_id`);

--
-- Indexes for table `post_likes`
--
ALTER TABLE `post_likes`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `unique_like` (`post_id`,`user_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `role_name` (`role_name`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `role_id` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `articles`
--
ALTER TABLE `articles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `forum_replies`
--
ALTER TABLE `forum_replies`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `forum_topics`
--
ALTER TABLE `forum_topics`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `kalkulator_history`
--
ALTER TABLE `kalkulator_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `konsultasi`
--
ALTER TABLE `konsultasi`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `post_likes`
--
ALTER TABLE `post_likes`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=61;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `articles`
--
ALTER TABLE `articles`
  ADD CONSTRAINT `articles_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `articles_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `forum_replies`
--
ALTER TABLE `forum_replies`
  ADD CONSTRAINT `forum_replies_ibfk_1` FOREIGN KEY (`topic_id`) REFERENCES `forum_topics` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `forum_replies_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `forum_topics`
--
ALTER TABLE `forum_topics`
  ADD CONSTRAINT `forum_topics_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `kalkulator_history`
--
ALTER TABLE `kalkulator_history`
  ADD CONSTRAINT `kalkulator_history_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `konsultasi`
--
ALTER TABLE `konsultasi`
  ADD CONSTRAINT `konsultasi_ibfk_1` FOREIGN KEY (`anggota_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `konsultasi_ibfk_2` FOREIGN KEY (`pakar_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `post_likes`
--
ALTER TABLE `post_likes`
  ADD CONSTRAINT `post_likes_ibfk_1` FOREIGN KEY (`post_id`) REFERENCES `forum_topics` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `post_likes_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;

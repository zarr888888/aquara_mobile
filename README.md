# AQUARA Mobile 🐟

Aplikasi Manajemen Budidaya Ikan berbasis Mobile (Android) yang dibangun menggunakan Flutter. Aplikasi ini membantu pembudidaya mengelola kolam, pakan, konsultasi pakar, dan mendapatkan informasi terkini.

## 👥 Anggota Tim (Contact Person)
* **Nama:** Alfajar Islami Akbar (Ketua)
* **NIM:** 2405017
* **Email:** alfajarislamiakbar@gmail.com

* **Nama:** Aura Nabila (Anggota)
* **NIM:** 2405071
* **Email:** auranabila501@gmail.com

* **Nama:** Verlita Cahaya Putri Sulistya Ningrum (Anggota)
* **NIM:** 2405032
* **Email:** verlitaputri25@gmail.com


## 📱 Fitur Utama
1.  **Login & Register:** Autentikasi user dengan Shared Preferences.
2.  **Manajemen Artikel:** Membaca berita dan tips budidaya (GET API).
3.  **Forum Diskusi:** Tanya jawab antar pembudidaya (GET & POST API).
4.  **Konsultasi Pakar:** Terhubung langsung ke WhatsApp Pakar (Simulasi Doang).
5.  **Kalkulator Pakan:** Menghitung estimasi biaya dan keuntungan.
6.  **Edit Profil:** Update data pengguna beserta foto profil (Multipart Request).

## 🛠️ Tech Stack & Dependencies
Aplikasi ini dibangun menggunakan:
* **Framework:** Flutter (Dart)
* **State Management:** Provider
* **Networking:** Http
* **Local Storage:** Shared Preferences
* **UI Components:** Google Fonts, Url Launcher, Image Picker

**Daftar Dependencies (`pubspec.yaml`):**
* `provider: ^6.0.0`
* `http: ^1.1.0`
* `shared_preferences: ^2.2.0`
* `google_fonts: ^6.1.0`
* `url_launcher: ^6.1.0`
* `image_picker: ^1.0.0`
* `intl: ^0.18.0`

## 🚀 Cara Setup & Menjalankan Aplikasi (Run)

Pastikan Flutter SDK sudah terinstal.

1.  **Clone Repository:**
    ```bash
    git clone [https://github.com/zarr888888/aquara_mobile.git](https://github.com/zarr888888/aquara_mobile.git)
    ```
2.  **Masuk ke Folder:**
    ```bash
    cd aquara_mobile
    ```
3.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```
4.  **Jalankan Aplikasi:**
    Pastikan Emulator atau HP fisik sudah tersambung.
    ```bash
    flutter run
    ```

## 📦 Cara Build Aplikasi (APK)

Untuk menghasilkan file `.apk` siap instal:

1.  Jalankan perintah berikut di terminal:
    ```bash
    flutter build apk --release
    ```
2.  File APK akan muncul di folder:
    `build/app/outputs/flutter-apk/app-release.apk`


[DOWNLOAD APK DISINI](sha256:51df83288053348b02a2b9491ebf3de66edb09638a1bf13533691949ca784f20)
# Blueprint: Stacker Game

## Ringkasan

Ini adalah game sederhana yang dibuat dengan Flutter dan Flame Engine. Tujuannya adalah menumpuk balok setinggi mungkin. Aplikasi ini sedang dalam proses persiapan untuk rilis ke Google Play Store.

## Desain dan Fitur

*   **Gameplay**: Pemain mengetuk layar untuk menghentikan balok yang bergerak. Jika posisi balok pas, tumpukan akan bertambah tinggi. Jika tidak, lebar balok akan berkurang.
*   **Skor**: Pemain mendapatkan skor untuk setiap balok yang berhasil ditumpuk.
*   **Game Over**: Permainan berakhir jika pemain gagal menumpuk balok.
*   **Restart**: Pemain dapat memulai kembali permainan setelah game over.

## Rencana Rilis Google Play Store

Berikut adalah langkah-langkah yang akan diambil untuk mempersiapkan aplikasi ini untuk Google Play Store:

1.  **Membuat File `blueprint.md`**: Membuat dokumentasi untuk melacak semua perubahan dan rencana.
2.  **Memperbarui `pubspec.yaml`**: Menambahkan deskripsi dan detail lain yang diperlukan.
3.  **Memeriksa Konfigurasi Android**: Memastikan file `build.gradle` memiliki konfigurasi yang benar untuk rilis (`versionCode`, `versionName`, `applicationId`).
4.  **Menambahkan Ikon Aplikasi**: Membuat ikon peluncur (launcher icon) yang sesuai untuk aplikasi.
5.  **Membangun App Bundle**: Menghasilkan file rilis dalam format Android App Bundle (`.aab`).
6.  **Penandatanganan Aplikasi (Signing)**: Mengkonfigurasi aplikasi agar ditandatangani dengan kunci rilis.

## IsyaratKu - Aplikasi Penerjemah Bahasa Isyarat Berbasis AI

IsyaratKu adalah aplikasi penerjemah Bahasa Isyarat Indonesia (BISINDO) yang menggunakan teknologi AI untuk mengenali gerakan tangan dari foto atau gambar galeri, kemudian menerjemahkannya menjadi huruf alfabet.
Aplikasi ini dirancang agar mudah digunakan, cepat, dan akurat sehingga membantu pengguna yang baru pertama kali mempelajari bahasa isyarat.

## Fitur Utama
1. Splash Screen

   Ketika aplikasi dibuka pertama kali, pengguna akan melihat splash screen yang berisi panduan singkat mengenai cara menggunakan aplikasi, tips mengambil foto dan informasi singkat tentang aplikasi IsyaratKu
   
2. Deteksi Bahasa Isyarat

   Aplikasi menyediakan dua opsi input: mengambil foto dengan kamera atau memilih gambar dari galeri. Jika menggunakan kamera, pengguna perlu memberikan izin akses, lalu mengarahkan kamera ke tangan dengan jelas untuk diproses oleh AI. Hasil deteksi bisa berupa pesan seperti "Huruf M terdeteksi", "Tangan tidak terdeteksi. Posisikan tangan lebih jelas di frame.", "Huruf A tidak jelas", atau "Gagal memproses foto atau API tidak merespons". Jika memilih gambar dari galeri, pengguna cukup memilih foto dan menekan tombol konfirmasi & Deteksi, lalu hasilnya akan muncul dengan format pesan yang sama seperti mode kamera. Pengguna bisa memilih ulang fotonya.
3. Riwayat Deteksi

   Semua hasil deteksi baik yang berhasil maupun gagal akan tersimpan di halaman Riwayat, sehingga pengguna bisa melihat histori penggunaan dan memantau hasil deteksi sebelumnya.

4. Kamus BISINDO

   Pengguna dapat membuka halaman Kamus yang berisi visualisasi bentuk tangan untuk setiap huruf, penjelasan ringkas dan fitur suara untuk menyebutkan huruf (text-to-speech)
   
5. About Page

   Berisi penjelasan singkat tentang aplikasi IsyaratKu, cara menggunakan aplikasi dan tips mengambil foto dengan benar

## Cara Menjalankan Server
1. Menyiapkan Notebook Colab

   Server dijalankan menggunakan Google Colab, sehingga langkah pertama adalah membuka notebook yang berisi seluruh kode backend, termasuk model AI, fungsi deteksi, dan konfigurasi server Flask. Notebook ini menjadi tempat menjalankan semua proses server secara langsung.

2. Menginstal Library yang Dibutuhkan

   Selanjutnya, jalankan sel instalasi yang memuat semua library penting seperti Flask, MediaPipe, TensorFlow, OpenCV, dan pyngrok. Semua dependensi ini diperlukan agar server bisa menerima gambar, mendeteksi tangan, menjalankan model AI, dan menyediakan API yang dapat diakses secara publik.

3. Mengautentikasi Ngrok

   Untuk membuat server bisa diakses dari luar Colab, masukkan ngrok auth token. Langkah ini memungkinkan pyngrok membuat alamat URL publik yang nantinya digunakan aplikasi mobile untuk mengirim gambar ke server.

4. Menjalankan Server Flask

   Ketika sel server Flask dijalankan, sistem akan memuat model bisindo_balanced.keras, mengaktifkan detektor tangan MediaPipe, dan menyiapkan dua endpoint API: /predict untuk gambar kamera (Base64) dan /upload_image_and_detect untuk unggahan gambar galeri. Pada tahap ini, seluruh logika deteksi siap dijalankan.

5. Mengakses URL Publik dari Ngrok

   Setelah server aktif, pyngrok otomatis menghasilkan sebuah URL publik. URL inilah yang digunakan aplikasi untuk mengirim gambar ke API. Selama notebook tetap berjalan, server AI akan terus aktif dan siap menerima permintaan deteksi dari aplikasi.

Link Gdrive: https://drive.google.com/file/d/1X5DzSgDTT4ndtLBmYrNVbXGz-9lVCv8I/view?usp=sharing

# Pink Guy Adventure - Arcade Endless Loop

Sebuah game platformer 2D seru yang dikembangkan menggunakan **Godot Engine 4.x**. Game ini mengusung mekanik *Arcade Endless Loop*, di mana pemain ditantang untuk bertahan hidup selama mungkin melewati rintangan level yang terus berputar demi mengumpulkan skor tertinggi (*High Score*).

## Fitur Utama Game

* **Mekanik Pergerakan Lanjutan:**
  * **Wall Sliding:** Karakter dapat menempel dan merosot perlahan saat menyentuh dinding vertikal.
  * **Wall Jumping:** Karakter dapat menendang dinding untuk melompat ke arah berlawanan, membuka jalur eksplorasi vertikal baru.
  * **Double Jump:** Kemampuan melompat dua kali di udara untuk menghindari rintangan sulit.
* **Sistem Arcade Endless Loop:** Game tidak memiliki batas tamat tradisional. Setelah menyelesaikan Level 3, permainan akan otomatis berputar kembali ke Level 1 dengan menjaga akumulasi skor pemain tetap utuh.
* **Papan Game Over & Best Score:** Sistem cerdas yang mencatat skor berjalan saat ini serta menyimpan rekor skor tertinggi (*Best Score*) sepanjang sesi permainan.
* **Menu Utama Interaktif (Main Menu):** Dilengkapi dengan tombol navigasi fungsional dan diramaikan oleh animasi karakter looping (*Pink Guy, Snail, dan Flying Slime*).
* **Audio Seamless:** Musik latar belakang (*Background Music*) yang berputar mulus sejak halaman menu utama dimulai hingga masuk ke dalam gameplay tanpa terputus saat perpindahan scene.

## Struktur Node Utama Project

* `main.tscn` / `main.gd`: Pusat kontrol *Game Manager* yang mengatur muat ulang level, kalkulasi skor, efek transisi fade, serta penanganan *UI Game Over*.
* `player.tscn` / `player.gd`: Pengatur logika fisika pergerakan karakter (Kinematik CharacterBody2D), status nyawa, arah hadap sprite, dan animasi *AnimatedSprite2D*.
* `main_menu.tscn` / `main_menu.gd`: Halaman awal game yang mengatur navigasi tombol masuk dan keluar aplikasi.

## Cara Bermain

1. Jalankan game utama (`main_menu.tscn` atau tekan **F5**).
2. Tekan tombol **PLAY** pada Menu Utama untuk memulai petualangan.
3. Kumpulkan **Apel** sebanyak-banyaknya di sepanjang level untuk meningkatkan skor Anda.
4. Hindari musuh seperti **Snail** dan **Flying Slime**. Jika menabrak mereka, karakter akan mati dan papan skor akan muncul.
5. Gunakan tombol **Retry** untuk mengulang level, atau **Quit** untuk kembali ke halaman Menu Utama.

## Video Review Game
https://drive.google.com/drive/folders/1teOC9ULY66LC_FKo5snJeKtwDlONkopX?usp=sharing

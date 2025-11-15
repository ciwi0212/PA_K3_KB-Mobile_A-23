// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'home_screen.dart'; 
import 'history_screen.dart'; 
import 'about_screen.dart';
import 'package:flutter_tts/flutter_tts.dart';

const List<Map<String, String>> dictionaryData = [
  {'letter': 'A', 'image': 'assets/images/bisindo_A.jpg', 'description': 'Dalam BISINDO, gerakan tangan untuk A berbeda, biasanya ibu jari menyentuh telapak tangan di bawah jari telunjuk.', 'audio': 'audio/A.mp3', 'example': 'Ayah, Apa, Air'},
  {'letter': 'B', 'image': 'assets/images/bisindo_B.jpg', 'description': 'Dalam BISINDO, B dilakukan dengan lima jari terbuka dan sedikit melengkung. Telapak tangan menghadap ke depan/samping.', 'audio': 'audio/B.mp3', 'example': 'Bola, Buku, Bunga'},
  {'letter': 'C', 'image': 'assets/images/bisindo_C.jpg', 'description': 'Sama seperti SIBI, semua jari membentuk huruf C dan sedikit terbuka. Telapak tangan menghadap ke depan.', 'audio': 'audio/C.mp3', 'example': 'Cinta, Cepat, Cacing'},
  {'letter': 'D', 'image': 'assets/images/bisindo_D.jpg', 'description': 'Jari telunjuk lurus ke atas, jari-jari lain ditekuk rapat. Telapak tangan menghadap ke samping.', 'audio': 'audio/D.mp3', 'example': 'Dunia, Datang, Duduk'},
  {'letter': 'E', 'image': 'assets/images/bisindo_E.jpg', 'description': 'Dalam BISINDO, E dilakukan dengan tangan terbuka penuh dan diputar sedikit. Gerakan lebih natural.', 'audio': 'audio/E.mp3', 'example': 'Ekor, Elang, Enam'},
  {'letter': 'F', 'image': 'assets/images/bisindo_F.jpg', 'description': 'Jari telunjuk dan ibu jari membentuk lingkaran. Tiga jari lainnya lurus ke atas dan dirapatkan. Telapak tangan menghadap ke depan.', 'audio': 'audio/F.mp3', 'example': 'Foto, Fakta, Fokus'},
  {'letter': 'G', 'image': 'assets/images/bisindo_G.jpg', 'description': 'Jari telunjuk dan ibu jari lurus dan sejajar. Jari-jari lain ditekuk ke dalam. Telapak tangan menghadap ke samping.', 'audio': 'audio/G.mp3', 'example': 'Gajah, Guru, Gula'},
  {'letter': 'H', 'image': 'assets/images/bisindo_H.jpg', 'description': 'Jari telunjuk dan jari tengah lurus dan sejajar. Jari-jari lain ditekuk ke dalam. Telapak tangan menghadap ke samping.', 'audio': 'audio/H.mp3', 'example': 'Hujan, Hari, Hijau'},
  {'letter': 'I', 'image': 'assets/images/bisindo_I.jpg', 'description': 'Jari kelingking lurus ke atas. Semua jari lainnya ditekuk. Telapak tangan menghadap ke depan.', 'audio': 'audio/I.mp3', 'example': 'Ikan, Ibu, Ilmu'},
  {'letter': 'J', 'image': 'assets/images/bisindo_J.jpg', 'description': 'Sama seperti I, tetapi tangan bergerak ke bawah membentuk huruf J.', 'audio': 'audio/J.mp3', 'example': 'Jalan, Jendela, Jari'},
  {'letter': 'K', 'image': 'assets/images/bisindo_K.jpg', 'description': 'Jari telunjuk dan jari tengah lurus ke atas dan terbuka. Ibu jari berada di antara dua jari tersebut. Telapak tangan menghadap ke depan.', 'audio': 'audio/K.mp3', 'example': 'Kucing, Kecil, Kopi'},
  {'letter': 'L', 'image': 'assets/images/bisindo_L.jpg', 'description': 'Ibu jari dan jari telunjuk membentuk huruf L lurus. Jari-jari lainnya ditekuk. Telapak tangan menghadap ke samping.', 'audio': 'audio/L.mp3', 'example': 'Langit, Laut, Lima'},
  {'letter': 'M', 'image': 'assets/images/bisindo_M.jpg', 'description': 'Jari manis, tengah, dan telunjuk dirapatkan. Ibu jari melingkari jari manis. Telapak tangan menghadap ke bawah.', 'audio': 'audio/M.mp3', 'example': 'Makan, Mata, Meja'},
  {'letter': 'N', 'image': 'assets/images/bisindo_N.jpg', 'description': 'Jari tengah dan telunjuk dirapatkan. Ibu jari melingkari jari tengah. Telapak tangan menghadap ke bawah.', 'audio': 'audio/N.mp3', 'example': 'Naga, Naik, Nanas'},
  {'letter': 'O', 'image': 'assets/images/bisindo_O.jpg', 'description': 'Semua jari dan ibu jari membentuk lingkaran. Telapak tangan menghadap ke depan.', 'audio': 'audio/O.mp3', 'example': 'Obat, Otak, Orang'},
  {'letter': 'P', 'image': 'assets/images/bisindo_P.jpg', 'description': 'Jari telunjuk dan jari tengah lurus ke bawah. Ibu jari menempel pada ujung jari tengah. Telapak tangan menghadap ke depan.', 'audio': 'audio/P.mp3', 'example': 'Papan, Pohon, Pulang'},
  {'letter': 'Q', 'image': 'assets/images/bisindo_Q.jpg', 'description': 'Ibu jari dan jari telunjuk menjulur ke bawah. Jari-jari lainnya ditekuk. Telapak tangan menghadap ke depan.', 'audio': 'audio/Q.mp3', 'example': 'Qatar (Nama Tempat)'},
  {'letter': 'R', 'image': 'assets/images/bisindo_R.jpg', 'description': 'Jari tengah menyilang di atas jari telunjuk. Jari-jari lain ditekuk. Telapak tangan menghadap ke depan.', 'audio': 'audio/R.mp3', 'example': 'Rambut, Roda, Rumah'},
  {'letter': 'S', 'image': 'assets/images/bisindo_S.jpg', 'description': 'Tangan dikepal dengan ibu jari melintasi jari telunjuk. Telapak tangan menghadap ke depan.', 'audio': 'audio/S.mp3', 'example': 'Sayur, Sekolah, Sepatu'},
  {'letter': 'T', 'image': 'assets/images/bisindo_T.jpg', 'description': 'Tangan dikepal. Ibu jari diselipkan di antara jari telunjuk dan jari tengah. Telapak tangan menghadap ke depan.', 'audio': 'audio/T.mpil', 'example': 'Tangan, Tidur, Topi'},
  {'letter': 'U', 'image': 'assets/images/bisindo_U.jpg', 'description': 'Jari telunjuk dan jari tengah lurus dan rapat. Jari-jari lain ditekuk. Telapak tangan menghadap ke depan.', 'audio': 'audio/U.mp3', 'example': 'Ular, Uang, Umum'},
  {'letter': 'V', 'image': 'assets/images/bisindo_V.jpg', 'description': 'Jari telunjuk dan jari tengah membentuk huruf V terbalik. Jari-jari lain ditekuk. Telapak tangan menghadap ke depan.', 'audio': 'audio/V.mp3', 'example': 'Vektor, Virus, Vokal'},
  {'letter': 'W', 'image': 'assets/images/bisindo_W.jpg', 'description': 'Jari telunjuk, tengah, dan manis lurus dan terbuka. Jari-jari lain ditekuk. Telapak tangan menghadap ke depan.', 'audio': 'audio/W.mp3', 'example': 'Warna, Waktu, Wajah'},
  {'letter': 'X', 'image': 'assets/images/bisindo_X.jpg', 'description': 'Jari telunjuk ditekuk seperti kait. Jari-jari lain ditekuk ke dalam. Telapak tangan menghadap ke depan.', 'audio': 'audio/X.mp3', 'example': 'Xenon (Unsur Kimia)'},
  {'letter': 'Y', 'image': 'assets/images/bisindo_Y.jpg', 'description': 'Ibu jari dan jari kelingking lurus ke samping. Jari-jari lain ditekuk. Telapak tangan menghadap ke depan.', 'audio': 'audio/Y.mp3', 'example': 'Yoyo, Yoga, Yakin'},
  {'letter': 'Z', 'image': 'assets/images/bisindo_Z.jpg', 'description': 'Jari telunjuk lurus dan tangan bergerak membentuk pola Z di udara. Telapak tangan menghadap ke depan.', 'audio': 'audio/Z.mp3', 'example': 'Zebra, Zero, Zakat'},
];

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  List<Map<String, String>> _filteredData = dictionaryData;

  @override
  void initState() {
    super.initState();
    _filteredData = dictionaryData;
  }

  void _filterDictionary(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = dictionaryData;
      } else {
        _filteredData = dictionaryData.where((data) {
          // Filter berdasarkan huruf awal
          return data['letter']!.toLowerCase().startsWith(query.toLowerCase());
        }).toList();
      }
    });
  }

  // --- WIDGET HELPER: Bottom Navigation Bar ---
  Widget _buildBottomNavBar(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final surfaceColor = theme.colorScheme.surface; 

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primary,
      unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
      backgroundColor: surfaceColor,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Kamus'), 
        BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Tentang'),
      ],
      currentIndex: 2, 
      onTap: (index) {
        if (index == 0) { 
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else if (index == 1) { 
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HistoryScreen()));
        } else if (index == 3) { 
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AboutAppScreen()));
        }
      },
    );
  }
  
  // --- WIDGET HELPER: Search Bar ---
  Widget _buildSearchBar(BuildContext context) {
    final theme = Theme.of(context);
    final Color defaultBorderColor = theme.colorScheme.onSurface.withOpacity(0.3);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: TextFormField(
        onChanged: _filterDictionary,
        decoration: InputDecoration(
          hintText: 'Cari huruf BISINDO (mis: A, B, C...)',
          hintStyle: TextStyle(color: theme.colorScheme.onSurface.withOpacity(0.5)),
          prefixIcon: Icon(Icons.search, color: theme.colorScheme.onSurface.withOpacity(0.7)),
          fillColor: theme.colorScheme.surface,
          filled: true,
          
          enabledBorder: OutlineInputBorder( 
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: defaultBorderColor, width: 1), 
          ),
          border: OutlineInputBorder( 
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: defaultBorderColor, width: 1), 
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.colorScheme.primary, width: 2), 
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        ),
        style: TextStyle(color: theme.colorScheme.onSurface),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kamus Isyarat',
          style: theme.textTheme.headlineLarge?.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0.6,
      ),
      body: Column(
        children: [
          // 1. Search Bar
          _buildSearchBar(context),
          
          // 2. Konten Utama (Grid Huruf dan Info BISINDO)
          Expanded(
            child: CustomScrollView(
              slivers: [
                // Grid Huruf A-Z
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, 
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1, 
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final data = _filteredData[index];
                        final startingIndex = dictionaryData.indexOf(data); 
                        
                        return _LetterCard(
                          data: data,
                          onTap: () {
                            // Navigasi ke LetterDetailScreen dengan index awal
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => _LetterDetailScreen(initialIndex: startingIndex),
                              ),
                            );
                          },
                        );
                      },
                      childCount: _filteredData.length,
                    ),
                  ),
                ),
                
                // Section BISINDO Info
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          // Diubah dari SIBI ke BISINDO
                          'Tentang BISINDO',
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: theme.colorScheme.onSurface.withOpacity(0.05),
                                blurRadius: 5,
                              )
                            ]
                          ),
                          child: Text(
                            // Deskripsi diubah dari SIBI ke BISINDO
                            'BISINDO (Bahasa Isyarat Indonesia) adalah bahasa isyarat alami yang berkembang dari komunitas Tuli di Indonesia. BISINDO lebih diutamakan karena mencerminkan tata bahasa dan budaya Tuli, menjadikannya bahasa isyarat yang lebih alami dan otentik.',
                            style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }
}

// --- WIDGET HELPER: Card Huruf (Dinamis) ---
class _LetterCard extends StatelessWidget {
  final Map<String, String> data;
  final VoidCallback onTap;

  const _LetterCard({
    required this.data,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Card(
        color: theme.colorScheme.surface, 
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Text(
            data['letter']!,
            style: TextStyle(
              color: primary,
              fontSize: 48,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// --- Halaman Detail Huruf BISINDO ---
// -----------------------------------------------------------------------------
class _LetterDetailScreen extends StatefulWidget {
  final int initialIndex;

  const _LetterDetailScreen({required this.initialIndex});

  @override
  State<_LetterDetailScreen> createState() => _LetterDetailScreenState();
}

class _LetterDetailScreenState extends State<_LetterDetailScreen> {
  late PageController _pageController;
  late int _currentIndex;
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
    _initTts();
  }

  void _initTts() async {
    await _flutterTts.setLanguage("id-ID");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    _flutterTts.stop(); 
    super.dispose();
  }

  // Metode untuk memainkan suara (Placeholder)
 void _playAudio(String letter) async {
  final textToSpeak = "Huruf $letter";

  try {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Mengucapkan: $textToSpeak'),
        duration: Duration(seconds: 2),
      ),
    );

    await _flutterTts.speak(textToSpeak);
  } catch (e) {
    print("Error TTS: $e");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Gagal menghasilkan suara untuk huruf $letter'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}

  // --- WIDGET HELPER: Bottom Navigation Bar (DETAIL) ---
  Widget _buildBottomNavBar(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final surfaceColor = theme.colorScheme.surface; 

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primary,
      unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
      backgroundColor: surfaceColor,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Kamus'), 
        BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Tentang'),
      ],
      currentIndex: 2, // Index 2 untuk 'Kamus' (aktif)
      onTap: (index) {
        if (index == 0) { 
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else if (index == 1) { 
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HistoryScreen()));
        } else if (index == 2) { 
          Navigator.of(context).pop(); // Kembali ke halaman daftar Kamus
        } else if (index == 3) { 
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AboutAppScreen()));
        }
      },
    );
  }

  // --- WIDGET HELPER: Indikator Halaman (Pagination) ---
  Widget _buildPaginationIndicator(BuildContext context, int currentPage, int totalPages) {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          '$currentPage / $totalPages',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentData = dictionaryData[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Huruf ${currentData['letter']} (BISINDO)',
          style: theme.textTheme.headlineLarge?.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0.6,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(), // Kembali ke Kamus
        ),
      ),
      
      // Menggunakan PageView untuk swipe antar huruf
      body: PageView.builder(
        controller: _pageController,
        itemCount: dictionaryData.length,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        itemBuilder: (context, index) {
          final data = dictionaryData[index];
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Indikator Halaman (Pagination)
                _buildPaginationIndicator(
                  context, 
                  index + 1, // Halaman dimulai dari 1 
                  dictionaryData.length,
                ),
                const SizedBox(height: 15),

                // 2. Konten Detail Utama
                _buildDetailContent(context, data),
              ],
            ),
          );
        },
      ),
      
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // Widget untuk konten detail di setiap PageView
  Widget _buildDetailContent(BuildContext context, Map<String, String> data) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // 1. Preview Gambar Isyarat
        Container(
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: theme.brightness == Brightness.light ? Colors.grey.shade200 : Colors.grey.shade800,
          ),
          child: Center(
            // Tampilkan Gambar BISINDO 
            child: Image.asset(
              data['image']!, 
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Text(
                  '[Gambar BISINDO ${data['letter']}]\n(Placeholder image: ${data['image']} tidak ditemukan)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.colorScheme.error, fontSize: 16),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 30),

        // 2. Tombol Play Suara
        ElevatedButton.icon(
        onPressed: () => _playAudio(data['letter']!),
        icon: const Icon(Icons.play_arrow),
        label: Text('Dengarkan Suara ${data['letter']}'),
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 15),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

        const SizedBox(height: 30),
        
        // 3. Card Detail Gerakan Isyarat
        _buildInfoCard(
          context,
          title: 'Bentuk Isyarat BISINDO',
          content: data['description']!,
          icon: Icons.sign_language_outlined,
        ),
        const SizedBox(height: 15),

        // 4. Card Contoh Penggunaan 
        _buildInfoCard(
          context,
          title: 'Contoh Penggunaan',
          content: data['example']!,
          icon: Icons.lightbulb_outline,
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  // Widget Helper untuk Info Card
  Widget _buildInfoCard(BuildContext context, {required String title, required String content, required IconData icon}) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.onSurface.withOpacity(0.05),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: theme.colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.primary),
              ),
            ],
          ),
          const Divider(height: 15),
          Text(
            content,
            style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
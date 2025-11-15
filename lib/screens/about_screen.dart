// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'home_screen.dart'; 
import 'history_screen.dart'; 
import 'dictionary_screen.dart'; 

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  // Warna palette statis 
  static const Color kPrimary = Color(0xFF190482);
  static const Color kSecondary = Color(0xFF7752FE);
  static const Color kTertiary = Color(0xFF8E8FFA);

  // Gradient untuk card 
  LinearGradient get _cardGradient => const LinearGradient(
        colors: [kSecondary, kTertiary],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );

  // --- WIDGET HELPER: Bottom Navigation Bar ---
  Widget _buildBottomNavBar(BuildContext context) {
    // Mengambil theme global untuk Bottom Nav Bar
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
        BottomNavigationBarItem(icon: Icon(Icons.history_outlined), label: 'Riwayat'), 
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Kamus'),
        BottomNavigationBarItem(icon: Icon(Icons.info), label: 'Tentang'), 
      ],
      currentIndex: 3, // Tentang
      onTap: (index) {
        if (index == 0) { // Navigasi ke Beranda
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else if (index == 1) { // Navigasi ke Riwayat
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HistoryScreen()));
        } else if (index == 2) { // Navigasi ke Kamus
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DictionaryScreen()));
        }
      },
    );
  }

  // helper untuk gradient card 
  Widget _buildGradientCard({
    required String title,
    required Widget child,
    required BuildContext context,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: _cardGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: kPrimary.withOpacity(0.3),
            blurRadius: 15, 
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: kTertiary.withOpacity(0.2), 
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    final isLarge = mq.size.height > 800 || mq.size.width > 600;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        centerTitle: true,
        elevation: 0.6,
        title: Text(
          'Tentang',
          style: theme.textTheme.headlineLarge?.copyWith(fontSize: 20)
        ),
        iconTheme: IconThemeData(color: theme.colorScheme.onSurface),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: LayoutBuilder(builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 12),

                  Center(
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/logo_mobile.png', 
                          height: isLarge ? 200 : 150,
                          width: isLarge ? 200 : 150,  
                          fit: BoxFit.contain,
                        ),
                        
                        const SizedBox(height: 12),

                        Text(
                          'Versi 1.0.0',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Section: Tentang Aplikasi
                  _buildGradientCard(
                    title: 'Tentang Aplikasi',
                    child: const Text(
                      'IsyaratKu adalah aplikasi penerjemah bahasa isyarat yang menggunakan teknologi AI untuk mengenali dan menerjemahkan gerakan tangan menjadi huruf alfabet.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    context: context,
                  ),

                  const SizedBox(height: 16),

                  // Section: Fitur Utama 
                  _buildGradientCard(
                    title: 'Fitur Utama',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        _BulletText('Deteksi otomatis bahasa isyarat dari foto'),
                        SizedBox(height: 6),
                        _BulletText('Notifikasi suara saat huruf terdeteksi'),
                        SizedBox(height: 6),
                        _BulletText('Kamus lengkap bahasa isyarat A–Z'),
                        SizedBox(height: 6),
                        _BulletText('Mudah digunakan tanpa login'),
                      ],
                    ),
                    context: context,
                  ),

                  const SizedBox(height: 16),

                  // Section: Cara Penggunaan
                  _buildGradientCard(
                    title: 'Cara Penggunaan',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('1. Ambil foto atau upload dari galeri', style: TextStyle(color: Colors.white, height: 1.6)),
                        SizedBox(height: 6),
                        Text('2. Pastikan tangan terlihat jelas', style: TextStyle(color: Colors.white, height: 1.6)),
                        SizedBox(height: 6),
                        Text('3. Tekan tombol "Terjemahkan"', style: TextStyle(color: Colors.white, height: 1.6)),
                        SizedBox(height: 6),
                        Text('4. Lihat hasil terjemahan huruf', style: TextStyle(color: Colors.white, height: 1.6)),
                      ],
                    ),
                    context: context,
                  ),

                  // bottom spacing sebelum navbar
                  SizedBox(height: isLarge ? 80 : 60),
                ],
              ),
            ),
          );
        }),
      ),
      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }
}
class _BulletText extends StatelessWidget {
  final String text;
  const _BulletText(this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('✓ ', style: TextStyle(color: Colors.white, fontSize: 14, height: 1.6)),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 14, height: 1.6))),
      ],
    );
  }
}
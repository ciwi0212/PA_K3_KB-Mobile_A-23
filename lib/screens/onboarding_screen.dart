import 'package:flutter/material.dart';
import 'home_screen.dart'; 


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  // Controller untuk mengontrol halaman PageView
  final PageController _pageController = PageController();
  int _currentPage = 0; // Melacak halaman saat ini 
  // Data untuk setiap halaman tutorial
  final List<Map<String, String>> onboardingData = [
    {
      'title': 'Selamat Datang di IsyaratKu',
      'subtitle': 'Aplikasi penerjemah bahasa isyarat yang mudah dan cepat',
    },
    {
      'title': 'Ambil atau Upload Foto',
      'subtitle': 'Gunakan kamera atau pilih foto dari galeri untuk menerjemahkan bahasa isyarat',
    },
    {
      'title': 'Deteksi Otomatis',
      'subtitle': 'Aplikasi akan otomatis mendeteksi huruf dari bahasa isyarat yang ada foto',
    },
    {
      'title': 'Tips Penggunaan',
      'subtitle': 'Pastikan pencahayaan cukup dan tangan terlihat jelas',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // Fungsi navigasi ke halaman utama
  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()), 
    );
  }

  @override
Widget build(BuildContext context) {
  // Ambil warna utama untuk tombol panah
  final primaryColor = Theme.of(context).colorScheme.primary; 

  return Scaffold(
    body: SafeArea(
      child: Stack(
        children: <Widget>[
          // 1. PageView: Bagian yang bisa digeser untuk menampilkan halaman tutorial
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return _buildOnboardPage(
                onboardingData[index]['title']!,
                onboardingData[index]['subtitle']!,
                index, 
              );
            },
          ),

          // 2. Kontrol Panah Kiri dan Kanan 
          if (_currentPage > 0)
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, size: 30, color: primaryColor),
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
              ),
            ),
            
          if (_currentPage < onboardingData.length - 1)
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.arrow_forward_ios, size: 30, color: primaryColor),
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn,
                  );
                },
              ),
            ),

          // 3. Indikator Titik dan Tombol Lewati/Mulai 
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Indikator Titik
                  _buildPageIndicator(),
                  
                  // Tombol Lewati Tutorial / Mulai
                  _currentPage == onboardingData.length - 1
                      ? ElevatedButton(
                          onPressed: _goToHome,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Text('Mulai'),
                        )
                      : TextButton(
                          onPressed: _goToHome, 
                          child: Text(
                            'Lewati Tutorial',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

 // Widget untuk membangun satu halaman tutorial 
 Widget _buildOnboardPage(String title, String subtitle, int index) { 
  final theme = Theme.of(context);

  return Column(
    children: [
      const Spacer(), 

      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: theme.textTheme.headlineLarge?.copyWith(fontSize: 32.0),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            Text(
              subtitle,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontSize: 16.0,
                color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),

      const Spacer(), 
    ],
  );
}

 // Widget untuk membangun indikator titik
  Widget _buildPageIndicator() {
    List<Widget> list = [];
    final Color activeColor = Theme.of(context).colorScheme.primary; 

    for (int i = 0; i < onboardingData.length; i++) {
      list.add(_indicator(i == _currentPage, activeColor));
    }

    return Padding(
      padding: const EdgeInsets.only(left: 0), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, 
        children: list,
      ),
    );
  }

  // Widget untuk satu titik (aktif/non-aktif)
  Widget _indicator(bool isActive, Color activeColor) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 5.0),
      height: 8.0,
      width: isActive ? 24.0 : 8.0, 
      decoration: BoxDecoration(
        color: isActive ? activeColor : Colors.grey.shade400,
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
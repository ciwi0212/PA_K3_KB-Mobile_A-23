import 'package:flutter/material.dart';
import '../main.dart'; 
import 'home_screen.dart';
import 'history_screen.dart';  
import 'about_screen.dart';
import 'dictionary_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0; 

  // List semua halaman yang akan diakses melalui BottomNavBar
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    HistoryScreen(),
    DictionaryScreen(),
    AboutAppScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // --- Fungsi untuk membangun Bottom Nav Bar ---
  Widget _buildBottomNavBar(Color primary) {
    final surfaceColor = Theme.of(context).colorScheme.surface; 

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed, 
      selectedItemColor: primary, 
      unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), 
      backgroundColor: surfaceColor, 
      elevation: 8,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'), 
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Kamus'),
        BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Tentang'),
      ],
      currentIndex: _selectedIndex, // Ambil index yang aktif
      onTap: _onItemTapped, // Panggil fungsi saat item ditekan
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).colorScheme.primary;

    return Scaffold(
      // --- AppBar (Ambil dari Home Screen) ---
      appBar: AppBar(
        title: Text(
          // Tampilkan Judul sesuai halaman yang aktif
          ['Beranda', 'Riwayat', 'Kamus', 'Tentang'][_selectedIndex],
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent, 
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark 
                ? Icons.light_mode_outlined 
                : Icons.dark_mode_outlined, 
            ), 
            color: Theme.of(context).colorScheme.secondary,
            onPressed: () {
              themeKey.currentState!.toggleTheme(); 
            },
          ),
        ],
      ),
      // --- Body: Tampilkan halaman sesuai index yang dipilih ---
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),

      // Pasang Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavBar(primary),
    );
  }
}
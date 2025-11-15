import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart'; 
import 'history_screen.dart' hide HexColor;
import 'camera_screen.dart';
import 'about_screen.dart';
import 'dictionary_screen.dart';
import 'image_picker.dart';
import 'dart:typed_data';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color primary = theme.colorScheme.primary;
    final Color secondary = theme.colorScheme.secondary;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Beranda',
          style: theme.textTheme.headlineLarge?.copyWith(fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.dark 
                ? Icons.dark_mode_outlined 
                : Icons.light_mode_outlined,  
            ), 
            color: secondary,
            onPressed: () {
              themeKey.currentState!.toggleTheme();
            },
          ),
        ],
      ),
      
body: SingleChildScrollView(
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center, 
      children: <Widget>[ 
        const SizedBox(height: 20),
        _buildLogoPlaceholder(),
        const SizedBox(height: 50),

        _buildActionButton(
          context, 
          title: 'Buka Kamera', 
          icon: Icons.camera_alt,
          onPressed: () async { 
            final historyItem = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const CameraScreen())
            );
            
            if (historyItem != null) {
              await addHistoryItem(historyItem);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Riwayat ${historyItem.detectedLetter} berhasil disimpan!')),
              );
            }
          },
        ),
        const SizedBox(height: 16), 

        _buildActionButton(
          context,
          title: 'Pilih Dari Galeri',
          icon: Icons.image,
          onPressed: () {
            _pickImageFromGallery(context);
          },
        ), 
        
        const SizedBox(height: 40),

        _buildTipsCard(context, primary),
          ],
        ),
      ),
    ),
      
      bottomNavigationBar: _buildBottomNavBar(context, primary),
    );
  }

 void _pickImageFromGallery(BuildContext context) async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);

  if (image != null) {
 
   final Uint8List rawBytes = await image.readAsBytes(); 

    final historyItem = await Navigator.of(context).push(
     MaterialPageRoute(
       builder: (context) => IsyarakuApp(
        initialImageBytes: rawBytes,
           ),
           ),
         );

 if (historyItem != null) {
 
 await addHistoryItem(historyItem); 
 ScaffoldMessenger.of(context).showSnackBar(
 SnackBar(content: Text('Riwayat ${historyItem.detectedLetter} berhasil disimpan!')),
);
 }
 } 
} 

  // --- Widget Pembantu ---

  Widget _buildLogoPlaceholder() {
    return Image.asset(
      'assets/images/logo_mobile.png', 
      height: 200, 
      width: 200, 
      fit: BoxFit.contain,
    );
  }

  Widget _buildActionButton(BuildContext context, {required String title, required IconData icon, required VoidCallback onPressed}) {
    final Color buttonFgColor = Theme.of(context).colorScheme.onSurface;
    
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: HexColor.fromHex('#8E8FFA').withOpacity(0.8), 
          foregroundColor: buttonFgColor, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4, 
        ),
        icon: Icon(icon, size: 28),
        label: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
  
  Widget _buildTipsCard(BuildContext context, Color primary) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final Color cardBgColor = isDarkMode 
        ? primary.withOpacity(0.2) 
        : HexColor.fromHex('#C2D9FF');

    final Color fgColor = isDarkMode 
        ? Colors.white 
        : primary;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: cardBgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: fgColor, size: 24), 
              const SizedBox(width: 8),
              Text(
                'Tips Penggunaan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: fgColor, 
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildTipPoint('Pastikan pencahayaan cukup terang', context),
          _buildTipPoint('Tangan terlihat jelas dan fokus', context),
          _buildTipPoint('Hindari gerakan saat memotret', context),
        ],
      ),
    );
  }
  
 Widget _buildTipPoint(String text, BuildContext context) { 

  final Color onSurface = Theme.of(context).colorScheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 8.0),
      child: Text(
        '• $text',
        style: TextStyle(
          fontSize: 14,
          color: onSurface.withOpacity(0.8), 
        ),
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context, Color primary) {
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
      currentIndex: 0, // Beranda
      onTap: (index) {
        if (index == 1) { // Riwayat
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HistoryScreen()));
        } else if (index == 2) { // Kamus
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DictionaryScreen()));  
        } else if (index == 3) { // Tentang
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AboutAppScreen()));
        } else if (index == 0) { // Beranda
        }
      },
    );
  }
}
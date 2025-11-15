import 'package:flutter/material.dart';
import 'package:isyaratku/screens/about_screen.dart';
import 'home_screen.dart';
import 'dictionary_screen.dart';
import '../models/detection_history.dart'; 
import 'package:flutter/foundation.dart';
import '../services/storage_service.dart';

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

// final List<DetectionHistory> globalHistoryList = []; 

Future<void> addHistoryItem(DetectionHistory item) async {
  // 1. Muat riwayat yang ada
  List<DetectionHistory> currentList = await StorageService.loadHistory();
  
  // 2. Tambahkan item baru ke awal list
  currentList.insert(0, item); 
  
  // 3. Simpan kembali seluruh list
  await StorageService.saveHistory(currentList);
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> { 
  final Color primaryColor = HexColor.fromHex('#7752FE');
  
  List<DetectionHistory> _historyList = []; 
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistoryData(); 
  }

  // Fungsi Pengambilan Data Riwayat
  Future<void> _loadHistoryData() async {
    setState(() {
      _isLoading = true;
    });

    final loadedList = await StorageService.loadHistory();
    
    if(mounted) {
      setState(() {
        _historyList = loadedList; // Gunakan data dari penyimpanan
        _isLoading = false;
      });
    }
  }

  // Fungsi untuk menghapus semua 
  Future<void> _deleteAllHistory() async { 
    await StorageService.saveHistory([]);
    
    // 2. Perbarui state lokal
    setState(() {
      _historyList.clear();
    });
  }
  // Fungsi untuk menghapus satu item 
  Future<void> _deleteHistoryItem(String id) async { 

    List<DetectionHistory> currentList = await StorageService.loadHistory();

    currentList.removeWhere((item) => item.id == id);

    await StorageService.saveHistory(currentList);

    setState(() {
      _historyList.removeWhere((item) => item.id == id);
    });
  }
  
  // Fungsi untuk menampilkan dialog gambar
 void _showImageDialog(BuildContext context, Uint8List imageBytes) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          clipBehavior: Clip.antiAlias, 
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          // Ganti Column dengan Stack untuk menempatkan tombol di atas gambar
          child: Stack( 
            alignment: Alignment.topRight, // Menentukan posisi default
            children: [
              Column(
                mainAxisSize: MainAxisSize.min, // Sesuaikan ukuran Column dengan konten
                children: [
                  // Gambar
                  Image.memory(
                    imageBytes,
                    fit: BoxFit.contain,
                    height: MediaQuery.of(context).size.height * 0.6, 
                  ),
                  // Tambahkan ruang di bawah gambar 
                  const SizedBox(height: 20), 
                ],
              ),
              
              // Tombol Tutup (X) di Pojok Kanan Atas
              Positioned(
                top: 5,
                right: 5,
                child: IconButton(
                  icon: const Icon(Icons.close), 
                  color: Colors.black54, 
                  iconSize: 28,
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // --- WIDGET HELPER: Item Riwayat ---
  Widget _buildHistoryItem(BuildContext context, DetectionHistory item) {
    final theme = Theme.of(context);
    final statusColor = item.isSuccess ? primaryColor : theme.colorScheme.error;
    
    final title = item.isSuccess
        ? 'Huruf ${item.detectedLetter.toUpperCase()}'
        : 'Tidak Terdeteksi';
    
    final timeString = '${item.timestamp.hour.toString().padLeft(2, '0')}.${item.timestamp.minute.toString().padLeft(2, '0')}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.1), width: 1),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.shadow.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ListTile(
          // Kiri: Kotak Gambar 
          leading: GestureDetector( 
            onTap: item.imageBytes != null 
                ? () => _showImageDialog(context, item.imageBytes!) // Panggil dialog jika ada gambar
                : null, 
            child: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: item.imageBytes != null 
                  ? ClipRRect( // Tambahkan ClipRRect agar gambar terpotong sesuai border radius
                      borderRadius: BorderRadius.circular(8),
                      child: Image.memory(item.imageBytes!, fit: BoxFit.cover),
                    )
                  : Icon(Icons.broken_image, color: theme.colorScheme.onSurface.withOpacity(0.5)), // Ganti ikon jika gambar null
            ),
          ),
          
          // Tengah: Judul & Waktu
          title: Text(
            title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          subtitle: Row(
            children: [
              Icon(
                item.isSuccess ? Icons.check_circle_outline : Icons.cancel_outlined,
                size: 16,
                color: statusColor,
              ),
              const SizedBox(width: 4),
              Text(
                'Hari ini, $timeString',
                style: theme.textTheme.bodySmall,
              ),
            ],
          ),
          
          // Kanan: Tombol Hapus
          trailing: IconButton(
            icon: Icon(Icons.delete_outline, size: 20, color: theme.colorScheme.onSurface.withOpacity(0.6)),
            onPressed: () => _deleteHistoryItem(item.id),
          ),
        ),
      ),
    );
  }

  // --- WIDGET HELPER: Bottom Navigation Bar ---
  Widget _buildBottomNavBar(BuildContext context) {
    final theme = Theme.of(context);
    final surfaceColor = theme.colorScheme.surface;

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: primaryColor,
      unselectedItemColor: theme.colorScheme.onSurface.withOpacity(0.6),
      backgroundColor: surfaceColor,
      elevation: 8,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Beranda'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
        BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined), label: 'Kamus'),
        BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'Tentang'),
      ],
      currentIndex: 1, // Riwayat
      onTap: (index) {
        if (index == 0) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()));
        } else if (index == 2) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const DictionaryScreen()));
        } else if (index == 3) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AboutAppScreen()));
        }
      },
    );
  }

  // --- WIDGET HELPER: Tampilan Daftar Riwayat ---
  Widget _buildHistoryList(ThemeData theme) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            child: Text(
              '${_historyList.length} deteksi tersimpan',
              style: theme.textTheme.titleSmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
            ),
          ),
          const SizedBox(height: 10),
          ..._historyList.map((item) => _buildHistoryItem(context, item)).toList(),
        ],
      ),
    );
  }

  // --- WIDGET HELPER: Tampilan jika semua terhapus ---
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.history,
              size: 100,
              color: primaryColor.withOpacity(0.5), 
            ),
            const SizedBox(height: 30),
            Text(
              'Belum Ada Riwayat Deteksi',
              style: theme.textTheme.headlineLarge?.copyWith(fontSize: 24),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              'Mulai scan bahasa isyarat untuk melihat riwayat',
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }


  // --- WIDGET UTAMA ---
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat',
          style: theme.textTheme.headlineLarge?.copyWith(fontSize: 20, color: theme.colorScheme.onSurface),
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          // Tombol Hapus Semua hanya muncul jika ada data
          if (!_isLoading && _historyList.isNotEmpty)
            IconButton(
              icon: Icon(Icons.delete_sweep_outlined, color: theme.colorScheme.error),
              onPressed: _deleteAllHistory,
              tooltip: 'Hapus Semua',
            ),
        ],
      ),
      
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : _historyList.isEmpty
              ? _buildEmptyState(theme) 
              : _buildHistoryList(theme), 
      
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }
} 
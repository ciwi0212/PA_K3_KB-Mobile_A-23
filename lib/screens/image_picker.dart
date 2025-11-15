import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data'; 
import '../services/api_service.dart';
import '../models/detection_history.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

enum CameraState { 
    initial,          
    imageSelected,     
    loading,         
    detectionComplete, 
}

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: IsyarakuApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class IsyarakuApp extends StatefulWidget {
  final Uint8List? initialImageBytes; 
  
  const IsyarakuApp({super.key, this.initialImageBytes});

  @override
  State<IsyarakuApp> createState() => IsyarakuAppState();
}

class IsyarakuAppState extends State<IsyarakuApp> {
  
  bool _loading = false;

  Uint8List? _rawImageBytes; 
  String? _detectedResult; 
  CameraState _currentState = CameraState.initial;
  DetectionHistory? _lastHistoryItem;

@override
  void initState() {
  super.initState();
 if (widget.initialImageBytes != null) {
 setState(() {
_rawImageBytes = widget.initialImageBytes;
 _currentState = CameraState.imageSelected; 
 });
 }
 }

  // ==========================================================
  // Fungsi Pemilihan Gambar dari Galeri
  // ==========================================================

Future<void> _pickImage() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(source: ImageSource.gallery);

  if (picked != null) {
    Uint8List? rawBytes;

    try {
      // Menggunakan metode readAsBytes() dari XFile untuk mendapatkan bytes
      rawBytes = await picked.readAsBytes(); 
    } catch (e) {
      if (mounted) {
        // Tampilkan error jika terjadi masalah pembacaan file
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal membaca file gambar: $e')),
        );
      }
      return; 
    }

    if (!mounted) return;
    
    // State akan di-update hanya jika rawBytes berhasil didapatkan
    setState(() {
      _rawImageBytes = rawBytes;
      _currentState = CameraState.imageSelected; 
      _loading = false;
      _detectedResult = null;
      _lastHistoryItem = null;
    });
  }
}
  
  // ==========================================================
  // Fungsi Konfirmasi & Deteksi (Memanggil API)
  // ==========================================================
  Future<void> _confirmDetection() async {
  if (_rawImageBytes == null) return; 

  setState(() {
      _loading = true;
      _currentState = CameraState.loading;
      _detectedResult = null;
      _lastHistoryItem = null;
  });

    try {
      final Map<String, dynamic> detectionResult = await ApiService.uploadImageFromBytes(_rawImageBytes!);
      
      final String detectedLetter = detectionResult['prediksi']?.toString() ?? 'N/A';
      final double confidence = (detectionResult['confidence'] as num?)?.toDouble() ?? 0.0;
      
      final bool isSuccess = confidence >= 0.5; 

      String resultText;
      if (isSuccess) {
          resultText = 'Huruf ${detectedLetter.toUpperCase()} terdeteksi';
      } else {
          resultText = 'Huruf ${detectedLetter.toUpperCase()} tidak jelas';
      }
      
      final historyItem = DetectionHistory(
        id: uuid.v4(),
        detectedLetter: detectedLetter,
        timestamp: DateTime.now(),
        isSuccess: isSuccess,
        imageBytes: _rawImageBytes,
      );

      setState(() {
          _currentState = CameraState.detectionComplete;
          _detectedResult = resultText;
          _lastHistoryItem = historyItem;
      });
      
  } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.contains("No hand detected")) {
        errorMessage = "Tangan tidak terdeteksi. Posisikan tangan lebih jelas di frame.";
      } else {
        errorMessage = "Gagal memproses foto atau API tidak merespons."; 
      }
      
      final historyItem = DetectionHistory(
      id: uuid.v4(),
      detectedLetter: 'Error', // Atau pesan error yang sesuai
      timestamp: DateTime.now(),
      isSuccess: false,
      imageBytes: _rawImageBytes, // Simpan bytes gambar yang diupload
    );

    setState(() {
      _detectedResult = errorMessage;
      _currentState = CameraState.detectionComplete;
      _lastHistoryItem = historyItem; // <<< SIMPAN item GAGAL KRITIS di sini
    });

  } finally {
    setState(() {
      _loading = false;
    });
  }
}

  // ==========================================================
  // Widget Bottom Action Bar
  // ==========================================================
  Widget _buildBottomActionBar() {
  final theme = Theme.of(context);
  final isDarkMode = theme.brightness == Brightness.dark;

  // Warna untuk teks hasil deteksi
  Color textColor;

  if (_currentState == CameraState.detectionComplete) {
    if (_detectedResult != null && _detectedResult!.toLowerCase().contains("tidak")) {
      // Gagal terdeteksi Merah
      textColor = Colors.red.shade600;
    } else {
      // Sukses terdeteksi Hijau
      textColor = Colors.green.shade600;
    }
  } else {
    // Default Warna teks sekunder tema
    textColor = theme.colorScheme.onSurface.withOpacity(0.7);
  }

  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      // Warna background Container menyesuaikan tema
      color: theme.colorScheme.surface,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(20),
      ),
      boxShadow: [
        BoxShadow(
          // Warna shadow menyesuaikan tema
          color: isDarkMode ? Colors.black.withOpacity(0.5) : Colors.black12,
          blurRadius: 10,
          spreadRadius: 5
        )
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- Bagian Teks Status ---
        if (_currentState == CameraState.loading)
          Text(
            "Sedang memproses gambar...",
            style: TextStyle(fontSize: 16, color: theme.colorScheme.primary)
          )
        else if (_detectedResult != null)
          Text(
            _detectedResult!,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          )
        else
          Text(
            "Pilih gambar atau konfirmasi untuk deteksi.",
            style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface.withOpacity(0.5))
          ),

        const SizedBox(height: 15),

        // --- Bagian Tombol Aksi ---
        if (_currentState == CameraState.initial)
            ElevatedButton.icon(
                onPressed: _pickImage,
                icon: const Icon(Icons.photo_library),
                label: const Text("Pilih Gambar dari Galeri"),
                style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15)
                ),
            )
        else if (_currentState == CameraState.imageSelected)
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    // TOMBOL 1: PILIH ULANG 
                    Expanded(
                      child: OutlinedButton.icon( 
                          onPressed: () => _pickImage(), 
                          icon: const Icon(Icons.photo_library),
                          label: const Text("Pilih Ulang"),
                          style: OutlinedButton.styleFrom(
                              foregroundColor: theme.colorScheme.primary, // Warna teks/ikon primary
                              side: BorderSide(color: theme.colorScheme.primary), // Border warna primary
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)
                          ),
                      ),
                    ),
                    const SizedBox(width: 15),
                    // TOMBOL 2: KONFIRMASI & DETEKSI 
                    Expanded(
                      child: ElevatedButton.icon(
                          onPressed: _confirmDetection,
                          icon: const Icon(Icons.check),
                          label: const Text("Konfirmasi & Deteksi"),
                          style: ElevatedButton.styleFrom(
                              backgroundColor: theme.colorScheme.primary,
                              foregroundColor: theme.colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15)
                          ),
                      ),
                    ),
                ],
            )
      else if (_currentState == CameraState.detectionComplete)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // TOMBOL 1: ULANGI 
                Expanded(
                  child: OutlinedButton.icon( 
                    onPressed: () => _pickImage(),
                    icon: const Icon(Icons.refresh),
                    label: const Text("Ulangi"),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      foregroundColor: theme.colorScheme.primary, 
                      side: BorderSide(color: theme.colorScheme.primary),
                    ),
                  ),
                ),
                const SizedBox(width: 15),

              // TOMBOL 2: Selesai 
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context, _lastHistoryItem);
                  },
                  icon: const Icon(Icons.done_all),
                  label: const Text("Selesai"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                ),
              ),
            ],
          ),
      ],
    ),
  );
}

  // ==========================================================
  // Widget Build Utama
  // ==========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pilih Gambar"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              child: (_rawImageBytes != null) 
                  ? Image.memory(
                      _rawImageBytes!, 
                      fit: BoxFit.contain, 
                      height: MediaQuery.of(context).size.height * 0.7
                    ) 
                  : const Icon(Icons.image, size: 100, color: Colors.grey),
            ),

            if (_loading)
              const Center(
                  child: CircularProgressIndicator(color: Colors.deepPurple)),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomActionBar(),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:camera/camera.dart'; 
import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:permission_handler/permission_handler.dart'; 
import '../services/api_service.dart'; 
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:uuid/uuid.dart'; 
import '../models/detection_history.dart';

const uuid = Uuid();

enum CameraState {
  cameraActive, 
  detectionSuccess, 
  detectionFailed, 
}

class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  XFile? _capturedImage;
  CameraState _currentState = CameraState.cameraActive;
  String _detectedResult = '';
  IconData _flashIcon = Icons.flash_off;
  String? _boxedImageBase64;

  bool _isInitializing = false;

  DetectionHistory? _lastFailedHistoryItem;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // --- FUNGSI KAMERA ---
  Future<bool> _checkAndRequestPermissions() async {
    final cameraStatus = await Permission.camera.request();

    if (cameraStatus.isGranted) {
      return true;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Izin kamera dan mikrofon diperlukan untuk menggunakan fitur ini.'),
          duration: Duration(seconds: 3),
        ),
      );
    }
    return false;
  }

    Future<void> _initializeCamera() async {
    if (!mounted) return;
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      await _controller?.dispose();
    } catch (_) {}
    _controller = null;
    _initializeControllerFuture = null;
    if (!mounted) {
      _isInitializing = false;
      return;
    }

    if (!await _checkAndRequestPermissions()) {
      _isInitializing = false;
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak ada kamera yang tersedia.')),
          );
        }
        _isInitializing = false;
        return;
      }

      final firstCamera = cameras.first;
      _controller = CameraController(firstCamera, ResolutionPreset.high, enableAudio: false);

      _initializeControllerFuture = _controller!.initialize();

      await _initializeControllerFuture;

      if (mounted) {
        setState(() {
          _flashIcon = _controller!.value.flashMode == FlashMode.off ? Icons.flash_off : Icons.flash_on;
        });
      }
    } catch (e) {
      debugPrint('Gagal inisialisasi kamera: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal inisialisasi kamera: $e')));
        setState(() {
          _controller = null;
          _initializeControllerFuture = null;
        });
      }
    } finally {
      _isInitializing = false;
    }
  }


  Future<void> _refreshCamera() async {
  try {
    setState(() {
      _currentState = CameraState.cameraActive;
      _capturedImage = null;
      _detectedResult = "Memuat ulang kamera...";
    });

    await _controller?.dispose();

    await _initializeCamera();

    setState(() {
      _detectedResult = "";
    });
  } catch (e) {
    debugPrint("Error refresh kamera: $e");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal reload kamera: $e")),
      );
    }
  }
}


Future<void> _processImageAndDetect(XFile file) async {
  setState(() {
    _capturedImage = file;
    _detectedResult = 'Memproses...';
    _boxedImageBase64 = null;
  });

  Uint8List? imageBytes; 
  
  try {
    imageBytes = await file.readAsBytes(); 
    final mimeType = file.mimeType ?? 'image/jpeg'; 

    final Map<String, dynamic> detectionResult = 
        await ApiService.detectLetter(imageBytes, mimeType);
    

    final String detectedLetter = detectionResult['prediksi']?.toString() ?? 'N/A';
    final double confidence = (detectionResult['confidence'] as num?)?.toDouble() ?? 0.0;
    final String boxedImage = detectionResult['boxed_image']?.toString() ?? '';

    final bool isSuccess = confidence >= 0.5; 

    String resultText;
    if (isSuccess) {
        resultText = 'Huruf "${detectedLetter.toUpperCase()}" terdeteksi';
    } else {
        resultText = 'Huruf ${detectedLetter.toUpperCase()} tidak jelas';
    }
    
    // --- BUAT HISTORY ITEM  ---
    final historyItem = DetectionHistory(
      id: uuid.v4(),
      detectedLetter: detectedLetter,
      timestamp: DateTime.now(),
      isSuccess: isSuccess,
      imageBytes: imageBytes,
    );
   
    // --- UPDATE STATE UI ---
    setState(() {
      _capturedImage = file;
      _boxedImageBase64 = boxedImage; 
      _currentState = isSuccess ? CameraState.detectionSuccess : CameraState.detectionFailed;
      _detectedResult = resultText;
      
      // Simpan historyItem ke state agar tombol Konfirmasi dapat mengirimnya
      _lastFailedHistoryItem = historyItem; // gunakan variabel ini untuk menyimpan hasil (baik sukses atau gagal)
    });


  } catch (e) {
    // --- TANGANI KESALAHAN JARINGAN / API KRITIS ---
    String errorMessage = e.toString();
    if (errorMessage.contains("No hand detected")) {
        errorMessage = "Tangan tidak terdeteksi. Posisikan tangan lebih jelas di frame.";
    } else {
        errorMessage = "Gagal memproses foto atau API tidak merespons."; 
    }
    
    debugPrint('$errorMessage');
    
    // --- BUAT HISTORY ITEM GAGAL KRITIS ---
    final historyItem = DetectionHistory(
      id: uuid.v4(),
      detectedLetter: 'Error',
      timestamp: DateTime.now(),
      isSuccess: false,
      imageBytes: imageBytes, 
    );
    
    // --- UPDATE STATE UI UNTUK GAGAL KRITIS ---
    setState(() {
      _currentState = CameraState.detectionFailed;
      _detectedResult = errorMessage;
      // Simpan item riwayat gagal kritis ke state untuk tombol 'Konfirmasi'
      _lastFailedHistoryItem = historyItem; 
    });
  }
}

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    if (_controller!.value.isTakingPicture) return;

    try {
      await _initializeControllerFuture;
      final XFile file = await _controller!.takePicture();
      
      await _processImageAndDetect(file);

    } catch (e) {
      debugPrint('Error mengambil foto: $e');
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Gagal mengambil foto: $e')));
      }
    }
  }

  void _retakePhoto() async {
  setState(() {
    _capturedImage = null;
    _boxedImageBase64 = null;
    _currentState = CameraState.cameraActive;
    _detectedResult = '';
  });
  await _refreshCamera(); 
}

  Future<void> _toggleFlash() async {

    if (_controller == null || !_controller!.value.isInitialized) return;

    final newMode = _controller!.value.flashMode == FlashMode.off
        ? FlashMode.torch
        : FlashMode.off;
    await _controller!.setFlashMode(newMode);

    setState(() {
      _flashIcon = newMode == FlashMode.off ? Icons.flash_off : Icons.flash_on;
    });
  }

  Future<void> _toggleCamera() async {

    if (_controller == null || !_controller!.value.isInitialized) return;

    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    final current = _controller!.description;
    final newCamera = cameras.firstWhere(
      (cam) => cam.name != current.name,
      orElse: () => cameras.first,
    );

    await _controller!.dispose();
    _controller = CameraController(newCamera, ResolutionPreset.high, enableAudio: false);
    _initializeControllerFuture = _controller!.initialize();
    await _initializeControllerFuture;

    if (mounted) setState(() {});
  }

  @override
  void dispose() {
  _controller?.dispose();
  _controller = null;
  _initializeControllerFuture = null;
  super.dispose();
}


Widget _buildCameraFrame(ThemeData theme) {
  if (_controller == null || _initializeControllerFuture == null) {
    return _cameraLoadingContainer(theme, 'Memuat kamera...');
  }

  return FutureBuilder<void>(
    future: _initializeControllerFuture,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.done) {
        if (_controller == null || !_controller!.value.isInitialized) {
          return _cameraLoadingContainer(theme, 'Preview belum siap');
        }
        final size = _controller!.value.previewSize;
        if (size == null) {
          return const Center(child: Text("Error: Preview size not available"));
        }
        final aspectRatio = size.height / size.width;

        return Container(
          width: 250,
          height: 350,
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.onSurface.withOpacity(0.5), width: 2),
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: AspectRatio(
              aspectRatio: aspectRatio,
              child: CameraPreview(_controller!),
            ),
          ),
        );
      } else if (snapshot.hasError) {
        return _cameraErrorContainer(theme, snapshot.error.toString());
      } else {
        return _cameraLoadingContainer(theme, 'Memuat kamera...');
      }
    },
  );
}

Widget _cameraLoadingContainer(ThemeData theme, String text) {
  return Container(
    width: 250,
    height: 350,
    color: Colors.grey.shade900,
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(color: Colors.white),
          const SizedBox(height: 12),
          Text(text, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    ),
  );
}

Widget _cameraErrorContainer(ThemeData theme, String? errorText) {
  return Container(
    width: 250,
    height: 350,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.red.shade900,
    ),
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Camera error', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
          const SizedBox(height: 8),
          Text(errorText ?? 'Unknown', style: const TextStyle(color: Colors.white70), textAlign: TextAlign.center),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: _refreshCamera,
            child: const Text('Muat Ulang Kamera'),
          ),
        ],
      ),
    ),
  );
}


Widget _buildCapturedImageDisplay(ThemeData theme) {
  Widget imageContent;

  if (_boxedImageBase64 != null && _boxedImageBase64!.isNotEmpty) {
    try {
      final base64String = _boxedImageBase64!.split(',').last;
      final imageBytes = base64Decode(base64String); 

      imageContent = Image.memory(
        imageBytes,
        fit: BoxFit.cover,
      );
    } catch (e) {
      imageContent = const Center(child: Text("Gagal memuat gambar API"));
    }
  } else if (_capturedImage != null) {
    imageContent = kIsWeb
        ? Image.network(_capturedImage!.path, fit: BoxFit.cover)
        : Image.file(File(_capturedImage!.path), fit: BoxFit.cover);
  } else {
    return const SizedBox.shrink();
  }

  return Container(
    width: 250,
    height: 350,
    decoration: BoxDecoration(
      border: Border.all(
        color: _currentState == CameraState.detectionSuccess
            ? theme.colorScheme.primary
            : theme.colorScheme.error,
        width: 2,
      ),
      borderRadius: BorderRadius.circular(10),
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: imageContent, 
    ),
  );
}

  Widget _buildActionButton(String title, Color bgColor, VoidCallback onPressed) {
    final theme = Theme.of(context);
    
    Color buttonFg;
    if (bgColor == theme.colorScheme.primary) {
        buttonFg = theme.colorScheme.onPrimary; 
    } else {
        buttonFg = theme.colorScheme.onSurface; 
    }

    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          foregroundColor: buttonFg,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        child: Text(title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: buttonFg)),
      ),
    );
  }

  Widget _buildBottomActionBar(ThemeData theme, Color primary) {
    String middleText = '';
    List<Widget> actions = [];
    Color statusColor = primary;
    final isReady = _controller != null && _controller!.value.isInitialized;

    if (_currentState == CameraState.cameraActive) {
      middleText = 'Posisikan Tangan di dalam frame';
      statusColor = primary;
      actions = [
        IconButton(
          onPressed: isReady ? _toggleFlash : null, 
          icon: Icon(_flashIcon, size: 30, color: isReady ? theme.colorScheme.onSurface : Colors.grey),
        ),
        const SizedBox(width: 30),
        FloatingActionButton(
          onPressed: isReady ? _takePicture : null,
          backgroundColor: Colors.white,
          child: const Icon(Icons.camera_alt, size: 40, color: Colors.black),
        ),
        const SizedBox(width: 30),
        IconButton(
          onPressed: isReady ? _toggleCamera : null, 
          icon: Icon(Icons.flip_camera_ios, size: 30, color: isReady ? theme.colorScheme.onSurface : Colors.grey),
        ),
      ];
    } else if (_currentState == CameraState.detectionSuccess) {
    middleText = _detectedResult;
    statusColor = primary;
    actions = [
      _buildActionButton(
        'Foto Ulang', 
        theme.colorScheme.surface, 
        _retakePhoto
      ),
      const SizedBox(width: 10),
      // Tombol Konfirmasi harus mengirim data riwayat yang sudah disimpan
      _buildActionButton('Konfirmasi', primary, () {
        if (_lastFailedHistoryItem != null) {
          Navigator.pop(context, _lastFailedHistoryItem); // Mengirim data riwayat sukses
        } else {
          Navigator.pop(context);
        }
      }),
    ];
    } else if (_currentState == CameraState.detectionFailed) {
      middleText = _detectedResult; 
      statusColor = theme.colorScheme.error; 
      actions = [
        _buildActionButton(
          'Foto Ulang', 
          primary, 
          _retakePhoto
        ),
        const SizedBox(width: 10),
        _buildActionButton(
          'Konfirmasi',
          primary,
          () {
          if (_lastFailedHistoryItem != null) {
            Navigator.pop(context, _lastFailedHistoryItem); // Mengirim data riwayat gagal
          } else {
            Navigator.pop(context);
          }
        },
      ),
    ];
  }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(color: statusColor, borderRadius: BorderRadius.circular(30)),
          child: Text(
            middleText,
            style: theme.textTheme.headlineSmall?.copyWith(color: theme.colorScheme.onPrimary),
          ),
        ),
        const SizedBox(height: 50),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: actions),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Ambil Foto'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentState == CameraState.cameraActive
        ? IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        : const SizedBox.shrink(),
        actions: [],   
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_currentState == CameraState.cameraActive)
                _buildCameraFrame(theme)
              else
                _buildCapturedImageDisplay(theme),
              const Spacer(),
              _buildBottomActionBar(theme, primary),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
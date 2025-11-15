import 'package:flutter/material.dart';
import 'dart:async';
import 'onboarding_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> 
    with SingleTickerProviderStateMixin { 

  late AnimationController _controller;
  
  // Durasi splash screen
  static const Duration _totalDuration = Duration(milliseconds: 3000); // 3.0 detik
  static const double _dotSize = 12.0;

  @override
  void initState() {
    super.initState();
    // 1. Inisialisasi AnimationController untuk dot loader
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(); // Ulangi animasi terus-menerus
    
    // 2. Pindah layar setelah total durasi
    _startTransition();
  }
  
  void _startTransition() {
    Future.delayed(_totalDuration, () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const OnboardingScreen(),
          ),
        );
      }
    });
  }

  // --- Fungsi bangun Dot ---
  Widget _buildDot(int index, Color color) {
    // 2. Tentukan delay dan interval untuk setiap titik
    // Delay dimulai dari 0.0, 0.2, 0.4
    final intervalStart = (index * 0.2); 
    // Siklus animasi selesai setelah 0.6 dari total waktu (total siklus 1.0)
    final intervalEnd = intervalStart + 0.6; 

    final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(
          intervalStart,
          intervalEnd,
          curve: Curves.easeInOut,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final value = animation.value; 
        
        double opacity = value > 0.5 ? 1.0 - (value - 0.5) * 2 : value * 2;
        opacity = opacity.clamp(0.0, 1.0); // Pastikan antara 0 dan 1

        return Opacity(
          opacity: opacity,
          child: Container(
            width: _dotSize,
            height: _dotSize,
            margin: const EdgeInsets.symmetric(horizontal: 4.0),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double logoSize = 150.0;
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_mobile.png', 
              height: logoSize,
              width: logoSize,
              fit: BoxFit.contain,
            ),
            
            const SizedBox(height: 30),
           
            // --- Dot Loader ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _buildDot(0, primaryColor), // Titik 1
                _buildDot(1, primaryColor), // Titik 2
                _buildDot(2, primaryColor), // Titik 3
              ],
            ),
            // --- End Dot Loader ---
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
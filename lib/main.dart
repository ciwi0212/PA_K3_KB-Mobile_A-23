import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/splash_screen.dart';

final GlobalKey<MobileSignAppState> themeKey = GlobalKey<MobileSignAppState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  runApp(MobileSignApp(key: themeKey));
}

extension HexColor on Color {
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}

class MobileSignApp extends StatefulWidget {
  const MobileSignApp({super.key});

  @override
  State<MobileSignApp> createState() => MobileSignAppState();
}

class MobileSignAppState extends State<MobileSignApp> {
  bool _isDarkMode = false;

  void toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  static final Color primaryColor = HexColor.fromHex('#7752FE');
  static final Color secondaryColor = HexColor.fromHex('#190482');
  static final Color lightColor = HexColor.fromHex('#C2D9FF');

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IsyaratKu',
      debugShowCheckedModeBanner: false,
      
      // TEMA TERANG
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryColor, 
          primary: primaryColor,
          secondary: secondaryColor,
          brightness: Brightness.light
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        )
      ),

      // TEMA GELAP
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: lightColor,
          secondary: lightColor,
          surface: const Color(0xFF242424),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),

      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      
      home: const SplashScreen(),
    );
  }
}
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/detection_history.dart';

class StorageService {
  static const String _historyKey = 'detectionHistoryList';

  // Fungsi untuk mendapatkan semua riwayat yang tersimpan
  static Future<List<DetectionHistory>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_historyKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    try {
      // Decode string menjadi List<dynamic>
      final List<dynamic> jsonList = jsonDecode(jsonString);

      // Map setiap item List<dynamic> ke objek DetectionHistory
      return jsonList
          .map((jsonItem) => DetectionHistory.fromJson(jsonItem))
          .toList();
    } catch (e) {
      // Tangani kesalahan parsing (misalnya, jika format JSON rusak)
      print('Error loading history: $e');
      return [];
    }
  }

  // Fungsi untuk menyimpan seluruh daftar riwayat
  static Future<void> saveHistory(List<DetectionHistory> historyList) async {
    final prefs = await SharedPreferences.getInstance();

    // Map setiap objek DetectionHistory ke Map (JSON)
    final jsonList = historyList.map((item) => item.toJson()).toList();

    // Encode List<Map> menjadi JSON string
    final jsonString = jsonEncode(jsonList);

    await prefs.setString(_historyKey, jsonString);
  }
}
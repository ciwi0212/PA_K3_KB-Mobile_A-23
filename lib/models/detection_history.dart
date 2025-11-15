import 'package:flutter/foundation.dart'; 
import 'dart:convert';

class DetectionHistory {
  final String id;
  final String detectedLetter; 
  final DateTime timestamp;
  final bool isSuccess;
  final Uint8List? imageBytes; 

  DetectionHistory({
    required this.id,
    required this.detectedLetter,
    required this.timestamp,
    required this.isSuccess,
    this.imageBytes, 
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'detectedLetter': detectedLetter,
        'timestamp': timestamp.toIso8601String(),
        'isSuccess': isSuccess,
        'imageBytesBase64': imageBytes != null ? base64Encode(imageBytes!) : null,
      };

  factory DetectionHistory.fromJson(Map<String, dynamic> json) {
    return DetectionHistory(
      id: json['id'] as String,
      detectedLetter: json['detectedLetter'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isSuccess: json['isSuccess'] as bool,

      imageBytes: json['imageBytesBase64'] != null
          ? base64Decode(json['imageBytesBase64'] as String)
          : null,
    );
  }
}
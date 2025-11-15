import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';

class ApiService {
  static const String _baseDomain = "https://loathsomely-arsenious-adelyn.ngrok-free.dev";

  static Future<Map<String, dynamic>> detectLetter(Uint8List imageBytes, String mimeType) async {
    try {
      final base64Image = base64Encode(imageBytes);
      final url = Uri.parse('$_baseDomain/predict');

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "ngrok-skip-browser-warning": "69420",
        },
        body: jsonEncode({
          "image": "data:$mimeType;base64,$base64Image",
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception("Error API: $e");
    }
  }
  static Future<Map<String, dynamic>> uploadImage(File imageFile) async {
    final url = Uri.parse('$_baseDomain/upload_image_and_detect');
    final request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      "ngrok-skip-browser-warning": "69420",
    });

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 400 && response.body.contains("No hand detected")) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'No hand detected');
      } else {
        throw Exception('Gagal memuat gambar: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan Koneksi atau API: $e');
    }
  }
  static Future<Map<String, dynamic>> uploadImageFromBytes(
    Uint8List imageBytes, {
    String filename = 'image.jpg',
  }) async {
    final url = Uri.parse('$_baseDomain/upload_image_and_detect');
    final request = http.MultipartRequest('POST', url);

    request.headers.addAll({
      "ngrok-skip-browser-warning": "69420",
    });

    request.files.add(
      http.MultipartFile.fromBytes(
        'image',
        imageBytes,
        filename: filename,
        contentType: MediaType('image', 'jpeg'),
      ),
    );

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else if (response.statusCode == 400 && response.body.contains("No hand detected")) {
        final errorData = jsonDecode(response.body);
        throw Exception(errorData['error'] ?? 'No hand detected');
      } else {
        throw Exception('Gagal memuat gambar: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan Koneksi atau API: $e');
    }
  }
}
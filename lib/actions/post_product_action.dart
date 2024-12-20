import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BackendService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<Map<String, dynamic>?> postProduct({
    required String productName,
    required Uint8List productImageBytes,
    required String location,
    required String phoneNumber,
    required double price,
    required String description,
    String token = '',
  }) async {
    try {
      final base64Image = base64Encode(productImageBytes);

      String accessToken = token;
      if (accessToken.isEmpty) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        accessToken = prefs.getString('access_token') ?? '';
      }
      if (accessToken.isEmpty) {
        throw Exception('Access token not found');
      }

      final response = await http.post(
        Uri.parse('$baseUrl/post_product/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(<String, dynamic>{
          'product_name': productName,
          'product_image': 'data:image/png;base64,$base64Image',
          'location': location,
          'phone_number': phoneNumber,
          'price': price,
          'description': description,
        }),
      );
     
      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to post product: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to post product: $e');
    }
  }
}

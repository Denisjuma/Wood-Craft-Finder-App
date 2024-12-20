import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendService {
  static const String baseUrl = 'http://127.0.0.1:8000/api';

  static Future<Map<String, dynamic>> registerUser({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
  }) async {
    print(firstName);
    print(lastName);
    print(email);
    try {

       print('Sending login request to: $baseUrl/signup/');
    print('Request body: ${jsonEncode({
          'firstName': firstName,
          'lastName': lastName,
        })}');

      final response = await http.post(
        Uri.parse('$baseUrl/signup/'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'first_name': firstName,
          'last_name': lastName,
          'email': email,
          'username': username,
          'password': password,
        }),
      );

      // Debugging: print the response body and status code
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final Map<String, dynamic> data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        // Registration successful
        return {'success': true, ...data};
      } else {
        // Registration failed
         print('Response status: ${response.body}');
        return {'success': false, 'message': data['message']};
        
      }
    } catch (e) {
      // Error occurred during registration
      throw 'Failed to register: $e';
    }
  }
}

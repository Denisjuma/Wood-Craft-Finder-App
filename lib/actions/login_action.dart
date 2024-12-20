import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> login(String username, String password) async {
  print('trying user to login credentials are :');
  print(username);
  print(password);
  const url = 'http://127.0.0.1:8000/api/token/';

  try {
    print('Sending login request to: $url');
    print('Request body: ${jsonEncode({
          'username': username,
          'password': '********'
        })}');

    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode({
        'username': username,
        'password': password,
      }),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    print(response.headers);
    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      final accessToken = responseData['access'];
      final refreshToken = responseData['refresh'];

      if (accessToken != null && refreshToken != null) {
        // Save tokens to local storage
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', accessToken);
        await prefs.setString('refresh_token', refreshToken);

        print('Login successful');
        return true; // Login successful
      } else {
        print('Tokens not found in response');
        throw Exception('Tokens not found in response');
      }
    } else if (response.statusCode == 401) {
      final responseData = jsonDecode(response.body);
      print('Unauthorized: ${responseData['detail']}');
      throw Exception('Unauthorized: ${responseData['detail']}');
    } else {
      print('Failed to login: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to login');
    }
  } catch (error) {
    print('Error: $error');
    rethrow; // Rethrow the error to handle it in UI
  }
}

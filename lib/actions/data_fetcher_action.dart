import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class DataFetcher {
  Future<List<dynamic>> fetchData() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/getProducts/'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

 Future<Map<String, dynamic>> fetchUserProfile(String token) async {
  const url = 'http://127.0.0.1:8000/api/profile/';

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? accessToken = prefs.getString('access_token');

  if (accessToken == null) {
    throw Exception('Access token not found');
  }

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Authorization': 'Bearer $accessToken',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load profile data');
  }
}

}

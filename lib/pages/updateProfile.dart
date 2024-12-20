import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileUpdateForm extends StatefulWidget {
  final String token;

  const ProfileUpdateForm({Key? key, required this.token}) : super(key: key);

  @override
  _ProfileUpdateFormState createState() => _ProfileUpdateFormState();
}

class _ProfileUpdateFormState extends State<ProfileUpdateForm> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  late String _token;

  @override
  void initState() {
    super.initState();
    _initializeToken();
    _fetchUserProfile();
  }

  Future<void> _initializeToken() async {
    _token = widget.token;
    if (_token.isEmpty) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('access_token') ?? '';
      if (_token.isEmpty) {
        throw Exception('Access token not found');
      }
    }
  }

  Future<void> _fetchUserProfile() async {
    final url = Uri.parse('http://127.0.0.1:8000/api/current_user/');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> userData = json.decode(response.body);
      _firstNameController.text = userData['first_name'];
      _emailController.text = userData['email'];
    } else {
      print('Failed to load user profile: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to fetch user information');
    }
  }

  Future<void> _updateProfile() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://127.0.0.1:8000/api/update_profile/');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({
        'first_name': _firstNameController.text,
        'email': _emailController.text,
        // Add more fields as needed for updating profile
      }),
    );

    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update profile')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                labelText: 'First Name',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _updateProfile,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

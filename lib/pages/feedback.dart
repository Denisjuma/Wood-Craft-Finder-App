import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FeedbackForm extends StatefulWidget {
  final String token;

  const FeedbackForm({Key? key, required this.token}) : super(key: key);

  @override
  _FeedbackFormState createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final TextEditingController _messageController = TextEditingController();
  bool _isLoading = false;
  late String _token;

  @override
  void initState() {
    super.initState();
    _initializeToken();
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

  Future<void> _submitFeedback() async {
    setState(() {
      _isLoading = true;
    });

    // Fetch user ID or any necessary user information from your backend
    int userId;
    try {
      userId = int.parse(await fetchUserId());
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch user information')),
      );
      return;
    }

    final url = Uri.parse('http://127.0.0.1:8000/api/feedback/');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode({
        'user': userId,
        'message': _messageController.text,
      }),
    );
    print(response.body);
    setState(() {
      _isLoading = false;
    });

    if (response.statusCode == 201) {
      // Feedback submitted successfully
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback submitted successfully')),
      );
      _messageController.clear();
    } else {
      // Failed to submit feedback
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit feedback')),
      );
    }
  }

  Future<String> fetchUserId() async {
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
      return userData['id'].toString();
    } else {
      print('Failed to load user profile: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to fetch user information');
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your Feedback',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _messageController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Enter your feedback here',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitFeedback,
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Submit Feedback'),
            ),
          ],
        ),
      ),
    );
  }
}




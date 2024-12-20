import 'package:flutter/material.dart';
import '../actions/register_action.dart'; // Import the logic class
import 'login.dart'; // Import the login form

class Register extends StatefulWidget {
  final bool isSeller;

  const Register({Key? key, required this.isSeller}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _firstName = '';
  String _lastName = '';
  bool _isLoading = false;
  String _errorMessage = '';

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = ''; // Clear any previous error message
      });

      try {
        // Call the backend API to register user
        final result = await BackendService.registerUser(
          firstName: _firstName,
          lastName: _lastName,
          email: _email,
          username: _email,
          password: _password,
        );

        if (result['success'] == true) {
          // Registration successful, navigate to login form
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginForm()),
          );
        } else if (result['message'] != null) {
          // Registration failed, display error message
          setState(() {
            _errorMessage = result['message'];
          });
        } else {
          // Unexpected result format
          setState(() {
            _errorMessage = 'An unexpected error occurred';
          });
        }
      } catch (e) {
        // Error occurred during registration
        setState(() {
          _errorMessage = 'Failed to register: $e';
        });
      } finally {
        // Reset loading state
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Register Form',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                    ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      return null;
                    },
                    onChanged: (value) => _firstName = value,
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      return null;
                    },
                    onChanged: (value) => _lastName = value,
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                    onChanged: (value) => _email = value,
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                    onChanged: (value) => _password = value,
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : const Text('Create Account'),
                  ),
                  const SizedBox(height: 12.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

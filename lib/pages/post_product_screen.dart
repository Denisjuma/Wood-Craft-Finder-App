import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wood_craft_finder/actions/post_product_action.dart';

class PostProductForm extends StatefulWidget {
  final String token;

  const PostProductForm({Key? key, required this.token}) : super(key: key);

  @override
  State<PostProductForm> createState() => _PostProductFormState();
}

class _PostProductFormState extends State<PostProductForm> {
  final _formKey = GlobalKey<FormState>();
  String _productName = '';
  Uint8List? _productImageBytes;
  String _location = '';
  String _phoneNumber = '';
  double _price = 0.0;
  String _description = '';
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? pickedFile =
          await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _productImageBytes = bytes;
          _errorMessage = ''; // Clear any previous error message
        });
      } else {
        setState(() {
          _errorMessage = 'No image selected';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error picking image: $e';
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate() && _productImageBytes != null) {
      setState(() {
        _isLoading = true;
        _errorMessage = ''; // Clear any previous error message
      });

      try {
        final result = await BackendService.postProduct(
          token: widget.token,
          productName: _productName,
          productImageBytes: _productImageBytes!,
          location: _location,
          phoneNumber: _phoneNumber,
          price: _price,
          description: _description,
        );

        if (result != null && result['success'] != null && result['success']) {
          setState(() {
            _errorMessage = 'Product posted successfully';
            _productName = '';
            _productImageBytes = null;
            _location = '';
            _phoneNumber = '';
            _price = 0.0;
            _description = '';
          });
        } else if (result != null && result['message'] != null) {
          setState(() {
            _errorMessage = result['message'];
          });
        } else {
          setState(() {
            _errorMessage = 'An unexpected error occurred';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Failed to post product: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _errorMessage = 'Please fill in all fields and select an image';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        title: const Text('Post Product'),
      ),
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
                    'Post a New Product',
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
                    decoration:
                        const InputDecoration(labelText: 'Product Name'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the product name';
                      }
                      return null;
                    },
                    onChanged: (value) => _productName = value,
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Location'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the location';
                      }
                      return null;
                    },
                    onChanged: (value) => _location = value,
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the phone number';
                      }
                      return null;
                    },
                    onChanged: (value) => _phoneNumber = value,
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Price'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the price';
                      }
                      return null;
                    },
                    onChanged: (value) =>
                        _price = double.tryParse(value) ?? 0.0,
                  ),
                  const SizedBox(height: 12.0),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the description';
                      }
                      return null;
                    },
                    onChanged: (value) => _description = value,
                  ),
                  const SizedBox(height: 12.0),
                  TextButton(
                    onPressed: _pickImage,
                    child: const Text('Select Product Image'),
                  ),
                  if (_productImageBytes != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Image.memory(
                        _productImageBytes!,
                        height: 200,
                        errorBuilder: (context, error, stackTrace) {
                          return const Text('Error loading image');
                        },
                      ),
                    ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : const Text('Post Product'),
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

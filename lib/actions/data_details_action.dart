import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  final dynamic product;

  const ProductDetailScreen({Key? key, required this.product})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            product['product_image'] != null
                ? Image.network(
                    'http://127.0.0.1:8000/images/${product['product_image']}',
                    height: 300,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Placeholder(
                        fallbackHeight: 300,
                      );
                    },
                  )
                : const Placeholder(
                    fallbackHeight: 300,
                  ),
            const SizedBox(height: 20),
            Text(
              'Price: ${product['price']}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Description: ${product['description']}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  color: Colors.blue,
                ),
                const SizedBox(width: 8),
                Text(
                  '${product['location']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 28),
                   const Icon(
                  Icons.phone,
                  color: Colors.green,
                  size: 24, // Adjust size as needed
                ),
                const SizedBox(width: 8), // Adjust spacing as needed
                Text(
                  '${product['phone_number']}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

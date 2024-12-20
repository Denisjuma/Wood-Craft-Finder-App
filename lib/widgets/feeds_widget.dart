import 'package:flutter/material.dart';
import '../actions/data_details_action.dart';

class FeedsWidget extends StatefulWidget {
  final List<dynamic> data;

  const FeedsWidget({Key? key, required this.data}) : super(key: key);

  @override
  _FeedsWidgetState createState() => _FeedsWidgetState();
}

class _FeedsWidgetState extends State<FeedsWidget> {
  late List<dynamic> _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  @override
  void didUpdateWidget(covariant FeedsWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data != widget.data) {
      setState(() {
        _data = widget.data;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'NEW PRODUCTS',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        _data.isNotEmpty
            ? Column(
                children: _data.map<Widget>((product) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductDetailScreen(product: product),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.all(16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Constructing image URL assuming base URL is http://example.com/images/
                            product['product_image'] != null
                                ? Image.network(
                                    'http://127.0.0.1:8000/images/${product['product_image']}',
                                    height: 150,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Placeholder(); // Display a placeholder for failed images
                                    },
                                  )
                                : const Placeholder(
                                    fallbackHeight: 150,
                                    fallbackWidth: double.infinity,
                                  ),
                            const SizedBox(height: 10),
                            Text(
                              'Price: ${product['price']}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              product['product_name'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              product['description'].length > 10
                                  ? '${product['description'].substring(0, 10)}...'
                                  : product['description'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            Text(
                              'Location: ${product['location']}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )
            : const CircularProgressIndicator(),
        // Display loading indicator while fetching data
      ],
    );
  }
}

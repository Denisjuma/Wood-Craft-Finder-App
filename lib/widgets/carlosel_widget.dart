import 'package:flutter/material.dart';

class SalesWidget extends StatelessWidget {
  const SalesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Define the RGB values for the colors
    final Color color1 = Color.fromRGBO(28, 108, 197, 1.0);
    final Color color2 = Color.fromRGBO(130, 99, 223, 1);
    final Color color3 = Color.fromRGBO(255, 255, 255, 0.3);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        gradient: LinearGradient(
          colors: [color1, color2],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: Padding(
              padding: EdgeInsets.all(14.0),
              child: Container(
                decoration: BoxDecoration(
                  color: color3,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const  Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Get the special discount",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        '50 %\nOFF',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 3,
            child: Padding(
              padding: EdgeInsets.all(14.0),
              child: Image.asset(
                'assets/images/funiture.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

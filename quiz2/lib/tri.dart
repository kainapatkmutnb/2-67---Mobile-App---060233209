import 'package:flutter/material.dart';

class Tri extends StatelessWidget {
  final double base;
  final double height;

  Tri({required this.base, required this.height});

  @override
  Widget build(BuildContext context) {
    double area = 0.5 * base * height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Triangle Area"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Height: $height'),
            Text('Width: $base'),
            SizedBox(height: 20),
            Text('Area: $area'),
          ],
        ),
      ),
    );
  }
}

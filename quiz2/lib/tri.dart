import 'package:flutter/material.dart';

class Tri extends StatelessWidget {
  final double base;
  final double height;

  const Tri({super.key, required this.base, required this.height});

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
            Text(
              'Height: $base',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Base: $height',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text(
              'Area: $area',
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
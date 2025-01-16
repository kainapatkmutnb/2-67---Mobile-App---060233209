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
        child: Text(
          'Area: $area',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

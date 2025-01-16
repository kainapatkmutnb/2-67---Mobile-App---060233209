import 'package:flutter/material.dart';

class Cir extends StatefulWidget {
  final double radius;

  Cir({required this.radius});

  @override
  _CirState createState() => _CirState();
}

class _CirState extends State<Cir> {
  late double area;

  @override
  void initState() {
    super.initState();
    calculateArea();
  }

  void calculateArea() {
    area = 3.14159 * widget.radius * widget.radius;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Circle Area"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Radius: ${widget.radius}',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 10),
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

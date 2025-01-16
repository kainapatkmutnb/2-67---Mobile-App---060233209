import 'package:flutter/material.dart';

class Cir extends StatefulWidget {
  final double radius;

  Cir({required this.radius});

  @override
  _CirState createState() => _CirState();
}

class _CirState extends State<Cir> {
  String result = "";

  @override
  void initState() {
    super.initState();
    calculateArea();
  }

  void calculateArea() {
    double area = 3.14159 * widget.radius * widget.radius;
    setState(() {
      result = "Area: $area";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Circle Area"),
      ),
      body: Center(
        child: Text(
          result,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}

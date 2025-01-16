import 'package:flutter/material.dart';

class TriangleAreaPage extends StatefulWidget {
  final double base;
  final double height;

  TriangleAreaPage({required this.base, required this.height});

  @override
  _TriangleAreaPageState createState() => _TriangleAreaPageState();
}

class _TriangleAreaPageState extends State<TriangleAreaPage> {
  String result = "";

  @override
  void initState() {
    super.initState();
    calculateArea();
  }

  void calculateArea() {
    double area = 0.5 * widget.base * widget.height;
    setState(() {
      result = "Area: $area";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Triangle Area"),
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

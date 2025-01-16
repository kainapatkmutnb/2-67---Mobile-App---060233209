import 'package:flutter/material.dart';

class Tri extends StatefulWidget {
  @override
  _TriState createState() => _TriState();
}

class _TriState extends State<Tri> {
  final TextEditingController baseController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String result = "";

  void calculateArea() {
    double base = double.tryParse(baseController.text) ?? 0;
    double height = double.tryParse(heightController.text) ?? 0;
    double area = 0.5 * base * height;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: baseController,
              decoration: InputDecoration(labelText: "Base"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            TextField(
              controller: heightController,
              decoration: InputDecoration(labelText: "Height"),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: calculateArea,
              child: Text("Calculate"),
            ),
            SizedBox(height: 16),
            Text(
              result,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
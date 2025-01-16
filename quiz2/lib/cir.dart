import 'package:flutter/material.dart';

class CircleAreaPage extends StatefulWidget {
  @override
  _CircleAreaPageState createState() => _CircleAreaPageState();
}

class _CircleAreaPageState extends State<CircleAreaPage> {
  final TextEditingController radiusController = TextEditingController();
  String result = "";

  void calculateArea() {
    double radius = double.tryParse(radiusController.text) ?? 0;
    double area = 3.14159 * radius * radius;

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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: radiusController,
              decoration: InputDecoration(labelText: "Radius"),
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
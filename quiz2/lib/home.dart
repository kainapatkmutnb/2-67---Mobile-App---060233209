import 'package:flutter/material.dart';
import 'rec.dart';
import 'tri.dart';
import 'cir.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selectedShape = 'Rectangle';
  final TextEditingController widthController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController radiusController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geometric Area Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            RadioListTile<String>(
              title: Text('Rectangle'),
              value: 'Rectangle',
              groupValue: selectedShape,
              onChanged: (value) {
                setState(() {
                  selectedShape = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text('Triangle'),
              value: 'Triangle',
              groupValue: selectedShape,
              onChanged: (value) {
                setState(() {
                  selectedShape = value!;
                });
              },
            ),
            RadioListTile<String>(
              title: Text('Circle'),
              value: 'Circle',
              groupValue: selectedShape,
              onChanged: (value) {
                setState(() {
                  selectedShape = value!;
                });
              },
            ),
            if (selectedShape == 'Rectangle') ...[
              TextField(
                controller: widthController,
                decoration: InputDecoration(labelText: 'Width (w)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: heightController,
                decoration: InputDecoration(labelText: 'Height (h)'),
                keyboardType: TextInputType.number,
              ),
            ],
            if (selectedShape == 'Triangle') ...[
              TextField(
                controller: widthController,
                decoration: InputDecoration(labelText: 'Width (w)'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 16),
              TextField(
                controller: heightController,
                decoration: InputDecoration(labelText: 'Base (b)'),
                keyboardType: TextInputType.number,
              ),
            ],
            if (selectedShape == 'Circle') ...[
              TextField(
                controller: radiusController,
                decoration: InputDecoration(labelText: 'Radius (r)'),
                keyboardType: TextInputType.number,
              ),
            ],
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedShape == 'Rectangle') {
                  double width = double.tryParse(widthController.text) ?? 0;
                  double height = double.tryParse(heightController.text) ?? 0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Rec(width: width, height: height),
                    ),
                  );
                } else if (selectedShape == 'Triangle') {
                  double base = double.tryParse(widthController.text) ?? 0;
                  double height = double.tryParse(heightController.text) ?? 0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Tri(base: base, height: height),
                    ),
                  );
                } else if (selectedShape == 'Circle') {
                  double radius = double.tryParse(radiusController.text) ?? 0;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Cir(radius: radius),
                    ),
                  );
                }
              },
              child: Text('Calculate Area'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class Rec extends StatelessWidget {
  final double height;
  final double width;

  const Rec({super.key, required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    double area = height * width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Rectangle Area'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Height: $width',
            style: TextStyle(fontSize: 20),
            ),
            Text('Width: $height',
            style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            Text('Area: $area',
            style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}
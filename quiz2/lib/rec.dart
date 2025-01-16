import 'package:flutter/material.dart';

class Rec extends StatelessWidget {
  final double height;
  final double width;

  Rec({required this.height, required this.width});

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
            Text('Height: $height'),
            Text('Width: $width'),
            SizedBox(height: 20),
            Text('Area: $area'),
          ],
        ),
      ),
    );
  }
}
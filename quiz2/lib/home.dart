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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geometric Area Calculator'),
      ),
      body: Column(
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
          ElevatedButton(
            onPressed: () {
              // นำทางไปยังหน้าคำนวณตามรูปทรงที่เลือก
              if (selectedShape == 'Rectangle') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RectangleAreaPage()),
                );
              } else if (selectedShape == 'Triangle') {
                // รับค่าพื้นฐานและความสูงจาก TextField หรือ Widget อื่นๆ
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TriangleAreaPage()),
                );
              } else if (selectedShape == 'Circle') {
                // รับค่ารัศมีจาก TextField หรือ Widget อื่นๆ
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CircleAreaPage(),
                  ),
                );
              }
            },
            child: Text('Calculate Area'),
          ),
        ],
      ),
    );
  }
}
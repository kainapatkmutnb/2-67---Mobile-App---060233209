import 'package:flutter/material.dart';
import 'rec.dart';
import 'tri.dart';
import 'cir.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedShape = 'Rectangle'; // Default shape

  // Controllers for text fields
  final heightController = TextEditingController();
  final widthController = TextEditingController();
  final baseController = TextEditingController();
  final radiusController = TextEditingController();

  // Form key for validation
  final _formkey = GlobalKey<FormState>();

  // Function to validate if the input is a valid number
  String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (double.tryParse(value) == null) {
      return 'Please enter a valid number';
    }
    return null; // No error
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geometric Area Calculator'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formkey, // Assign the form key
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Radio buttons to select shape
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
              if (selectedShape == 'Rectangle') ...[
                TextFormField(
                  decoration: InputDecoration(labelText: 'Height (h)'),
                  keyboardType: TextInputType.number,
                  controller: heightController,
                  validator: validateNumber,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Width (w)'),
                  keyboardType: TextInputType.number,
                  controller: widthController,
                  validator: validateNumber,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formkey.currentState?.validate() ?? false) {
                      // Navigate to rec.dart and pass height & width
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Rec(
                            height: double.parse(heightController.text),
                            width: double.parse(widthController.text),
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('Calculate Area'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
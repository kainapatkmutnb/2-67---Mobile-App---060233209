import 'package:flutter/material.dart';

class ClCreate extends StatefulWidget {
  const ClCreate({super.key});

  @override
  ClCreateState createState() => ClCreateState();
}

class ClCreateState extends State<ClCreate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Form'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                pictureIcon(),
                textheader('General Information'),
                textForm('Your Name', 'Please insert your name'),
                textForm('Sur Name', 'Please insert your name'),
                textheader('Education Information'),
                textForm('Your University', 'Please insert your University'),
                textForm('Faculty', 'Please insert your Faculty'),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(width: 150, height: 50,
                    child: ElevatedButton(onPressed: () {}, child: Text('Add Data')),)
                  ],
                )
              ],
            ),
          )),
      ),
    );
  }
}

TextFormField textForm(String ltext, String htext) {
  return TextFormField(
                  decoration: InputDecoration(
                    labelText: ltext,
                    hintText: htext,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
}

Text textheader(String header) {
  return Text(
                  header,
                  style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blueAccent),
                );
}

Padding pictureIcon() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Icon(
      Icons.insert_photo,
      size: 100,
    ),
  );
}
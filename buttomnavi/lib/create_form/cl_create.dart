import 'package:flutter/material.dart';

class ClCreate extends StatefulWidget {
  @override
  _ClCreateState createState() => _ClCreateState();
}

class _ClCreateState extends State<ClCreate> {
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
              children: <Widget>[
                pictureIcon(),
                Text(
                  'Your Name',
                  style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Colors.blueAccent),
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Insert',
                    hintText: 'Please insert your name',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                )
              ]),
          )),
      ),
    );
  }
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
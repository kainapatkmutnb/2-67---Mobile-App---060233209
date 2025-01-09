import 'package:flutter/material.dart';

class ClCreate extends StatefulWidget {
  const ClCreate({super.key});

  @override
  ClCreateState createState() => ClCreateState();
}

class ClCreateState extends State<ClCreate> {
  var yourName = TextEditingController();
  var surName = TextEditingController();
  var yourUniversity = TextEditingController();
  var yourFaculty = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Form'),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 20),
        child: Form(
          child: SingleChildScrollView(
            child: Column(
              children: [
                pictureIcon(),
                textheader('General Information'),
                textForm('Your Name', 'Please insert your name', yourName),
                textForm('Sur Name', 'Please insert your name', surName),
                textheader('Education Information'),
                textForm('Your University', 'Please insert your University', yourUniversity),
                textForm('Faculty', 'Please insert your Faculty', yourFaculty),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 150,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          print('Your Name: ' + yourName.text);
                          print('Sur Name: ' + surName.text);
                          print('Your University: ' + yourUniversity.text);
                          print('Your Faculty: ' + yourFaculty.text);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                        ),
                        child: const Text(
                          'Add Data',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 150,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                          ),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

TextFormField textForm(String ltext, String htext, TextEditingController controller) {
  return TextFormField(
    controller: controller,
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
      color: Colors.blueAccent,
    ),
  );
}

Padding pictureIcon() {
  return const Padding(
    padding: EdgeInsets.all(8.0),
    child: Icon(
      Icons.insert_photo,
      size: 100,
    ),
  );
}

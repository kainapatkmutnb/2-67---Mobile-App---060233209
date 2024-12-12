import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Optional, can be removed unless you plan to add parameters

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'KAINAPXT',
        home: MyHomepage());
  }
}

class MyHomepage extends StatefulWidget {
  const MyHomepage({super.key});

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  int number = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("HELLO G"),
        backgroundColor: Colors.lightBlue[100],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Press the button to get a number",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 226, 68, 68),
                letterSpacing: 2.0,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              number.toString(),
              style: TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 131, 207, 226),
                fontStyle: FontStyle.italic,
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            number++;
          });
        },
        child: Icon(Icons.add),
        backgroundColor: const Color.fromARGB(255, 113, 162, 202),
      ),
    );
  }
}

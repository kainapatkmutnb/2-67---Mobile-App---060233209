import 'package:flutter/material.dart';
import 'dart:ui';
import 'MoneyBox.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Test Container',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 77, 172, 226),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Test Container'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Account Balance',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 61, 139, 202),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              height: 120,
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                color: Colors.grey.shade50,
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
                ),
              ],
              ),
              child: InputDecoratorExample(),
            ),
            MoneyBox('Balance', 30000, 100, Colors.lightBlue),
            SizedBox(height: 5),
            MoneyBox('Income', 10000, 80, Colors.green),
            SizedBox(height: 5),
            MoneyBox('Expenses', 80000, 80, Colors.orange),
            SizedBox(height: 5),
            MoneyBox('Debt', 40000, 80, Colors.deepOrange),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: const Color.fromARGB(255, 114, 178, 207),
              ),
              onPressed: () {
                
              },
                child: const Text(
                "Summit",
                style: TextStyle(fontSize: 30),
                ),
            )
          ],
        ),
      ),
    );
  }
}

class InputDecoratorExample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: 'Enter your Account name',
      ),
      validator: (String? value) {
        if (value == null || value == '') {
          return 'Please enter Account name';
        }
        return null;
      },
      autovalidateMode: AutovalidateMode.always,
    );
  }
}
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
            MoneyBox('Balance', 30000, 120, Colors.lightBlue),
            SizedBox(height: 5),
            MoneyBox('Income', 10000, 100, Colors.green),
            SizedBox(height: 5),
            MoneyBox('Expenses', 80000, 100, Colors.orange),
            SizedBox(height: 5),
            MoneyBox('Debt', 40000, 100, Colors.deepOrange),
          ],
        ),
      ),
    );
  }
}
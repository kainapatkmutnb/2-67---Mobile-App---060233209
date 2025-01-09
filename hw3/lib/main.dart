import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ATMApp(),
    );
  }
}

class ATMApp extends StatefulWidget {
  const ATMApp({super.key});

  @override
  _ATMAppState createState() => _ATMAppState();
}

class _ATMAppState extends State<ATMApp> {
  int balance = 0;
  int money = 0;
  String state = 'Your money is';

  void depositMoney() {
    setState(() {
      balance += money;
      state = 'Deposit Complete';
      money = 0;
    });
  }

  void withdrawMoney() {
    if (balance >= money) {
      setState(() {
        balance -= money;
        state = 'Withdraw Complete';
        money = 0;
      });
    } else {
      setState(() {
        state = 'Your balance not enough!';
      });
    }
  }

  void selectMoney(int amount) {
    setState(() {
      money = amount;
      state = 'Your money is';
    });
  }

  Widget amountButton(int amount, Function(int) onPressed) {
    return ElevatedButton(
      onPressed: () => onPressed(amount),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        backgroundColor: const Color.fromARGB(255, 87, 161, 222),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      child: Text(
        amount.toString(),
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ATM-1999',
          style: TextStyle(color: Color.fromARGB(200, 0, 0, 0)),
        ),
        backgroundColor: const Color.fromARGB(255, 179, 157, 219),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Your Balance is',
              style: TextStyle(fontSize: 28),
            ),
            Text(
              '$balance',
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 32),
            Text(
              state,
              style: const TextStyle(fontSize: 28),
            ),
            Text(
              '$money',
              style: const TextStyle(fontSize: 28),
            ),
            const SizedBox(height: 32),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    amountButton(1000, selectMoney),
                    const SizedBox(width: 10),
                    amountButton(2000, selectMoney),
                    const SizedBox(width: 10),
                    amountButton(3000, selectMoney),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    amountButton(4000, selectMoney),
                    const SizedBox(width: 10),
                    amountButton(5000, selectMoney),
                    const SizedBox(width: 10),
                    amountButton(6000, selectMoney),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: depositMoney,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'deposit',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 0, 97, 4),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: withdrawMoney,
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  label: const Text(
                    'withdraw',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 17, 0),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

void main() {
  runApp(const ATMApp());
}

class ATMApp extends StatelessWidget {
  const ATMApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'ATM-1999',
      debugShowCheckedModeBanner: false,
      home: ATMHomePage(),
    );
  }
}

class ATMHomePage extends StatefulWidget {
  const ATMHomePage({super.key});

  @override
  _ATMHomePageState createState() => _ATMHomePageState();
}

class _ATMHomePageState extends State<ATMHomePage> {
  double balance = 0.0;
  double selectedAmount = 0.0;
  String message = '';

  void deposit(double amount) {
    setState(() {
      balance += amount;
      message = 'Deposit Complete';
    });
  }

  void withdraw(double amount) {
    setState(() {
      if (balance >= amount) {
        balance -= amount;
        message = 'Withdraw Complete';
      } else {
        message = 'Your balance is not enough!';
      }
    });
  }

  Widget amountButton(double amount) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          selectedAmount = amount;
          message = 'Your money is ${selectedAmount.toInt()}';
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      ),
      child: Text('${amount.toInt()}', style: const TextStyle(fontSize: 14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ATM-1999'),
        backgroundColor: const Color(0xFFB39DDB),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'Your Balance is',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              '${balance.toInt()}',
              style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              message.isNotEmpty ? message : 'Your money is ${selectedAmount.toInt()}',
              style: TextStyle(fontSize: 25, color: Colors.grey[700]),
            ),
            const SizedBox(height: 20),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 2.5,
              children: [
                amountButton(1000),
                amountButton(2000),
                amountButton(3000),
                amountButton(4000),
                amountButton(5000),
                amountButton(6000),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    if (selectedAmount > 0) {
                      deposit(selectedAmount);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Deposit', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    if (selectedAmount > 0) {
                      withdraw(selectedAmount);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                  label: const Text('Withdraw', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

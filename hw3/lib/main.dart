import 'package:flutter/material.dart';

void main() {
  runApp(ATMApp());
}

class ATMApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATM-1999',
      debugShowCheckedModeBanner: false,
      home: ATMHomePage(),
    );
  }
}

class ATMHomePage extends StatefulWidget {
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
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      ),
      child: Text('${amount.toInt()}', style: TextStyle(fontSize: 14)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ATM-1999'),
        backgroundColor: Color(0xFFB39DDB),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Your Balance is',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            Text(
              '${balance.toInt()}',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              message.isNotEmpty ? message : 'Your money is ${selectedAmount.toInt()}',
              style: TextStyle(fontSize: 25, color: Colors.grey[700]),
            ),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
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
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('Deposit', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    if (selectedAmount > 0) {
                      withdraw(selectedAmount);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  icon: Icon(Icons.delete, color: Colors.white),
                  label: Text('Withdraw', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

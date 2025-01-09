import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String amount;
  final String bank;
  final String currency;

  const ResultPage({
    super.key,
    required this.amount,
    required this.bank,
    required this.currency,
  });

  double convertCurrency(String currency, double amount) {
    switch (currency) {
      case 'USD':
        return amount / 34;
      case 'EUR':
        return amount / 35;
      case 'JPY':
        return amount / 0.21;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double bahtAmount = double.tryParse(amount) ?? 0;
    double convertedAmount = convertCurrency(currency, bahtAmount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Conversion Result',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16.0),
              Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amount in Thai Baht: $amount',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Selected Bank: $bank',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Selected Currency: $currency',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        'Converted Amount: ${convertedAmount.toStringAsFixed(2)} $currency',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: Colors.blueAccent,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Back'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  textStyle: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
      case 'USD': // US Dollar
        return amount / 34; // Conversion rate for USD
      case 'EUR': // Euro
        return amount / 35; // Conversion rate for EUR
      case 'JPY': // Japanese Yen
        return amount / 0.21; // Conversion rate for JPY
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    double bahtAmount = double.tryParse(amount) ?? 0; // Convert amount to double
    double convertedAmount = convertCurrency(currency, bahtAmount);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Result'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
              const SizedBox(height: 24.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Back'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
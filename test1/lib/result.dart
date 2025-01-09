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

  double convertCurrency(String bank, String currency, double amount) {
    final rates = {
      'Krungthai Bank (KTB)': {'USD': 34.83, 'EUR': 36, 'JPY': 0.2212},
      'Siam Commercial Bank (SCB)': {'USD': 34.2, 'EUR': 35.09, 'JPY': 0.2134},
      'TMBThanachart Bank (TTB)': {'USD': 34.87, 'EUR': 36.45, 'JPY': 0.2289},
    };

    if (rates.containsKey(bank) && rates[bank]!.containsKey(currency)) {
      double rate = rates[bank]![currency]!.toDouble();
      return amount / rate;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currencySigns = {
      'USD': '\$', 
      'EUR': '€', 
      'JPY': '¥', 
    };

    double bahtAmount = double.tryParse(amount) ?? 0;
    double convertedAmount = convertCurrency(bank, currency, bahtAmount);
    String currencySign = currencySigns[currency] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversion Result'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bank: $bank',
              style: const TextStyle(
                fontSize: 18.0,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Your Result:',
              style: const TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              '$currencySign${convertedAmount.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

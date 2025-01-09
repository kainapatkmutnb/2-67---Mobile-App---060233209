import 'package:flutter/material.dart';
import 'result.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Currency Converter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 28, 123, 212),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Currency Converter'),
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
  final TextEditingController _amount = TextEditingController();
  String _selectedBank = 'TMBThanachart Bank (TTB)';
  String _selectedCurrency = 'US Dollar (USD)';

  final List<String> _banks = [
    'Krungthai Bank (KTB)',
    'Siam Commercial Bank (SCB)',
    'TMBThanachart Bank (TTB)',
  ];

  final Map<String, String> _currencies = {
    'US Dollar (USD)': 'USD',
    'Japanese Yen (JPY)': 'JPY',
    'Euro (EUR)': 'EUR',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _amount,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter amount in Thai Baht',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              value: _selectedBank,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Select Bank',
              ),
              items: _banks
                  .map((bank) => DropdownMenuItem(
                        value: bank,
                        child: Text(bank),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedBank = value!;
                });
              },
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Select Currency:',
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            Column(
              children: _currencies.keys.map((currency) {
                return RadioListTile<String>(
                  title: Text(currency),
                  value: currency,
                  groupValue: _selectedCurrency,
                  onChanged: (value) {
                    setState(() {
                      _selectedCurrency = value!;
                    });
                  },
                );
              }).toList(),
            ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ResultPage(
                        amount: _amount.text,
                        bank: _selectedBank,
                        currency: _currencies[_selectedCurrency]!,
                      ),
                    ),
                  );
                },
                child: const Text('Convert'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

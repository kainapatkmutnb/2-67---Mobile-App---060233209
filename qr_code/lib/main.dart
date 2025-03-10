import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

    @override
    MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
    String _scanBarcode = 'Unknown';

    @override
    void initState() {
        super.initState();
    }

    Future<void> startBarcodeScanStream() async {
        FlutterBarcodeScanner.getBarcodeStreamReceiver(
            '#ff6666',
            'Cancel',
            true,
            ScanMode.BARCODE,
        )!.listen((barcode) => debugPrint(barcode));
    }

    Future<void> scanQR() async {
        String barcodeScanRes;
        try {
            barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                '#ff6666',
                'Cancel',
                true,
                ScanMode.QR,
            );
            debugPrint(barcodeScanRes);
        } on PlatformException {
            barcodeScanRes = 'Failed to get platform version.';
        }

        if (!mounted) return;
        setState(() {
            _scanBarcode = barcodeScanRes;
        });
    }

    Future<void> scanBarcodeNormal() async {
        String barcodeScanRes;
        try {
            barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
                '#ff6666',
                'Cancel',
                true,
                ScanMode.BARCODE,
            );
            print(barcodeScanRes);
        } on PlatformException {
            barcodeScanRes = 'Failed to get platform version.';
        }

        if (!mounted) return;
        setState(() {
            _scanBarcode = barcodeScanRes;
        });
    }

    @override
    Widget build(BuildContext context) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
                appBar: AppBar(title: const Text('Barcode scan')),
                body: Builder(
                    builder: (BuildContext context) {
                        return Container(
                            alignment: Alignment.center,
                            child: Flex(
                                direction: Axis.vertical,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                    ElevatedButton(
                                        onPressed: scanBarcodeNormal,
                                        child: Text('Start barcode scan'),
                                    ),
                                    ElevatedButton(
                                        onPressed: scanQR,
                                        child: Text('Start QR scan'),
                                    ),
                                    ElevatedButton(
                                        onPressed: startBarcodeScanStream,
                                        child: Text('Start barcode scan stream'),
                                    ),
                                    Text(
                                        'Scan result: $_scanBarcode\n',
                                        style: TextStyle(fontSize: 20),
                                    ),
                                ],
                            ),
                        );
                    },
                ),
            ),
        );
    }
}
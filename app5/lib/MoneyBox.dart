import 'package:flutter/material.dart';

class MoneyBox extends StatelessWidget {
  String title;
  double amount;
  double sizeConHeight;
  Color colrSet;

  MoneyBox(
    this.title,
    this.amount,
    this.sizeConHeight,
    this.colrSet,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      height: sizeConHeight,
      decoration: BoxDecoration(
        color: colrSet,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: Text(
              amount.toString(),
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}

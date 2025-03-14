import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('orders')
              .where('userId', isEqualTo: uid)
              .orderBy('timestamp', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator());
        final orders = snapshot.data!.docs;
        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            var order = orders[index].data() as Map<String, dynamic>;
            String status = order['status'] ?? 'pending';
            return ListTile(
              title: Text("Order: ฿${order['total']}"),
              subtitle: Text("Status: $status"),
              trailing: Text(
                order['timestamp'] != null
                    ? (order['timestamp'] as Timestamp)
                        .toDate()
                        .toString()
                        .substring(0, 16)
                    : '',
              ),
            );
          },
        );
      },
    );
  }
}

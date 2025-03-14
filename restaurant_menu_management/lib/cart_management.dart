import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//----------------------------------------
// Cart Manager Implementation
//----------------------------------------
class CartManager {
  static List<Map<String, dynamic>> cartItems = [];

  static void addToCart(Map<String, dynamic> item) {
    int index = cartItems.indexWhere(
      (element) => element['foodId'] == item['foodId'],
    );

    if (index >= 0) {
      cartItems[index]['quantity'] += item['quantity'];
    } else {
      cartItems.add(item);
    }
  }

  static void removeFromCart(String foodId) {
    cartItems.removeWhere((item) => item['foodId'] == foodId);
  }

  static void updateQuantity(String foodId, int newQuantity) {
    int index = cartItems.indexWhere((item) => item['foodId'] == foodId);

    if (index >= 0) {
      if (newQuantity <= 0) {
        removeFromCart(foodId);
      } else {
        cartItems[index]['quantity'] = newQuantity;
      }
    }
  }

  static double get totalPrice {
    double total = 0;
    for (var item in cartItems) {
      total += (item['price'] as num) * (item['quantity'] as int);
    }
    return total;
  }

  static void clearCart() {
    cartItems.clear();
  }
}

//----------------------------------------
// Cart Screen Implementation
//----------------------------------------
class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isPlacingOrder = false;

  //----------------------------------------
  // Order Processing Methods
  //----------------------------------------
  void placeOrder() async {
    if (CartManager.cartItems.isEmpty) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Cart is empty"),
              content: Text(
                "Please add items to the cart before placing an order.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
      );
      return;
    }

    bool paymentSuccess = await showDialog(
      context: context,
      builder: (context) => PaymentDialog(total: CartManager.totalPrice),
    );

    if (paymentSuccess) {
      setState(() {
        isPlacingOrder = true;
      });

      await FirebaseFirestore.instance.collection('orders').add({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'items': CartManager.cartItems,
        'total': CartManager.totalPrice,
        'status': 'paid',
        'timestamp': FieldValue.serverTimestamp(),
      });

      CartManager.clearCart();

      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Order Status"),
              content: Text("Order placed successfully"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      isPlacingOrder = false;
                    });
                  },
                  child: Text("OK"),
                ),
              ],
            ),
      );
    } else {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Order Status"),
              content: Text("Payment failed or cancelled"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
      );
    }
  }

  //----------------------------------------
  // UI Build Method
  //----------------------------------------
  @override
  Widget build(BuildContext context) {
    return isPlacingOrder
        ? Center(child: CircularProgressIndicator())
        : Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: CartManager.cartItems.length,
                  itemBuilder: (context, index) {
                    var item = CartManager.cartItems[index];

                    return ListTile(
                      leading: SizedBox(
                        width: 80,
                        height: 80,
                        child: Image.network(item['imageUrl'] ?? ''),
                      ),
                      title: Text(item['name']),
                      subtitle: Text("Price: ฿${item['price']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                CartManager.updateQuantity(
                                  item['foodId'],
                                  item['quantity'] - 1,
                                );
                              });
                            },
                          ),
                          Text(item['quantity'].toString()),
                          IconButton(
                            icon: Icon(Icons.add),
                            onPressed: () {
                              setState(() {
                                CartManager.updateQuantity(
                                  item['foodId'],
                                  item['quantity'] + 1,
                                );
                              });
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                CartManager.removeFromCart(item['foodId']);
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Text(
                "Total: ฿${CartManager.totalPrice.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              ElevatedButton(onPressed: placeOrder, child: Text("Place Order")),
            ],
          ),
        );
  }
}

//----------------------------------------
// Payment Dialog Implementation
//----------------------------------------
class PaymentDialog extends StatefulWidget {
  final double total;

  PaymentDialog({required this.total});

  @override
  _PaymentDialogState createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<PaymentDialog> {
  bool isProcessing = false;

  void processPayment() async {
    setState(() {
      isProcessing = true;
    });

    // Simulate payment delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      isProcessing = false;
    });

    // Assume payment is successful
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Payment",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            if (isProcessing)
              CircularProgressIndicator()
            else
              Text(
                "Total Amount: ฿${widget.total.toStringAsFixed(2)}",
                style: TextStyle(fontSize: 18),
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed:
                      isProcessing
                          ? null
                          : () {
                            Navigator.of(context).pop(false);
                          },
                  child: Text("Cancel"),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: isProcessing ? null : processPayment,
                  child: Text("Pay"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

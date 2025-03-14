import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'restaurant_management.dart';
import 'cart_management.dart';
import 'order_management.dart';
import 'main.dart';

//----------------------------------------
// Admin Permission Check
//----------------------------------------
void checkIfUserIsAdmin(BuildContext context) {
  String userEmail = FirebaseAuth.instance.currentUser!.email ?? '';
  
  if (userEmail == 'guy26466@gmail.com') {
    showDialog(
      context: context,
      builder: (context) => AddRestaurantDialog(),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("You do not have permission to add items."),
      ),
    );
  }
}

//----------------------------------------
// Home Screen Implementation
//----------------------------------------
class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  
  static List<Widget> _widgetOptions = <Widget>[
    RestaurantListScreen(),
    CartScreen(),
    OrderHistoryScreen(),
  ];

  //----------------------------------------
  // Navigation Methods
  //----------------------------------------
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  //----------------------------------------
  // Build UI
  //----------------------------------------
  @override
  Widget build(BuildContext context) {
    String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Restaurant Menu'),
        actions: [
          if (userEmail == 'guy26466@gmail.com')
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () => checkIfUserIsAdmin(context),
            ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant),
            label: 'Restaurants',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Cart', 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Orders',
          ),
        ],
      ),
    );
  }
}
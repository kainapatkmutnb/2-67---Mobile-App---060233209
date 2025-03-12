import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//----------------------------------------
// Main Application Entry
//----------------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

//----------------------------------------
// App Root Widget
//----------------------------------------
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant Menu',
      theme: ThemeData(primarySwatch: Colors.blue),
      debugShowCheckedModeBanner: false,
      home:
          FirebaseAuth.instance.currentUser == null
              ? LoginScreen()
              : HomeScreen(),
    );
  }
}

//----------------------------------------
// Authentication Screens
//----------------------------------------
// Login Screen
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void login() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Login Failed"),
              content: Text("$e"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: login, child: Text('Login')),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignUpScreen()),
                );
              },
              child: Text('Don\'t have an account? Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}

// Sign Up Screen
class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void signUp() async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder:
            (context) => AlertDialog(
              title: Text("Sign Up Failed"),
              content: Text("$e"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("OK"),
                ),
              ],
            ),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: signUp, child: Text('Sign Up')),
          ],
        ),
      ),
    );
  }
}

//----------------------------------------
// Home Screen and Navigation
//----------------------------------------
void checkIfUserIsAdmin(BuildContext context) {
  String userEmail = FirebaseAuth.instance.currentUser!.email ?? '';
  if (userEmail == 'guy26466@gmail.com') {
    showDialog(context: context, builder: (context) => AddRestaurantDialog());
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("You do not have permission to add items.")),
    );
  }
}

class AddRestaurantDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    void addRestaurant() async {
      await FirebaseFirestore.instance.collection('restaurants').add({
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
      });
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Restaurant added successfully!")));
    }

    return AlertDialog(
      title: Text('Add Restaurant'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Restaurant Name'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(onPressed: addRestaurant, child: Text('Add')),
      ],
    );
  }
}

class EditRestaurantDialog extends StatefulWidget {
  final String restaurantId;
  final String currentName;
  final String currentDescription;

  EditRestaurantDialog({
    required this.restaurantId,
    required this.currentName,
    required this.currentDescription,
  });

  @override
  _EditRestaurantDialogState createState() => _EditRestaurantDialogState();
}

class _EditRestaurantDialogState extends State<EditRestaurantDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.currentName);
    descriptionController = TextEditingController(text: widget.currentDescription);
  }

  void updateRestaurant() async {
    if (nameController.text.isEmpty || descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.restaurantId)
          .update({
        'name': nameController.text.trim(),
        'description': descriptionController.text.trim(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Restaurant updated successfully")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update: $e")));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Restaurant'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: InputDecoration(labelText: 'Restaurant Name'),
          ),
          TextField(
            controller: descriptionController,
            decoration: InputDecoration(labelText: 'Description'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
                onPressed: updateRestaurant,
                child: Text('Save Changes'),
              ),
      ],
    );
  }
}


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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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
                MaterialPageRoute(builder: (context) => LoginScreen()),
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
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Orders'),
        ],
      ),
    );
  }
}

//----------------------------------------
// Restaurant Management
//----------------------------------------
class RestaurantListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    bool isAdmin = userEmail == 'guy26466@gmail.com';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('restaurants').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        final restaurants = snapshot.data!.docs;

        return ListView.builder(
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            var restaurant = restaurants[index];

            return ListTile(
              title: Text(restaurant['name'] ?? 'No Name'),
              subtitle: Text(restaurant['description'] ?? ''),
              trailing: isAdmin
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // ปุ่มแก้ไข (Edit)
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => EditRestaurantDialog(
                                restaurantId: restaurant.id,
                                currentName: restaurant['name'],
                                currentDescription: restaurant['description'],
                              ),
                            );
                          },
                        ),

                        // ปุ่มลบ (Delete)
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Confirm Delete"),
                                content: Text("Are you sure you want to delete ${restaurant['name']}?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await FirebaseFirestore.instance
                                          .collection('restaurants')
                                          .doc(restaurant.id)
                                          .delete();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text("Restaurant deleted successfully")),
                                      );
                                    },
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    )
                  : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FoodListScreen(
                      restaurantId: restaurant.id,
                      restaurantName: restaurant['name'],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}


//----------------------------------------
// Food Management
//----------------------------------------
class FoodListScreen extends StatelessWidget {
  final String restaurantId;
  final String restaurantName;

  FoodListScreen({required this.restaurantId, required this.restaurantName});

  @override
  Widget build(BuildContext context) {
    String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    bool isAdmin = userEmail == 'guy26466@gmail.com';

    return Scaffold(
      appBar: AppBar(
        title: Text(restaurantName),
        actions: [
          if (isAdmin)
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddFoodScreen(restaurantId: restaurantId),
                  ),
                );
              },
            ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('restaurants')
            .doc(restaurantId)
            .collection('foods')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final foods = snapshot.data!.docs;

          return ListView.builder(
            itemCount: foods.length,
            itemBuilder: (context, index) {
              var food = foods[index];

              return ListTile(
                leading: SizedBox(
                  width: 80,
                  height: 80,
                  child: Image.network(
                    food['imageUrl'] ?? 'https://via.placeholder.com/150',
                  ),
                ),
                title: Text(food['name'] ?? 'No Name'),
                subtitle: Text("Price: ฿${food['price']}"),
                trailing: isAdmin
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ปุ่มแก้ไข (Edit)
                          IconButton(
                            icon: Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditFoodScreen(
                                    restaurantId: restaurantId,
                                    foodId: food.id,
                                    foodData: food.data() as Map<String, dynamic>,
                                  ),
                                ),
                              );
                            },
                          ),

                          // ปุ่มลบ (Delete)
                          IconButton(
                            icon: Icon(Icons.delete_outline, color: Colors.red),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Confirm Delete"),
                                  content: Text("Are you sure you want to delete ${food['name']}?"),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Cancel"),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('restaurants')
                                            .doc(restaurantId)
                                            .collection('foods')
                                            .doc(food.id)
                                            .delete();
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text("Food deleted successfully")),
                                        );
                                      },
                                      child: Text("Delete"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FoodDetailScreen(
                        restaurantId: restaurantId,
                        foodId: food.id,
                        foodData: food.data() as Map<String, dynamic>,
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}


class AddFoodScreen extends StatefulWidget {
  final String restaurantId;
  AddFoodScreen({required this.restaurantId});

  @override
  _AddFoodScreenState createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageUrlController = TextEditingController();
  bool isLoading = false;

  void addFood() async {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty ||
        imageUrlController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.restaurantId)
          .collection('foods')
          .add({
            'name': nameController.text,
            'description': descriptionController.text,
            'price': double.parse(priceController.text),
            'imageUrl': imageUrlController.text,
          });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Food added successfully")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to add food: $e")));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Food")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Food Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Food Description'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Food Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: addFood, child: Text('Add Food')),
          ],
        ),
      ),
    );
  }
}

class EditFoodScreen extends StatefulWidget {
  final String restaurantId;
  final String foodId;
  final Map<String, dynamic> foodData;

  EditFoodScreen({
    required this.restaurantId,
    required this.foodId,
    required this.foodData,
  });

  @override
  _EditFoodScreenState createState() => _EditFoodScreenState();
}

class _EditFoodScreenState extends State<EditFoodScreen> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late TextEditingController priceController;
  late TextEditingController imageUrlController;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.foodData['name']);
    descriptionController = TextEditingController(text: widget.foodData['description']);
    priceController = TextEditingController(text: widget.foodData['price'].toString());
    imageUrlController = TextEditingController(text: widget.foodData['imageUrl']);
  }

  void updateFood() async {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty ||
        imageUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all fields")));
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseFirestore.instance
          .collection('restaurants')
          .doc(widget.restaurantId)
          .collection('foods')
          .doc(widget.foodId)
          .update({
        'name': nameController.text,
        'description': descriptionController.text,
        'price': double.parse(priceController.text),
        'imageUrl': imageUrlController.text,
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Food updated successfully")));
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update food: $e")));
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Edit Food")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Food Name'),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Food Description'),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(labelText: 'Food Price'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: imageUrlController,
              decoration: InputDecoration(labelText: 'Image URL'),
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: updateFood,
                    child: Text('Update Food'),
                  ),
          ],
        ),
      ),
    );
  }
}


class FoodDetailScreen extends StatefulWidget {
  final String restaurantId;
  final String foodId;
  final Map<String, dynamic> foodData;
  FoodDetailScreen({
    required this.restaurantId,
    required this.foodId,
    required this.foodData,
  });

  @override
  _FoodDetailScreenState createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.foodData['name'] ?? 'Food Detail')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(widget.foodData['imageUrl'] ?? ''),
            SizedBox(height: 10),
            Text(
              widget.foodData['name'] ?? 'No Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(widget.foodData['description'] ?? ''),
            SizedBox(height: 10),
            Text("Price: ฿${widget.foodData['price']}"),
            SizedBox(height: 10),
            Row(
              children: [
                Text("Quantity: "),
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    if (quantity > 1) {
                      setState(() {
                        quantity--;
                      });
                    }
                  },
                ),
                Text(quantity.toString()),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    setState(() {
                      quantity++;
                    });
                  },
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                CartManager.addToCart({
                  'restaurantId': widget.restaurantId,
                  'foodId': widget.foodId,
                  'name': widget.foodData['name'],
                  'price': widget.foodData['price'],
                  'quantity': quantity,
                  'imageUrl': widget.foodData['imageUrl'],
                });
                showDialog(
                  context: context,
                  builder:
                      (context) => AlertDialog(
                        title: Text("Success"),
                        content: Text("Added to cart"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("OK"),
                          ),
                        ],
                      ),
                );
              },
              child: Text('Add to Cart'),
            ),
          ],
        ),
      ),
    );
  }
}

//----------------------------------------
// Shopping Cart Management
//----------------------------------------
class CartManager {
  static List<Map<String, dynamic>> cartItems = [];

  static void addToCart(Map<String, dynamic> item) {
    int index = cartItems.indexWhere((element) => element['foodId'] == item['foodId']);
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


class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isPlacingOrder = false;

  void placeOrder() async {
    if (CartManager.cartItems.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Cart is empty"),
          content: Text("Please add items to the cart before placing an order."),
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
        builder: (context) => AlertDialog(
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
        builder: (context) => AlertDialog(
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
                                  CartManager.updateQuantity(item['foodId'], item['quantity'] - 1);
                                });
                              },
                            ),
                            Text(item['quantity'].toString()),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  CartManager.updateQuantity(item['foodId'], item['quantity'] + 1);
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
// Payment Processing
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
    return AlertDialog(
      title: Text("Payment"),
      content:
          isProcessing
              ? Center(child: CircularProgressIndicator())
              : Text("Total amount: ฿${widget.total.toStringAsFixed(2)}"),
      actions: [
        TextButton(
          onPressed:
              isProcessing
                  ? null
                  : () {
                    Navigator.of(context).pop(false);
                  },
          child: Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: isProcessing ? null : processPayment,
          child: Text("Pay"),
        ),
      ],
    );
  }
}

//----------------------------------------
// Order Management
//----------------------------------------
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
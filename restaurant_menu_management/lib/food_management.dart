import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cart_management.dart';

//----------------------------------------
// Food List Screen Implementation
//----------------------------------------
class FoodListScreen extends StatelessWidget {
  final String restaurantId;
  final String restaurantName;

  FoodListScreen({
    required this.restaurantId,
    required this.restaurantName,
  });

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
                    builder: (context) => AddFoodScreen(
                      restaurantId: restaurantId,
                    ),
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
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final foods = snapshot.data!.docs;

          return ListView.builder(
            itemCount: foods.length,
            itemBuilder: (context, index) {
              var food = foods[index];

              return ListTile(
                leading: SizedBox(
                  width: 100,
                  height: 100,
                  child: Image.network(
                    food['imageUrl'] ?? '',
                  ),
                ),
                title: Text(
                  food['name'] ?? 'No Name',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Text(
                  "ราคา: ฿${food['price']}",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.blue[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                trailing: isAdmin
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.edit_outlined,
                              color: Colors.blue,
                              size: 28,
                            ),
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
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text("Confirm Delete"),
                                  content: Text(
                                    "Are you sure you want to delete ${food['name']}?",
                                  ),
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
                                          SnackBar(
                                            content: Text("Food deleted successfully"),
                                          ),
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

//----------------------------------------
// Add Food Screen Implementation  
//----------------------------------------
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Food added successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add food: $e")),
      );
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
                : ElevatedButton(
                    onPressed: addFood,
                    child: Text('Add Food'),
                  ),
          ],
        ),
      ),
    );
  }
}

//----------------------------------------
// Edit Food Screen Implementation
//----------------------------------------
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
    descriptionController = TextEditingController(
      text: widget.foodData['description'],
    );
    priceController = TextEditingController(
      text: widget.foodData['price'].toString(),
    );
    imageUrlController = TextEditingController(
      text: widget.foodData['imageUrl'],
    );
  }

  void updateFood() async {
    if (nameController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        priceController.text.isEmpty ||
        imageUrlController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields")),
      );
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

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Food updated successfully")),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update food: $e")),
      );
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

//----------------------------------------
// Food Detail Screen Implementation
//----------------------------------------
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
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 10),
            Text(
              widget.foodData['description'] ?? '',
              style: TextStyle(
                fontSize: 20,
                color: Colors.black54,
                height: 1.5,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "ราคา: ฿${widget.foodData['price']}",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "จำนวน: ",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.remove, size: 28),
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
                  builder: (context) => AlertDialog(
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
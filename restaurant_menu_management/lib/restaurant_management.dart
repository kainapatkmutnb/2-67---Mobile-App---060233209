import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'food_management.dart';

//----------------------------------------
// Add Restaurant Dialog
//----------------------------------------
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Restaurant added successfully!"))
      );
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
        ElevatedButton(
          onPressed: addRestaurant, 
          child: Text('Add')
        ),
      ],
    );
  }
}

//----------------------------------------
// Edit Restaurant Dialog
//----------------------------------------
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all fields"))
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
          .update({
            'name': nameController.text.trim(),
            'description': descriptionController.text.trim(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Restaurant updated successfully"))
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to update: $e"))
      );
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

//----------------------------------------
// Restaurant List Screen
//----------------------------------------
class RestaurantListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    bool isAdmin = userEmail == 'guy26466@gmail.com';

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('restaurants').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }
        
        final restaurants = snapshot.data!.docs;

        return ListView.builder(
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            var restaurant = restaurants[index];
            String description = restaurant['description'] ?? '';
            if (description.length > 100) {
              description = description.substring(0, 100) + '...';
            }

            return ListTile(
              title: Text(
                restaurant['name'] ?? 'No Name',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 18),
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                        IconButton(
                          icon: Icon(Icons.delete_outline, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text("Confirm Delete"),
                                content: Text(
                                  "Are you sure you want to delete ${restaurant['name']}?"
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
                                          .doc(restaurant.id)
                                          .delete();
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            "Restaurant deleted successfully"
                                          ),
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
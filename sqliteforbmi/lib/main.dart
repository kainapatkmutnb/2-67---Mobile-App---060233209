import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import the DatabaseHelper class
import 'user.dart'; // Import the User class

void main() async {
  // Initialize the database and insert users
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDb();
  await DatabaseHelper.instance.initializeUsers();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management',
      home: UserList(),
    );
  }
}

class UserList extends StatefulWidget {
  const UserList({super.key});

  @override
  UserListState createState() => UserListState();
}

class UserListState extends State<UserList> {
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final userMaps = await DatabaseHelper.instance.queryAllUsers();
    setState(() {
      _users = userMaps.map((userMap) => User.fromMap(userMap)).toList();
    });
  }

  Future<void> deleteUser(int userId) async {
    await DatabaseHelper.instance.deleteUser(userId);
    fetchUsers(); // Refresh the user list
  }

  void _editUser(User user) {
    TextEditingController usernameController =
        TextEditingController(text: user.username);
    TextEditingController emailController =
        TextEditingController(text: user.email);
    TextEditingController pwdController = TextEditingController(text: user.pwd);
    TextEditingController weightController =
        TextEditingController(text: user.weight.toString());
    TextEditingController heightController =
        TextEditingController(text: user.height.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: pwdController,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                TextField(
                  controller: weightController,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                ),
                TextField(
                  controller: heightController,
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final double weight = double.parse(weightController.text);
                final double height = double.parse(heightController.text);

                final updatedUser = User(
                  id: user.id, // Keep the same id to update the correct record
                  username: usernameController.text,
                  email: emailController.text,
                  pwd: pwdController.text,
                  weight: weight,
                  height: height,
                );
                DatabaseHelper.instance.updateUser(updatedUser).then((value) {
                  fetchUsers(); // Refresh the user list
                  Navigator.pop(context); // Close the dialog
                });
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context), // Close the dialog without saving
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addUser() {
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController pwdController = TextEditingController();
    TextEditingController weightController = TextEditingController();
    TextEditingController heightController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New User'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: pwdController,
                  decoration: const InputDecoration(labelText: 'Password'),
                ),
                TextField(
                  controller: weightController,
                  decoration: const InputDecoration(labelText: 'Weight (kg)'),
                ),
                TextField(
                  controller: heightController,
                  decoration: const InputDecoration(labelText: 'Height (cm)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                final double weight = double.parse(weightController.text);
                final double height = double.parse(heightController.text);

                final newUser = User(
                  username: usernameController.text,
                  email: emailController.text,
                  pwd: pwdController.text,
                  weight: weight,
                  height: height,
                );
                DatabaseHelper.instance.insertUser(newUser).then((value) {
                  fetchUsers(); // Refresh the user list
                  Navigator.pop(context); // Close the dialog
                });
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context), // Close the dialog without adding
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAllUsers() async {
    await DatabaseHelper.instance.deleteAllUsers(); // Delete all users
    fetchUsers(); // Refresh the user list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Show User List'),
        backgroundColor: const Color.fromARGB(255, 6, 207, 252),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
            onPressed: _deleteAllUsers, // Delete all users when pressed
            color: Colors.redAccent,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  // Account circle icon at the start
                  const Icon(
                    Icons.account_circle,
                    color: Colors.cyan,
                    size: 24,
                  ),
                  const SizedBox(width: 10),
                  // BMI image
                  SizedBox(
                    width: 35,
                    height: 35,
                    child: Image.asset(
                      user.bmiImage,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Middle section - User details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text("Username: ${user.username}"),
                        const SizedBox(height: 5),
                        Text("Email: ${user.email}"),
                        const SizedBox(height: 5),
                        Text("Password: ${user.pwd}"),
                        const SizedBox(height: 5),
                        Text("Weight: ${user.weight} kg"),
                        const SizedBox(height: 5),
                        Text("Height: ${user.height} cm"),
                        const SizedBox(height: 5),
                        Text("BMI: ${user.bmi}"),
                        const SizedBox(height: 5),
                        Text("BMI TYPE: ${user.bmiType}"),
                        const SizedBox(height: 5),
                        Text(
                          user.getWeightAdjustment(),
                          style: TextStyle(
                            color: user.bmiType == 'Normal'
                                ? Colors.green
                                : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Right side - Action Icons
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _editUser(user),
                        color: Colors.lightBlueAccent,
                        iconSize: 20,
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => deleteUser(user.id!),
                        color: Colors.redAccent,
                        iconSize: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        backgroundColor: const Color.fromARGB(255, 7, 174, 221),
        child: const Icon(Icons.add),
      ),
    );
  }
}

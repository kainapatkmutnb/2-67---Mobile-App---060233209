import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper();
  await dbHelper.initializeUsers();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter SQLite CRUD',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: UserList(),
    );
  }
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  List<User> _users = [];

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  Future<void> _fetchUsers() async {
    final userMaps = await DatabaseHelper().queryAllUsers();
    setState(() {
      _users = userMaps.map((userMap) => User.fromMap(userMap)).toList();
    });
  }

  Future<void> _deleteUser(int userId) async {
    await DatabaseHelper().deleteUser(userId);
    _fetchUsers(); // Refresh the user list
  }

  void _editUser(User user) {
    TextEditingController usernameController = TextEditingController(text: user.username);
    TextEditingController emailController = TextEditingController(text: user.email);
    TextEditingController passwordController = TextEditingController(text: user.password);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit User'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedUser = User(
                  id: user.id,
                  username: usernameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  createdAt: user.createdAt,
                );
                DatabaseHelper().updateUser(updatedUser).then((value) {
                  _fetchUsers(); // Refresh the user list
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog without saving
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addUser() {
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add New User'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: usernameController,
                decoration: InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final newUser = User(
                  username: usernameController.text,
                  email: emailController.text,
                  password: passwordController.text,
                  createdAt: DateTime.now().toString(),
                );
                DatabaseHelper().insertUser(newUser).then((value) {
                  _fetchUsers(); // Refresh the user list
                });
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context), // Close the dialog without adding
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAllUsers() async {
    await DatabaseHelper().deleteAllUsers();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User List'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever),
            onPressed: _deleteAllUsers,
            color: Colors.red,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(user.username),
            subtitle: Text('${user.email}\nCreated At: ${user.createdAt}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editUser(user),
                  color: Colors.blue,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteUser(user.id!),
                  color: Colors.red,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        child: Icon(Icons.add),
      ),
    );
  }
}
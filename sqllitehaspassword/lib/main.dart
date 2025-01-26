import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.initializeUsers();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'GFG User List',
      home: UserList(),
    );
  }
}

class UserList extends StatefulWidget {
  const UserList({super.key});

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
    final userMaps = await DatabaseHelper.instance.queryAllUsers();
    setState(() {
      _users = userMaps.map((userMap) => User.fromMap(userMap)).toList();
    });
  }

  Future<void> _deleteUser(int userId) async {
    await DatabaseHelper.instance.deleteUser(userId);
    _fetchUsers();
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
          content: SingleChildScrollView(
            child: Column(
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
                DatabaseHelper.instance.updateUser(updatedUser).then((value) {
                  _fetchUsers();
                  Navigator.pop(context);
                });
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
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
          content: SingleChildScrollView(
            child: Column(
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
                DatabaseHelper.instance.insertUser(newUser).then((value) {
                  _fetchUsers();
                  Navigator.pop(context);
                });
              },
              child: Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAllUsers() async {
    await DatabaseHelper.instance.deleteAllUsers();
    _fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'GFG User List',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(214, 5, 147, 255),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_forever_outlined),
            onPressed: _deleteAllUsers,
            color: Colors.redAccent,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (context, index) {
          final user = _users[index];
          return ListTile(
            leading: Icon(
              Icons.account_circle,
              color: Colors.cyan,
            ),
            title: Text(user.username),
            subtitle: Text('${user.email}\nCreated At: ${user.createdAt}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () => _editUser(user),
                  color: Colors.lightBlueAccent,
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteUser(user.id!),
                  color: Colors.redAccent,
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addUser,
        backgroundColor: const Color.fromARGB(214, 5, 147, 255),
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
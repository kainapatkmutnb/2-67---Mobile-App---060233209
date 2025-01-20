import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDb();
  await DatabaseHelper.instance.initializeUsers();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'User Management',
      home: const UserList(),
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
    final usernameController = TextEditingController(text: user.username);
    final emailController = TextEditingController(text: user.email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit User'),
          content: Column(
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final updatedUser = User(
                  id: user.id,
                  username: usernameController.text,
                  email: emailController.text,
                  password: user.password,
                  createdAt: user.createdAt,
                );
                DatabaseHelper.instance.updateUser(updatedUser).then((_) {
                  _fetchUsers();
                  if (mounted) Navigator.pop(context);
                });
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addUser() {
    final usernameController = TextEditingController();
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add New User'),
          content: Column(
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                final currentContext = context;
                final newUser = User(
                  username: usernameController.text,
                  email: emailController.text,
                  password: 'default_password',
                  createdAt: DateTime.now().toIso8601String(),
                );
                DatabaseHelper.instance.insertUser(newUser).then((_) {
                  _fetchUsers();
                  if (mounted) Navigator.pop(currentContext);
                });
              },
              child: const Text('Add'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
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
        title: const Text('GFG User List'),
        backgroundColor: const Color.fromARGB(255, 6, 207, 252),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_forever),
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
            leading: const Icon(
              Icons.account_circle,
              color: Colors.cyan,
            ),
            title: Text(user.username),
            subtitle: Text(user.email),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editUser(user),
                  color: Colors.blue,
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
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
        backgroundColor: const Color.fromARGB(255, 7, 174, 221),
        child: const Icon(Icons.add),
      ),
    );
  }
}

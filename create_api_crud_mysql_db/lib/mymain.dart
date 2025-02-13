import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(const ShowInf());
}

class ShowInf extends StatefulWidget {
  const ShowInf({super.key});

  @override
  State<ShowInf> createState() => _ShowInfState();
}

class _ShowInfState extends State<ShowInf> {
  List list = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<String> listData() async {
    var response = await http.get(Uri.http('10.0.2.2:8080', 'emp'),
        headers: {"Accept": "application/json"});
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    setState(() {
      list = jsonDecode(response.body);
    });
    return 'Success';
  }

  @override
  void initState() {
    super.initState();
    listData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DB Test'),
      ),
      body: Center(
        child: ListView.builder(
          itemCount: list.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              child: ListTile(
                title: Row(
                  children: [
                    Expanded(child: Text(list[index]['name'])),
                    Expanded(child: Text(list[index]['email'])),
                  ],
                ),
                leading: Text(list[index]['id'].toString()),
                trailing: Wrap(
                  spacing: 5,
                  children: [
                    IconButton(
                      onPressed: () {
                        Map data = {
                          'id': list[index]['id'],
                          'name': list[index]['name'],
                          'address': list[index]['address'],
                          'email': list[index]['email'],
                          'phone': list[index]['phone']
                        };
                        _showEditDialog(data);
                      },
                      icon: const Icon(Icons.edit),
                      color: Colors.green,
                    ),
                    IconButton(
                      onPressed: () => _showDeleteDialog(list[index]["id"]),
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _showAddDialog() async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Employee'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Name', hintText: "Enter employee name"),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email', hintText: "Enter employee email"),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                      labelText: 'Phone', hintText: "Enter employee phone"),
                ),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                      labelText: 'Address', hintText: "Enter employee address"),
                ),
                const Text('Fill in the details and press Confirm'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                addData();
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showDeleteDialog(int id) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete data $id'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Confirm deletion by pressing Confirm'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                deleteData(id);
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void addData() async {
    Map data = {
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': _addressController.text
    };
    var body = jsonEncode(data);
    var response = await http.post(Uri.http('10.0.2.2:8080', 'create'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json"
        },
        body: body);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    listData();
  }

  void deleteData(int id) async {
    var response = await http.delete(Uri.http('10.0.2.2:8080', 'delete/$id'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json"
        });
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    listData();
  }

  Future<void> _showEditDialog(Map data) async {
    _nameController.text = data['name'];
    _emailController.text = data['email'];
    _phoneController.text = data['phone'];
    _addressController.text = data['address'];
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Employee'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      labelText: 'Name', hintText: "Enter employee name"),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                      labelText: 'Email', hintText: "Enter employee email"),
                ),
                TextField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                      labelText: 'Phone', hintText: "Enter employee phone"),
                ),
                TextField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                      labelText: 'Address', hintText: "Enter employee address"),
                ),
                const Text('Update the details and press Confirm'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                editData(data['id']);
                Navigator.of(context).pop();
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void editData(int id) async {
    Map data = {
      'id': id,
      'name': _nameController.text,
      'email': _emailController.text,
      'phone': _phoneController.text,
      'address': _addressController.text
    };
    var body = jsonEncode(data);
    var response = await http.put(Uri.http('10.0.2.2:8080', 'update/$id'),
        headers: {
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: body);
    print("Response status: ${response.statusCode}");
    print("Response body: ${response.body}");
    listData();
  }
}
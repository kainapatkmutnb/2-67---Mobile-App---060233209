import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Page1 extends StatefulWidget {
  const Page1({super.key});

  @override
  State<Page1> createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text(
          'Firebase25',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('userData').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('Loading');
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(data['name']),
                    subtitle: Text(data['job']),
                    leading: const Icon(Icons.person),
                    trailing: !data['admin']
                        ? SizedBox(
                            width: 100,
                            child: Row(
                              children: <Widget>[
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    doEdit(document, data);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    doDel(document.id);
                                  },
                                ),
                              ],
                            ),
                          )
                        : null,
                    tileColor: Colors.amberAccent,
                  ),
                );
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          doAdd();
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void doAdd() async {
    TextEditingController nameController = TextEditingController();
    TextEditingController jobController = TextEditingController();

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: jobController,
                decoration: const InputDecoration(labelText: 'Job'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final FirebaseFirestore firestore = FirebaseFirestore.instance;
                final CollectionReference mainCollection = firestore.collection('userData');

                mainCollection.add({
                  'name': nameController.text,
                  'job': jobController.text,
                  'admin': false,
                });

                Navigator.pop(context);
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void doEdit(DocumentSnapshot document, Map<String, dynamic> data) {
    TextEditingController nameController = TextEditingController();
    TextEditingController jobController = TextEditingController();

    nameController.text = data['name'];
    jobController.text = data['job'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Data'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: jobController,
                decoration: const InputDecoration(labelText: 'Job'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Save Data'),
                      content: const Text('Are you sure?'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            Navigator.pop(context);
                            final FirebaseFirestore firestore = FirebaseFirestore.instance;
                            final CollectionReference mainCollection = firestore.collection('userData');

                            await mainCollection.doc(document.id).update({
                              'name': nameController.text,
                              'job': jobController.text,
                            });

                            Navigator.pop(context);
                          },
                          child: const Text('Save'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void doDel(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Data'),
          content: const Text('Are you sure?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                final FirebaseFirestore firestore = FirebaseFirestore.instance;
                final CollectionReference mainCollection = firestore.collection('userData');

                await mainCollection.doc(id).delete();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
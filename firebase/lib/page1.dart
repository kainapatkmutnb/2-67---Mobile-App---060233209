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
          'GPA Calculator',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calculate, color: Colors.white),
            onPressed: () => showResults(),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('subjects').snapshots(),
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
                Map<String, dynamic> data =
                    document.data() as Map<String, dynamic>;
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    title: Text(data['name']),
                    subtitle: Text(
                      'Credit: ${data['credit']} | Grade: ${data['grade']}',
                    ),
                    leading: const Icon(Icons.book),
                    trailing: SizedBox(
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
                    ),
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

  void showResults() async {
    final QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('subjects').get();

    int totalSubjects = snapshot.docs.length;
    int totalCredits = 0;
    double totalGradePoints = 0;

    for (var doc in snapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      int credit = data['credit'] as int;
      int grade = data['grade'] as int;

      totalCredits += credit;
      totalGradePoints += credit * grade;
    }

    double gpa = totalCredits > 0 ? totalGradePoints / totalCredits : 0.0;

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('GPA Results'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Number of Subjects: $totalSubjects'),
              Text('Total Credits: $totalCredits'),
              Text('GPA: ${gpa.toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void doAdd() async {
    TextEditingController nameController = TextEditingController();
    int selectedCredit = 1;
    int selectedGrade = 0;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Add Subject'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Subject Name',
                    ),
                  ),
                  DropdownButtonFormField<int>(
                    value: selectedCredit,
                    decoration: const InputDecoration(labelText: 'Credits'),
                    items: [1, 2, 3].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() => selectedCredit = value);
                      }
                    },
                  ),
                  DropdownButtonFormField<int>(
                    value: selectedGrade,
                    decoration: const InputDecoration(labelText: 'Grade'),
                    items: [0, 1, 2, 3, 4].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() => selectedGrade = value);
                      }
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('subjects').add({
                      'name': nameController.text,
                      'credit': selectedCredit,
                      'grade': selectedGrade,
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Add'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void doEdit(DocumentSnapshot document, Map<String, dynamic> data) {
    TextEditingController nameController = TextEditingController();
    nameController.text = data['name'];
    int selectedCredit = data['credit'];
    int selectedGrade = data['grade'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Edit Subject'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Subject Name',
                    ),
                  ),
                  DropdownButtonFormField<int>(
                    value: selectedCredit,
                    decoration: const InputDecoration(labelText: 'Credits'),
                    items: [1, 2, 3].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() => selectedCredit = value);
                      }
                    },
                  ),
                  DropdownButtonFormField<int>(
                    value: selectedGrade,
                    decoration: const InputDecoration(labelText: 'Grade'),
                    items: [0, 1, 2, 3, 4].map((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList(),
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() => selectedGrade = value);
                      }
                    },
                  ),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('subjects')
                        .doc(document.id)
                        .update({
                      'name': nameController.text,
                      'credit': selectedCredit,
                      'grade': selectedGrade,
                    });
                    if (!mounted) return;
                    Navigator.pop(context);
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void doDel(String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Subject'),
          content: const Text('Are you sure?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('subjects')
                    .doc(id)
                    .delete();
                if (!mounted) return;
                Navigator.pop(context);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
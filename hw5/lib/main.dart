import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 56, 158, 226),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'List Example'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class Data {
  late int id;
  late String name;
  late DateTime t;
  Data(this.id, this.name, this.t);
}

class _MyHomePageState extends State<MyHomePage> {
  String txt = 'N/A';
  List<Data> mylist = <Data>[];
  int img = 0;
  var list = ['one', 'two', 'three', 'four'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              children: [
                Radio(
                  value: 1,
                  groupValue: img,
                  onChanged: (int? value) {
                    setState(() {
                      img = 1;
                    });
                  },
                ),
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/images/ig.png'),
                ),
              ],
            ),
            const TextField(),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  txt = 'Add item Success';
                  mylist.add(Data(img, '1', DateTime.now()));
                });
              },
              child: const Text('Add Item'),
            ),
            Text(
              txt,
              textScaleFactor: 2,
            ),
            SizedBox(
              width: double.infinity,
              height: 550,
              child: ListView.builder(
                itemCount: mylist.length,
                itemBuilder: (context, index) {
                  return SizedBox(
                    width: double.infinity,
                    height: 80,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      color: Colors.primaries[index % Colors.primaries.length],
                      child: ListTile(
                        leading: const CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage('assets/images/icon2.png'),
                        ),
                        title: Text('Title Text (${mylist[index].id})'),
                        subtitle: Text(mylist[index].t.toString()),
                        trailing: const Icon(Icons.delete_rounded),
                        onTap: () {
                          setState(() {
                            txt = 'Title Text ($index) is removed';
                            mylist.removeAt(index);
                          });
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
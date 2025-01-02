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

class Data {
  int id;
  String name;
  DateTime t;
  String imagePath;

  Data(this.id, this.name, this.t, this.imagePath);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String txt = 'N/A';
  List<Data> mylist = <Data>[];
  int img = 0;

  final List<Map<String, String>> icons = [
    {'id': '1', 'path': 'assets/images/ig.png'},
    {'id': '2', 'path': 'assets/images/line.png'},
    {'id': '3', 'path': 'assets/images/man.png'},
    {'id': '4', 'path': 'assets/images/marvel.jpeg'},
  ];

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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: icons.map((icon) {
                int index = int.parse(icon['id']!);
                return Row(
                  children: [
                    Radio(
                      value: index,
                      groupValue: img,
                      onChanged: (int? value) {
                        setState(() {
                          img = value!;
                        });
                      },
                    ),
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: AssetImage(icon['path']!),
                    ),
                  ],
                );
              }).toList(),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (img != 0) {
                  setState(() {
                    String imagePath = icons
                        .firstWhere((icon) => icon['id'] == img.toString())['path']!;
                    mylist.add(Data(img, 'Title Text ($img)', DateTime.now(), imagePath));
                    txt = 'Add item Success';
                  });
                }
              },
              child: const Text('Add Item'),
            ),
            Text(
              txt,
              textScaleFactor: 2,
            ),
            const SizedBox(height: 10),
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
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundImage: AssetImage(mylist[index].imagePath),
                        ),
                        title: Text(mylist[index].name),
                        subtitle: Text(mylist[index].t.toString()),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_rounded),
                          onPressed: () {
                            setState(() {
                              mylist.removeAt(index);
                              txt = 'Item Removed';
                            });
                          },
                        ),
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

import "package:flutter/material.dart";
import 'foodMenu.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Food Menu",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 77, 172, 226)),
        useMaterial3: true,
      ),
      home: const MyHomePage(
        title: "Food Menu",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<foodmenu> menu = [
    foodmenu("กุ้งแม่น้ำเผา", "950", "assets/images/กุ้งแม่น้ำเผา.jpg"),
    foodmenu("กุ้งแม่ทอดกระเทียม", "950", "assets/images/กุ้งแม่ทอดกระเทียม.jpg"),
    foodmenu("ปลากะพง 3 รส", "350", "assets/images/ปลากะพง 3 รส.jpg"),
    foodmenu("ข้าวผัดปู", "180", "assets/images/ข้าวผัดปู.jpg"),
    foodmenu("ออส่วนหอยนางรม", "180", "assets/images/ออส่วนหอยนางรม.jpg"),
    foodmenu("ยำหอยนางรม", "180", "assets/images/ยำหอยนางรม.jpg"),
    foodmenu("กะหล่ำน้ำปลา", "70", "assets/images/กะหล่ำน้ำปลา.jpg"),
    foodmenu("ขาหมูทอด", "400", "assets/images/ขาหมูทอด.jpg"),
    foodmenu("ไก่ผัดเม็ดมะม่วง", "180", "assets/images/ไก่ผัดเม็ดมะม่วง.jpg"),
    foodmenu("ช้างใหญ่", "60", "assets/images/ช้างใหญ่.png"),
  ];

  Map<int, int> foodQuantity = {};
  int totalQuantity = 0;
  int totalPrice = 0;

  void _incrementQuantity(int index) {
    setState(() {
      foodQuantity[index] = (foodQuantity[index] ?? 0) + 1;
      totalQuantity++;
      totalPrice += int.parse(menu[index].price);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Food Menu"),
      ),
      body: ListView.builder(
        itemCount: menu.length,
        itemBuilder: (BuildContext context, int index) {
          foodmenu food = menu[index];
          return ListTile(
            leading: Image.asset(food.img),
            title: Text(
              "${index + 1}. " + food.name,
              style: TextStyle(fontSize: 30),
            ),
            subtitle: Text(
              "ราคา " + food.price + " บาท",
              style: TextStyle(fontSize: 20),
            ),
            onTap: () {
              _incrementQuantity(index);
              AlertDialog alert = AlertDialog(
                title: Text("คุณเลือกเมนู: ${food.name}"),
                content: Text(
                    "จำนวน: ${foodQuantity[index] ?? 0} จาน\nราคา: ${(foodQuantity[index] ?? 0) * int.parse(food.price)} บาท"),
              );
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return alert;
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          AlertDialog alert = AlertDialog(
            title: Text("สรุปการสั่งซื้อ"),
            content: Text(
                "จำนวนจานทั้งหมด: $totalQuantity\nราคาทั้งหมด: $totalPrice บาท"),
          );
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return alert;
            },
          );
        },
        tooltip: "สรุปการสั่งซื้อ",
        child: const Icon(Icons.check),
      ),
    );
  }
}
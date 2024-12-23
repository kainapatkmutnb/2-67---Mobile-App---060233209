import 'package:flutter/material.dart';
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
      title: "Food Court",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 77, 172, 226),
        ),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: "Food Court"),
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
  int cardBalance = 0;
  int selectedAmount = 0;

  void _incrementQuantity(int index) {
    final foodPrice = int.parse(menu[index].price);
    if (cardBalance >= foodPrice) {
      setState(() {
        foodQuantity[index] = (foodQuantity[index] ?? 0) + 1;
        totalQuantity++;
        totalPrice += foodPrice;
        cardBalance -= foodPrice;
      });
    } else {
      _showInsufficientFundsDialog();
    }
  }

  void _showInsufficientFundsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("แจ้งเตือน"),
        content: const Text("จำนวนเงินไม่เพียงพอ กรุณาเติมเงิน"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ตกลง"),
          ),
        ],
      ),
    );
  }

  void _addMoney() {
    setState(() {
      cardBalance += selectedAmount;
      selectedAmount = 0;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("เติมเงินสำเร็จ"),
        content: Text("ยอดเงินคงเหลือในบัตร: $cardBalance บาท"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("ตกลง"),
          ),
        ],
      ),
    );
  }

  void _refundMoney() {
    if (cardBalance <= 0) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: const Text("แจ้งเตือน"),
          content: const Text("ไม่มียอดเงินคงเหลือในบัตร"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ตกลง"),
            ),
          ],
        ),
      );
      return;
    }

    Map<String, int> refundBreakdown = _calculateRefund(cardBalance);
    String refundDetails = "ยอดเงินที่ต้องคืน: $cardBalance บาท\n\n";
    refundBreakdown.forEach((denomination, count) {
      if (count > 0) {
        if (int.parse(denomination) >= 20) {
          refundDetails += "แบงก์ $denomination บาท = $count ใบ\n";
        } else {
          refundDetails += "เหรียญ $denomination บาท = $count เหรียญ\n";
        }
      }
    });

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text("รายละเอียดการคืนเงิน"),
        content: Text(refundDetails),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                cardBalance = 0;
              });
              Navigator.pop(context);
            },
            child: const Text("ยืนยันการคืนเงิน"),
          ),
        ],
      ),
    );
  }

  Map<String, int> _calculateRefund(int amount) {
    Map<String, int> result = {
      "1000": 0,
      "500": 0,
      "100": 0,
      "50": 0,
      "20": 0,
      "10": 0,
      "5": 0,
      "2": 0,
      "1": 0,
    };

    int remaining = amount;
    List<int> denominations = [1000, 500, 100, 50, 20, 10, 5, 2, 1];

    for (int denomination in denominations) {
      if (remaining >= denomination) {
        result[denomination.toString()] = remaining ~/ denomination;
        remaining = remaining % denomination;
      }
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 92, 152, 237),
        title: const Text(
          "Food Court",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Money selection buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    for (int amount in [1000, 2000, 3000])
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 1,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () {
                            setState(() {
                              selectedAmount = amount;
                            });
                          },
                          child: Text(
                            "$amount",
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 16),
                // Action buttons row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text(
                          "เติมเงิน",
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: selectedAmount > 0 ? _addMoney : null,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.delete_outline),
                        label: const Text(
                          "คืนเงิน",
                          style: TextStyle(fontSize: 18),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: cardBalance > 0 ? _refundMoney : null,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Card balance display
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "ยอดเงินในบัตร: $cardBalance บาท",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          // Menu list
          Expanded(
            child: ListView.builder(
              itemCount: menu.length,
              itemBuilder: (BuildContext context, int index) {
                foodmenu food = menu[index];
                return ListTile(
                  leading: Image.asset(food.img),
                  title: Text(
                    "${index + 1}. ${food.name}",
                    style: const TextStyle(fontSize: 30),
                  ),
                  subtitle: Text(
                    "ราคา ${food.price} บาท",
                    style: const TextStyle(fontSize: 20),
                  ),
                  onTap: () {
                    if (cardBalance >= int.parse(food.price)) {
                      _incrementQuantity(index);
                      AlertDialog alert = AlertDialog(
                        title: Text("คุณเลือกเมนู: ${food.name}"),
                        content: Text(
                          "จำนวน: ${foodQuantity[index] ?? 0} จาน\n"
                          "ราคา: ${(foodQuantity[index] ?? 0) * int.parse(food.price)} บาท\n"
                          "ยอดเงินคงเหลือ: $cardBalance บาท",
                        ),
                      );
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => alert,
                      );
                    } else {
                      _showInsufficientFundsDialog();
                    }
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          String orderSummary = "";
          foodQuantity.forEach((index, quantity) {
            if (quantity > 0) {
              foodmenu food = menu[index];
              orderSummary +=
                  "${food.name} จำนวน: $quantity จาน ราคา: ${quantity * int.parse(food.price)} บาท\n";
            }
          });

          if (orderSummary.isEmpty) {
            orderSummary = "ไม่มีการสั่งซื้อ";
          }

          AlertDialog alert = AlertDialog(
            title: const Text("สรุปการสั่งซื้อ"),
            content: Text(
              "$orderSummary\n"
              "จำนวนทั้งหมด: $totalQuantity จาน\n"
              "ราคาทั้งหมด: $totalPrice บาท\n"
              "ยอดเงินคงเหลือ: $cardBalance บาท",
            ),
          );
          showDialog(
            context: context,
            builder: (BuildContext context) => alert,
          );
        },
        tooltip: "สรุปการสั่งซื้อ",
        child: const Icon(Icons.check),
      ),
    );
  }
}
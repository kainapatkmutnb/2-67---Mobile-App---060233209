import 'package:flutter/material.dart';

// Entry point of the application
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StudentInfo(),
    );
  }
}

class StudentInfo extends StatelessWidget {
  const StudentInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("KAINAPXT"),
        centerTitle: true,
      ),
      body: Container(
        color: const Color.fromARGB(255, 169, 204, 248), // Background color
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Student image in a rectangular frame
              Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  border: Border.all(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  image: const DecorationImage(
                    image: NetworkImage(
                      'https://scontent.fbkk21-1.fna.fbcdn.net/v/t1.6435-9/121568107_2793321097590694_120953819959235772_n.jpg?_nc_cat=109&ccb=1-7&_nc_sid=6ee11a&_nc_eui2=AeHN8xqQ4BJgELxJ_nXHURX7gurLkC4iKc2C6suQLiIpzWtCAHSNdEXUNzKFmBHwou5sJjd1aFrAVBtQd8LO36uh&_nc_ohc=CK9cUQ54-LYQ7kNvgFn-fnr&_nc_zt=23&_nc_ht=scontent.fbkk21-1.fna&_nc_gid=ADUrTf-WWQYugpCn47avsl2&oh=00_AYA4kIsN4bPLS_xBwWsNyzGN1pKHHLUstM3N1C1Jrvoatw&oe=677DF9EE',
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Student name
              const Text(
                "Name: KAINAPAT",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              // Student lastname
              const Text(
                "Last name: SUWANNACHOTE",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'activity_page.dart';
import 'discovery_page.dart';
import 'feed_page.dart';
import 'home_page.dart';
import 'library_page.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
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
  int _currentIndex = 0; 
  final tabs = [
    const Home(),
    const Feed(),
    const Discovery(),
    const Activity(),
    const Library(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        iconSize: 30,
        items: const [
            BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            backgroundColor: Color(0xFFB07A85), // 15% darker pastel pink
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.rss_feed),
            label: 'Feed',
            backgroundColor: Color(0xFF627687), // 15% darker pastel blue
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Discovery',
            backgroundColor: Color(0xFF457A45), // 15% darker pastel green
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Activity',
            backgroundColor: Color(0xFFA3A34F), // 15% darker pastel yellow
            ),
            BottomNavigationBarItem(
            icon: Icon(Icons.video_library),
            label: 'Library',
            backgroundColor: Color(0xFF66536F), // 15% darker pastel purple
            ),
        ],
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}

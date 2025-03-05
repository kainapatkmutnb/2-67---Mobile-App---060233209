import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_map/screens/current_location_screen.dart';
import 'package:google_map/screens/kmutnb.dart';
import 'package:google_map/screens/simple_map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map New"),
        centerTitle: true,
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return MapSample();
                    },
                  ),
                );
              },
              child: const Text("Simple Map"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return CurrentLocation();
                    },
                  ),
                );
              },
              child: const Text("Current Location"),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return KmutnbScreen();
                    },
                  ),
                );
              },
              child: const Text("KMUTNB Locations"),
            ),
          ],
        ),
      ),
    );
  }
}
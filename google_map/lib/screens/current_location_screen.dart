import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CurrentLocation extends StatefulWidget {
  const CurrentLocation({Key? key}) : super(key: key);

  @override
  _CurrentLocationState createState() => _CurrentLocationState();
}

class _CurrentLocationState extends State<CurrentLocation> {
  late GoogleMapController googleMapController;
  static const CameraPosition initialCameraPosition = CameraPosition(
    target: LatLng(37.42796133588664, -122.085749655962),
    zoom: 14.4746,
  );

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Current Location"),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: initialCameraPosition,
        onMapCreated: (GoogleMapController controller) {
          googleMapController = controller;
        },
        markers: markers,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          Position position = await _determinePosition();
          googleMapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 14,
              ),
            ),
          );
          markers.clear();
          markers.add(
            Marker(
              markerId: MarkerId("Current Location"),
              position: LatLng(position.latitude, position.longitude),
            ),
          );
          setState(() {});
        },
        label: const Text("Current Location"),
        icon: const Icon(Icons.location_history),
      ),
    );
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error("Location Service Disabled");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error("Location Permission Denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error("Location Permissions are permanently denied");
    }

    return await Geolocator.getCurrentPosition();
  }
}
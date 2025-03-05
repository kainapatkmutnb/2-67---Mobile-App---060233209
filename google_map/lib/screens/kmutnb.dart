import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class KmutnbScreen extends StatefulWidget {
  @override
  _KmutnbScreenState createState() => _KmutnbScreenState();
}

class _KmutnbScreenState extends State<KmutnbScreen> {
  GoogleMapController? mapController;
  final LatLng _center = const LatLng(14.16085, 101.34860);

  final Set<Marker> _markers = {
    Marker(
      markerId: MarkerId('หอพักชาย'),
      position: LatLng(14.16546, 101.34558),
      infoWindow: InfoWindow(title: 'หอพักชาย'),
    ),
    Marker(
      markerId: MarkerId('คณะอุตสาหกรรมเกษตรดิจิทัล'),
      position: LatLng(14.15771, 101.34915),
      infoWindow: InfoWindow(title: 'คณะอุตสาหกรรมเกษตรดิจิทัล'),
    ),
    Marker(
      markerId: MarkerId('สนามบิน มจพ.ปราจีน'),
      position: LatLng(14.16553, 101.33918),
      infoWindow: InfoWindow(title: 'สนามบิน มจพ.ปราจีน'),
    ),
  };

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _goToLocation(double lat, double lng) {
    mapController?.animateCamera(CameraUpdate.newLatLng(LatLng(lat, lng)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('KMUTNB Locations'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 15.0,
              ),
              markers: _markers,
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 125),
                    child: ElevatedButton(
                      onPressed: () => _goToLocation(14.16546, 101.34558),
                      child: Text('หอพักชาย'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 125),
                    child: ElevatedButton(
                      onPressed: () => _goToLocation(14.15771, 101.34915),
                      child: Text('คณะอุตสาหกรรมเกษตรดิจิทัล'),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 125),
                    child: ElevatedButton(
                      onPressed: () => _goToLocation(14.16553, 101.33918),
                      child: Text('สนามบิน มจพ.ปราจีน'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
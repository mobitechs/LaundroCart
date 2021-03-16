import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


// ignore: camel_case_types
class Google_map extends StatefulWidget {
  @override
  _Google_mapState createState() => _Google_mapState();
}

// ignore: camel_case_types
class _Google_mapState extends State<Google_map> {

//  GoogleMapController mapController;
//
//  final Map<String, Marker> _markers = {};
//
//  void _getLocation() async {
//    var currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//
//    setState(() {
////      _markers.clear();
//    final marker = Marker(
//      markerId: MarkerId("curr_loc"),
//      position: LatLng(currentLocation.latitude, currentLocation.longitude),
//      infoWindow: InfoWindow(title: "Your Location"),
//    );
//    });
//    return _getLocation();
//  }


  LatLng _initialcameraposition = LatLng(20.5937, 78.9629);
  GoogleMapController _controller;
  Location _location = Location();


  void _onMapCreated(GoogleMapController _cntlr)
  {
    _controller = _cntlr;
    _location.onLocationChanged.listen((l)  {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: LatLng(l.latitude, l.longitude),zoom: 25),
        ),
      );
    });
  }

  // location.onLocationChanged.listen((LocationData currentLocation) {
  // // Use current location
  // });



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(target: _initialcameraposition),
              mapType: MapType.hybrid,
              onMapCreated: _onMapCreated,
              myLocationEnabled: true,
              rotateGesturesEnabled: true,
            ),
          ],
        ),
      ),
    );
  }
//  LatLng LatLng(latitude, longitude) {}
  }


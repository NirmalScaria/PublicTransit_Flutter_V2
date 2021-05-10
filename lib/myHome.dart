import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'myGlobals.dart';
import 'dart:developer' as developer;
import 'package:flutter/services.dart' show rootBundle;

/*
class MyBackgroundMap extends StatelessWidget {
  String _mapStyle = '';

  LatLng _initialcameraposition = LatLng(11.5937, 77.9629);

  Widget build(BuildContext context) {
    GoogleMapController mapController;
    return GoogleMap(
        initialCameraPosition:
            CameraPosition(target: _initialcameraposition, zoom: 18),
        mapType: MapType.normal,
        myLocationEnabled: true,
        onMapCreated: (controller) {
          rootBundle.loadString('assets/mapstyle.txt').then((string) {
            _mapStyle = string;
            mapController = controller;
            mapController.setMapStyle(_mapStyle);
            //mapController.animateCamera(CameraUpdate )
          });
        });
  }
}
*/
class MyBackgroundMap extends StatefulWidget {
  @override
  _MyBackgroundMapState createState() => _MyBackgroundMapState();
}

class _MyBackgroundMapState extends State<MyBackgroundMap> {
  GoogleMapController? mapController;
  var location = new Location();
  String? _mapStyle;
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition:
          CameraPosition(target: LatLng(26.9124, 75.7873), zoom: 10),
      rotateGesturesEnabled: true,
      compassEnabled: true,
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      mapType: MapType.normal,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    rootBundle.loadString('lib/assets/mapstyle.txt').then((string) {
      _mapStyle = string;
      mapController = controller;
      mapController?.setMapStyle(_mapStyle);
      //mapController.animateCamera(CameraUpdate )
    });

    location.getLocation().then((LocationData locationData) {
      LatLng latLng = new LatLng(locationData.latitude, locationData.longitude);
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(latLng, 13);
      mapController?.animateCamera(cameraUpdate);
    });
  }
}

import 'package:busmap2/myFromandTo.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'myGlobals.dart';
import 'dart:developer' as developer;
import 'package:flutter/services.dart' show rootBundle;
import 'myCards.dart';
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
  late GoogleMapController mapController;
  var location = new Location();
  String? _mapStyle;
  @override
  void initState() {
    super.initState();
    developer.log("getting");
    setState(() {});
    location.getLocation().then((LocationData locationData) {
      developer.log("nothing yet");
      developer.log("got location");
      setState(() {});
    });
  }

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
    developer.log("Loading mapstyle");
    controller.setMapStyle(mymapstyle);


    //mapController?.setMapStyle(string);
    //mapController.animateCamera(CameraUpdate )

    location.getLocation().then((LocationData locationData) {
      LatLng latLng = new LatLng(
          locationData.latitude + 0.14, locationData.longitude - 0.86);
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(latLng, 13);
      mapController.animateCamera(cameraUpdate);
      fromBoxState.getResponse(
          locationData.latitude + 0.14, locationData.longitude - 0.86);
      cardState.getResponse2(
          locationData.latitude + 0.14, locationData.longitude - 0.86);

      developer.log((locationData.latitude + 0.14).toString());
      developer.log((locationData.longitude - 0.86).toString());
    });
  }
}

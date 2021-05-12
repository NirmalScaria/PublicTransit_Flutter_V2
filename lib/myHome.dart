/*
README

This file is the heart of user location related activities in the app.
First thing that happens is that the map loads.
Once map is loaded, the _onMapCreated function is called, and that is where the magic happens.
Inside that function, two functions, one each for suggestion cards and fromTextBox are called.
Inside each those functions, there are codes to get http response and display accordingly.

*/

import 'package:busmap2/myFromandTo.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'myGlobals.dart';
import 'dart:developer' as developer;
import 'myCards.dart';

class MyBackgroundMap extends StatefulWidget {
  @override
  _MyBackgroundMapState createState() => _MyBackgroundMapState();
}

class _MyBackgroundMapState extends State<MyBackgroundMap> {
  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(target: LatLng(9, 76), zoom: 7),
      rotateGesturesEnabled: true,
      compassEnabled: true,
      onMapCreated: _onMapCreated,
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      mapType: MapType.normal,
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    controller.setMapStyle(mymapstyle);

    location.getLocation().then((LocationData locationData) {
      LatLng latLng = new LatLng(
          locationData.latitude , locationData.longitude );
      CameraUpdate cameraUpdate = CameraUpdate.newLatLngZoom(latLng, 13);
      controller.animateCamera(cameraUpdate);
      fromBoxState.setFromBoxLocation(
          locationData.latitude , locationData.longitude );
      cardState.loadCardsData(
          locationData.latitude , locationData.longitude );
    });
  }
}

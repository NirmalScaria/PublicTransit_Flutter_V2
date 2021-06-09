/*
README

This file is the heart of user location related activities in the app.
First thing that happens is that the map loads.
Once map is loaded, the _onMapCreated function is called, and that is where the magic happens.
Inside that function, two functions, one each for suggestion cards and fromTextBox are called.
Inside each those functions, there are codes to get http response and display accordingly.

*/

import 'dart:ui';

import 'package:busmap2/myFromandTo.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'myGlobals.dart';
import 'dart:developer' as developer;
import 'myCards.dart';
late _MyBackgroundMapState backgroundMapState;
late GoogleMapController myMapController;





class myBackgroundMap extends StatefulWidget {
  @override
  _MyBackgroundMapState createState(){
     backgroundMapState=_MyBackgroundMapState();
     return backgroundMapState;
  }
}
late BitmapDescriptor myIcon;

class _MyBackgroundMapState extends State<myBackgroundMap> {


  @override
void initState() {
    BitmapDescriptor.fromAssetImage(
        ImageConfiguration(size: Size(25, 25)), 'lib/assets/my_location.png')
        .then((onValue) {
      myIcon = onValue;
    });
 }




  List<Marker> allMarkers=[];

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
      markers: Set.from(allMarkers),
    );
  }

void setFromOnly(double lat, double lng) {
  
 
  setState(() {
    allMarkers.add(Marker(
  markerId: MarkerId('From'),
  draggable: false,
  position: LatLng(lat,lng),
  icon: myIcon,
  //icon: BitmapDescriptor.fromAssetImage(configuration , 'assets/my_location.png');
));
});
myMapController.animateCamera(CameraUpdate.newCameraPosition(
  CameraPosition(target: LatLng(lat,lng), zoom:13.0)));
  



}



  void _onMapCreated(GoogleMapController controller) async {
    setState(() {
      myMapController=controller;
    });
    controller.setMapStyle(mymapstyle);
    developer.log("TRYING");
try{
    location.getLocation().then((LocationData locationData) {
      developer.log("Got location");
      presentlat=locationData.latitude;
      presentlong=locationData.longitude;
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
catch(e){
  developer.log("ERROR");
  developer.log(e.toString());
}
  }
}

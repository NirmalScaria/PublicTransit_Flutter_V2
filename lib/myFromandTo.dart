import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';

var closests = [" WHERE ?"];

class myFromBox extends StatefulWidget {
  @override
  _myFromBoxState createState() => _myFromBoxState();
}

class _myFromBoxState extends State<myFromBox> {
  var location = new Location();
  var resptext = "0";
  var jsonClosests = [];
  @override

  //Init state of the form boxes execute a get location command.
  //When location is got, then occurs the get response command towards server.
  //When response is got, he location value is updated.
  void initState() {
    super.initState();
    developer.log("getting");
    setState(() {
      closests[0] = " WHERE?";
    });
    location.getLocation().then((LocationData locationData) {
      developer.log("got location");
      setState(() {
        closests[0] = "got location" + locationData.longitude.toString();
      });
      _getResponse(locationData.latitude, locationData.longitude).then((value) {
        setState(() {
          resptext = value;
        });
      });
    });
  }

  Future<String> _getResponse(double lat, double lng) async {
    closests[0] = " (LOADING)";
    var url = Uri.parse("http://65.1.230.169/api/findclosestjson.php");
    var response = await http
        .post(url, body: {"gx": lat.toString(), "gy": lng.toString()});
    jsonClosests = jsonDecode(response.body);
    //fromloc="YOO";
    setState(() {
      closests[0] = ": " + jsonClosests[0]["stopname"];
    });
    return ("done");

    //HERE IS THE REMAINING
    // Make this resptext variable a list. Get all the suggestions. Use it where it is needed.
    //Change the server side code to give list instead of one value.
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 120, 30, 0),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 17,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.location_searching_rounded,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                  hintText: 'FROM${closests[0]}'),
            ),
          ),
          DecoratedIcon(
            Icons.more_vert,
            color: Colors.white,
            size: 80,
            shadows: [
              BoxShadow(
                blurRadius: 12.0,
                color: Colors.black54,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 0),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black38,
                  blurRadius: 17,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.location_on_rounded,
                    color: Colors.black87,
                  ),
                  fillColor: Colors.white,
                  filled: true,
                  border: InputBorder.none,
                  hintText: 'WHERE TO?',
                  hintStyle: TextStyle(color: Colors.black87)),
            ),
          ),
        ],
      ),
    );
  }
}

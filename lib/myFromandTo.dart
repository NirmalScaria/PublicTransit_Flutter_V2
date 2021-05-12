import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'myGlobals.dart';

var closests = [" WHERE ?", " TO?"];
var fromname = " WHERE?";
int fromval = 0;
var toname = "WHERE TO?";

late _MyFromBoxState fromBoxState;

class myFromBox extends StatefulWidget {
  @override
  _MyFromBoxState createState() {
    fromBoxState = _MyFromBoxState();
    return fromBoxState;
  }
}

class _MyFromBoxState extends State<myFromBox> {
  var location = new Location();
  var resptext = "0";
  var jsonClosests = [];
  @override

  //Init state of the form boxes execute a get location command.
  //When location is got, then occurs the get response command towards server.
  //When response is got, he location value is updated.
  void initState() {
    super.initState();
    setState(() {
      closests[0] = " WHERE?";
      closests[1] = " TO?";
    });
    location.getLocation().then((LocationData locationData) {});
  }

  Future<String> setFromBoxLocation(double lat, double lng) async {
    closests[0] = " (LOADING)";
    var url = Uri.parse("http://65.1.230.169/api/findclosestjson.php");
    var response = await http
        .post(url, body: {"gx": lat.toString(), "gy": lng.toString()});
    jsonClosests = jsonDecode(response.body);
    setState(() {
      fromname = ": " + jsonClosests[0]["stopname"];
      fromval = jsonClosests[0]["stopid"];
    });
    return ("done");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(30, 100, 30, 0),
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
                  hintText: 'FROM$fromname'),
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
                  hintText: '$toname',
                  hintStyle: TextStyle(color: Colors.black87)),
            ),
          ),
        ],
      ),
    );
  }
}

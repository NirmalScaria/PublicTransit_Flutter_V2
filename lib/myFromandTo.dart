import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'myGlobals.dart';
import 'myAutoSuggestions.dart';
import 'package:back_button_interceptor/back_button_interceptor.dart';


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
    BackButtonInterceptor.add(myInterceptor);
    setState(() {
      closests[0] = " WHERE?";
      closests[1] = " TO?";
    });
    location.getLocation().then((LocationData locationData) {});
  }

  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool  myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    setState(() {
      isfromfocused1 = 0;
      isfromfocused = 0;
      
    });
    return true;
  }

  Future<String> setFromBoxLocation(double lat, double lng) async {
    closests[0] = " (LOADING)";
    var url = Uri.parse("http://65.1.230.169/api/findclosestjson.php");
    var response = await http
        .post(url, body: {"gx": lat.toString(), "gy": lng.toString()});
    jsonClosests = jsonDecode(response.body);
    setState(() {
      fromname = "" + jsonClosests[0]["stopname"];
      fromval = jsonClosests[0]["stopid"];
    });
    return ("done");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
      child: Column(
        children: [
          AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 500),
              margin: isfromfocused == 1
                  ? EdgeInsets.fromLTRB(0, 0, 0, 0)
                  : EdgeInsets.fromLTRB(10, 40, 10, 0),
              padding: isfromfocused == 0
                  ? EdgeInsets.fromLTRB(0, 0, 0, 0)
                  : EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: isfromfocused == 0
                    ? BorderRadius.zero
                    : BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 17,
                    offset: const Offset(0, 0),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isfromfocused1 = 1;
                        isfromfocused = 1;
                      });
                    },
                    child: AnimatedContainer(
                        curve: Curves.fastOutSlowIn,
                        duration: Duration(milliseconds: 500),
                        width: 290,
                        decoration: BoxDecoration(
                            color: isfromfocused == 0
                                ? Colors.white
                                : Colors.black12,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          children: [
                            SizedBox(width: 10),
                            Icon(
                              Icons.location_searching_rounded,
                            ),
                            SizedBox(width: 7),
                            Text("FROM: ",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black87,
                                )),
                            Expanded(
                              child: TextField(
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '$fromname'),
                                onTap: () {
                                  setState(() {
                                    isfromfocused = 1;

                                    isfromfocused1 = 1;
                                  });
                                },
                              ),
                            ),
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isfromfocused = 0;
                      });
                      FocusScope.of(context).unfocus();
                      setState(() {
                        isfromfocused1 = 0;
                      });
                    },
                    child: Container(
                        color: Colors.white,
                        height: 40,
                        width: 40,
                        child: isfromfocused == 0
                            ? SizedBox(width: 5)
                            : Icon(Icons.arrow_back)),
                  )
                ],
              )),
          FromSuggestionsBox(),
          /* From OLD
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
              textCapitalization: TextCapitalization.characters,
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
          */
          if (isfromfocused1 == 0)
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
          if (isfromfocused1 == 0)
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
                textCapitalization: TextCapitalization.characters,
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

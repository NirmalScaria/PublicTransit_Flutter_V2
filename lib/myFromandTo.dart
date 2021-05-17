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
import 'dart:io';

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

  void openfrombox() async {
    if (isfromfocused == 0) {
      items = [];
      counter = 0;
      setState(() {
        isfromfocused = 1;
        isfromfocused1 = 1;
      });
      for (int i = 0; i < jsonClosests.length; i++) {
        if (isfromfocused == 1) {
          setState(() {
            listKey.currentState?.insertItem(items.length,
                duration: const Duration(milliseconds: 800));
            items = []
              ..add(counter++)
              ..addAll(items);
          });
          await Future.delayed(Duration(milliseconds: i < 6 ? i * 40 : 20));
        }
      }
    }
  }

  void onFromChanged(String xx) async {
    if (xx == "") {
      xx = "0";
    }

    developer.log(xx);
    developer.log(lenofsuggestions.toString());

    closests[0] = " (LOADING)";
    var url = Uri.parse(
        "http://ec2-35-180-190-15.eu-west-3.compute.amazonaws.com/api/findclosestauto.php");
    var response = await http.post(url, body: {
      "gx": presentlat.toString(),
      "gy": presentlong.toString(),
      "typed": xx
    });

    setState(() {
      listKey.currentState?.insertItem(items.length,
          duration: const Duration(milliseconds: 800));
      items = []
        ..add(counter++)
        ..addAll(items);
    });

    setState(() {
      jsonClosests = jsonDecode(response.body);
      fromname = "" + jsonClosests[0]["stopname"];
      fromval = jsonClosests[0]["stopid"];
      lenofsuggestions = jsonClosests.length;
      developer.log(lenofsuggestions.toString());
    });
    setState(() {
      fromtyped = xx;
    });
    setState(() {
      developer.log(response.body);
      //fromname = "" + jsonClosests[0]["stopname"];
      //fromval = jsonClosests[0]["stopid"];
    });
  }

  void closefrombox() async {
    if (isfromfocused == 1) {
      setState(() {
        isfromfocused1 = 0;
        isfromfocused = 0;
      });
      while (items.length > -1) {
        if (items.length < 1) return;
        listKey.currentState?.removeItem(
            items.length - 1, (_, animation) => slideIt(context, 0, animation),
            duration: const Duration(milliseconds: 1));
        setState(() {
          items.removeAt(0);
        });
      }
      items = [];
      counter = 0;
    }
  }

  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    closefrombox();
    return true;
  }

  Future<String> setFromBoxLocation(double lat, double lng) async {
    closests[0] = " (LOADING)";
    var url = Uri.parse(
        "http://ec2-35-180-190-15.eu-west-3.compute.amazonaws.com/api/findclosestjson.php");
    var response = await http
        .post(url, body: {"gx": lat.toString(), "gy": lng.toString()});

    setState(() {
      jsonClosests = jsonDecode(response.body);
      fromname = "" + jsonClosests[0]["stopname"];
      fromval = jsonClosests[0]["stopid"];
    });
    return ("done");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
      child: Stack(
        children: [
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
            Container(
              alignment: Alignment(0, -1),
              padding: EdgeInsets.only(top: 100),
              child: DecoratedIcon(
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
            ),
          if (isfromfocused1 == 0)
            Container(
              margin: EdgeInsets.fromLTRB(10, 190, 10, 0),
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
                      developer.log("Opening");
                      openfrombox();
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
                              Icons.my_location,
                            ),
                            SizedBox(width: 7),
                            Text("FROM: ",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: Colors.black87,
                                )),
                            Expanded(
                              child: TextField(
                                onChanged: (String xx) {
                                  onFromChanged(xx);
                                },
                                controller: myFromController,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: '$fromname'),
                                onTap: openfrombox,
                              ),
                            ),
                          ],
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      closefrombox();
                      FocusScope.of(context).unfocus();
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
        ],
      ),
    );
  }
}

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'myGlobals.dart';
import 'dart:developer' as developer;
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

late _MyCardState cardState;

class MyCard extends StatefulWidget {
  @override
  _MyCardState createState() {
    cardState = _MyCardState();
    return cardState;
  }
}

class _MyCardState extends State<MyCard> {
  int _index = 0;
  var jsonresp = [];
  var jsonstartone = [
    {
      'origin': "Loading",
      'dest': 'Loading',
      'depart': '--:--',
      'reach': '--:--',
      'busname': 'Loading...'
    }
  ];
  var jsonstart = [];
  int i = 0;

  @override
  void initState() {
    super.initState();
    for (i = 0; i < 15; i++) {
      jsonstart = jsonstart + jsonstartone;
    }
  }

  Future<String> loadCardsData(double lat, double lng) async {
    var url = Uri.parse("http://65.1.230.169/api/getsuggestions.php");
    var response = await http
        .post(url, body: {"gx": lat.toString(), "gy": lng.toString()});
    jsonresp = jsonDecode(response.body);

    setState(() {
      jsonstart = jsonresp;
    });
    developer.log(jsonstart.toString());
    developer.log(jsonresp.toString());
    return ("done");
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -150,
      width: MediaQuery.of(context).size.width + 150,
      top: MediaQuery.of(context).size.height - 30 - 287,
      child: SizedBox(
        height: 287,
        child: PageView.builder(
          itemCount: 14,
          controller: PageController(viewportFraction: 0.43),
          onPageChanged: (int index) => setState(() => _index = index),
          itemBuilder: (_, i) {
            return Transform.scale(
              scale: i == _index ? 1 : 0.9,
              child: Container(
                margin: EdgeInsets.only(left: 30),
                child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            Container(
                              decoration: new BoxDecoration(boxShadow: [
                                BoxShadow(
                                    spreadRadius: 2,
                                    blurRadius: 20,
                                    offset: Offset(0, 10),
                                    color: Color.fromRGBO(100, 100, 100, 0.6))
                              ]),
                              child: ClipRRect(
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(19),
                                    topLeft: Radius.circular(19)),
                                child: Image(
                                  image: AssetImage('lib/assets/bus1.png'),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 10,
                                left: 20,
                                child: Text(
                                  "KSRTC",
                                  style: GoogleFonts.ptMono(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ))
                          ],
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(12, 20, 0, 0),
                          child: Row(
                            children: [
                              Container(
                                width: 75,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${jsonstart[i]['origin']}",
                                        style: GoogleFonts.ptSansCaption(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "${jsonstart[i]['depart']}",
                                        style: GoogleFonts.ptSansCaption(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 13,
                                            color:
                                                Color.fromRGBO(120, 0, 0, 100)),
                                      )
                                    ]),
                              ),
                              SizedBox(
                                  width: 18,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: 14,
                                  )),
                              Container(
                                width: 75,
                                child: Column(
                                  children: [
                                    Text(
                                      "${jsonstart[i]['dest']}",
                                      style: GoogleFonts.ptSansCaption(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Text(
                                      "${jsonstart[i]['reach']}",
                                      style: GoogleFonts.ptSansCaption(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 13,
                                          color:
                                              Color.fromRGBO(120, 0, 0, 100)),
                                    )
                                  ],
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.fromLTRB(14, 10, 0, 0),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.star,
                                  size: 18,
                                  color: Color.fromRGBO(255, 188, 0, 1),
                                ),
                                Icon(
                                  Icons.star,
                                  size: 18,
                                  color: Color.fromRGBO(255, 188, 0, 1),
                                ),
                                Icon(
                                  Icons.star,
                                  size: 18,
                                  color: Color.fromRGBO(255, 188, 0, 1),
                                ),
                                Icon(
                                  Icons.star,
                                  size: 18,
                                  color: Color.fromRGBO(255, 188, 0, 1),
                                ),
                                Icon(
                                  Icons.star,
                                  size: 18,
                                  color: Color.fromRGBO(163, 163, 163, 1),
                                ),
                              ],
                            )),
                        Container(
                          padding: EdgeInsets.fromLTRB(14, 10, 0, 0),
                          child: Row(
                            children: [
                              Text("Status:",
                                  style: GoogleFonts.ptSansCaption(
                                    fontSize: 13,
                                  )),
                              SizedBox(width: 7),
                              Icon(Icons.circle,
                                  size: 12,
                                  color: Color.fromRGBO(0, 177, 17, 1)),
                              SizedBox(width: 5),
                              Text("On-time",
                                  style: GoogleFonts.ptSansCaption(
                                    fontSize: 14,
                                    color: Color.fromRGBO(0, 177, 17, 1),
                                  ))
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            );
          },
        ),
      ),
    );
  }
}

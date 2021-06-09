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


  @override
  void initState() {
    super.initState();

  }

  Future<String> loadCardsData(double lat, double lng) async {
    var url = Uri.parse("https://nirmalpoonattu.tk/api/getsuggestions.php");
    var response = await http
        .post(url, body: {"gx": lat.toString(), "gy": lng.toString()});
    jsonresp = jsonDecode(response.body);

    setState(() {
      jsonsuggestions = jsonresp;
    });
    return ("done");
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -150,
      width: MediaQuery.of(context).size.width + 150,
      bottom:30,
      child: SizedBox(
        height: 307,
        child: PageView.builder(
          physics: BouncingScrollPhysics(),
          itemCount: 14,
          controller: PageController(viewportFraction: 0.43),
          onPageChanged: (int index) => setState(() => _index = index),
          itemBuilder: (_, i) {
            return Transform.scale(
              //scale:isfromfocused == 0 ? ( i == _index ? 1 : 0.9 ): 0.01,
              scale:i == _index ? 1 : 0.9,
              child: Container(
                margin: EdgeInsets.fromLTRB(30,10,0,10),
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
                                constraints: BoxConstraints(maxWidth: 75),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${jsonsuggestions[i]['origin']}",
                                        style: GoogleFonts.ptSansCaption(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text(
                                        "${jsonsuggestions[i]['depart']}",
                                        style: GoogleFonts.ptSansCaption(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 13,
                                            color:
                                                Color.fromRGBO(120, 0, 0, 100)),
                                      )
                                    ]),
                              ),
                              SizedBox(
                                  width: 23,
                                  child: Icon(
                                    Icons.arrow_forward,
                                    size: 14,
                                  )),
                              Expanded(
                                                              child: Container(
                                  constraints: BoxConstraints(),
                                  //color:Colors.red,
                                  child: Column(
                                    children: [
                                      Text(
                                        "${jsonsuggestions[i]['dest']}",
                                        style: GoogleFonts.ptSansCaption(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        "${jsonsuggestions[i]['reach']}",
                                        style: GoogleFonts.ptSansCaption(
                                            fontWeight: FontWeight.w900,
                                            fontSize: 13,
                                            color:
                                                Color.fromRGBO(120, 0, 0, 100)),
                                      )
                                    ],
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                  ),
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

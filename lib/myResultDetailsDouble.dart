import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'myHome.dart';
import 'myFromandTo.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'myGlobals.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;
import 'dart:convert';
import 'myFromandTo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'mySelectionPreview.dart';

class ResultExpandedDouble extends StatefulWidget {
  const ResultExpandedDouble({Key? key, required this.itemid})
      : super(key: key);
  final int itemid;
  @override
  _ResultExpandedDoubleState createState() => _ResultExpandedDoubleState();
}

class _ResultExpandedDoubleState extends State<ResultExpandedDouble> {
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(
        children: [
          Stack(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(12, 6, 0, 0),
                  color: Color.fromRGBO(201, 98, 98, 1),
                  height: 25,
                  width: 7),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(50, 50, 50, 0.5), blurRadius: 7)
                    ]),
                child: Text('hail',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(2, 176, 240, 1),
                        fontFamily: 'MaterialIcons',
                        shadows: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 185, 255, 0.5),
                              blurRadius: 12)
                        ])),
              )
            ],
          ),
          SizedBox(width: 10),
          Container(
            constraints: BoxConstraints(maxWidth:MediaQuery.of(context).size.width - 200),
            child: MarqueeWidget(
              child: Text(
                masterresponse[widget.itemid]['getinp'][0],
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: Color.fromRGBO(21, 21, 21, 1),
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Spacer(),
          Text(
            masterresponse[widget.itemid]['getint'][0],
            style: GoogleFonts.roboto(
                fontSize: 18,
                color: Color.fromRGBO(21, 21, 21, 1),
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
      Container(
          decoration: BoxDecoration(
              border: Border(
            left: BorderSide(
              width: 7.0,
              color: Color.fromRGBO(201, 98, 98, 1),
            ),
          )),
          margin: EdgeInsets.only(left: 12),
          padding: EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(201, 98, 98, 1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  margin: EdgeInsets.only(top: 10, bottom: 6),
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('directions_bus',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'MaterialIcons',
                                )),
                            SizedBox(width: 4),
                            Text(
                              masterresponse[widget.itemid]['nameofbus'][0],
                              style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        MarqueeWidget(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                masterresponse[widget.itemid]['originofbus'][0],
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text('chevron_right_outlined',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontFamily: 'MaterialIcons',
                                  )),
                              Text(
                                masterresponse[widget.itemid]['destofbus'][0],
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ])),
              Divider(
                color: Color.fromRGBO(194, 194, 194, 1),
                thickness: 1,
              ),
              Row(
                children: [
                  Text('airline_seat_recline_normal_outlined',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color.fromRGBO(115, 115, 115, 1),
                        fontFamily: 'MaterialIcons',
                      )),
                  SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      masterresponse[widget.itemid]['travelmessage'][0],
                      style: GoogleFonts.roboto(
                          fontSize: 15,
                          color: Color.fromRGBO(115, 115, 115, 1),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Color.fromRGBO(194, 194, 194, 1),
                thickness: 1,
              ),
              SizedBox(height: 6),
              Text(
                "Bus details",
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Color.fromRGBO(27, 27, 27, 1),
                    fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8, bottom: 6),
                    padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: Color.fromRGBO(184, 184, 184, 1))),
                    child: Row(
                      children: [
                        Text('watch_later',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontFamily: 'MaterialIcons',
                            )),
                        SizedBox(width: 5),
                        Text(
                          "Usually on time",
                          style: GoogleFonts.roboto(
                              fontSize: 13,
                              color: Color.fromRGBO(27, 27, 27, 1),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 7),
                  Container(
                    margin: EdgeInsets.only(top: 8, bottom: 6),
                    padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: Color.fromRGBO(184, 184, 184, 1))),
                    child: Row(
                      children: [
                        Text('thumb_down',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontFamily: 'MaterialIcons',
                            )),
                        SizedBox(width: 5),
                        Text(
                          "No realtime data",
                          style: GoogleFonts.roboto(
                              fontSize: 13,
                              color: Color.fromRGBO(27, 27, 27, 1),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
            ],
          )),
      Row(
        children: [
          Stack(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  color: Color.fromRGBO(201, 98, 98, 1),
                  height: 25,
                  width: 7),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(50, 50, 50, 0.5), blurRadius: 7)
                    ]),
                child: Text('link',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(168, 53, 128, 1),
                        fontFamily: 'MaterialIcons',
                        shadows: [
                          BoxShadow(
                              color: Color.fromRGBO(168, 53, 128, 0.5),
                              blurRadius: 12)
                        ])),
              )
            ],
          ),
          SizedBox(width: 10),
         Container(
            constraints: BoxConstraints(maxWidth:MediaQuery.of(context).size.width - 200),
            child: MarqueeWidget(
              child: Text(
                masterresponse[widget.itemid]['getoutp'][0],
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: Color.fromRGBO(21, 21, 21, 1),
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Spacer(),
          Text(
            masterresponse[widget.itemid]['getoutt'][0],
            style: GoogleFonts.roboto(
                fontSize: 18,
                color: Color.fromRGBO(21, 21, 21, 1),
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
      Row(
        children: [
          Column(children: [
            Container(
              height: 7,
              width: 7,
              margin: EdgeInsets.only(left: 12, top: 6),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(196, 196, 196, 1),
                  shape: BoxShape.circle),
            ),
            Container(
              height: 7,
              width: 7,
              margin: EdgeInsets.only(left: 12, top: 6),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(196, 196, 196, 1),
                  shape: BoxShape.circle),
            ),
            Container(
              height: 7,
              width: 7,
              margin: EdgeInsets.only(left: 12, top: 6),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(196, 196, 196, 1),
                  shape: BoxShape.circle),
            ),
            SizedBox(height: 6)
          ]),
          SizedBox(width: 20),
          Text('schedule',
              style: TextStyle(
                fontSize: 22,
                color: Color.fromRGBO(115, 115, 115, 1),
                fontFamily: 'MaterialIcons',
              )),
          SizedBox(width: 7),
          Text(
            masterresponse[widget.itemid]['waitmsg'],
            style: GoogleFonts.roboto(
                fontSize: 15,
                color: Color.fromRGBO(115, 115, 115, 1),
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
      Row(
        children: [
          Stack(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(12, 6, 0, 0),
                  color: Color.fromRGBO(201, 98, 98, 1),
                  height: 25,
                  width: 7),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(50, 50, 50, 0.5), blurRadius: 7)
                    ]),
                child: Text('link',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(168, 53, 128, 1),
                        fontFamily: 'MaterialIcons',
                        shadows: [
                          BoxShadow(
                              color: Color.fromRGBO(168, 53, 128, 0.5),
                              blurRadius: 12)
                        ])),
              )
            ],
          ),
          SizedBox(width: 10),
          Container(
            constraints: BoxConstraints(maxWidth:MediaQuery.of(context).size.width - 200),
            child: MarqueeWidget(
              child: Text(
                masterresponse[widget.itemid]['getinp'][1],
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: Color.fromRGBO(21, 21, 21, 1),
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Spacer(),
          Text(
            masterresponse[widget.itemid]['getint'][1],
            style: GoogleFonts.roboto(
                fontSize: 18,
                color: Color.fromRGBO(21, 21, 21, 1),
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
      Container(
          decoration: BoxDecoration(
              border: Border(
            left: BorderSide(
              width: 7.0,
              color: Color.fromRGBO(201, 98, 98, 1),
            ),
          )),
          margin: EdgeInsets.only(left: 12),
          padding: EdgeInsets.only(left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  constraints: BoxConstraints(maxWidth: 200),
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(201, 98, 98, 1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  margin: EdgeInsets.only(top: 10, bottom: 6),
                  padding: EdgeInsets.all(10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('directions_bus',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontFamily: 'MaterialIcons',
                                )),
                            SizedBox(width: 4),
                            Text(
                              masterresponse[widget.itemid]['nameofbus'][1],
                              style: GoogleFonts.roboto(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                            ),
                          ],
                        ),
                        MarqueeWidget(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                masterresponse[widget.itemid]['originofbus'][1],
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text('chevron_right_outlined',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontFamily: 'MaterialIcons',
                                  )),
                              Text(
                                masterresponse[widget.itemid]['destofbus'][1],
                                style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                      ])),
              Divider(
                color: Color.fromRGBO(194, 194, 194, 1),
                thickness: 1,
              ),
              Row(
                children: [
                  Text('airline_seat_recline_normal_outlined',
                      style: TextStyle(
                        fontSize: 22,
                        color: Color.fromRGBO(115, 115, 115, 1),
                        fontFamily: 'MaterialIcons',
                      )),
                  SizedBox(width: 7),
                  Expanded(
                    child: Text(
                      masterresponse[widget.itemid]['travelmessage'][1],
                      style: GoogleFonts.roboto(
                          fontSize: 15,
                          color: Color.fromRGBO(115, 115, 115, 1),
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
              Divider(
                color: Color.fromRGBO(194, 194, 194, 1),
                thickness: 1,
              ),
              SizedBox(height: 6),
              Text(
                "Bus details",
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Color.fromRGBO(27, 27, 27, 1),
                    fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 8, bottom: 6),
                    padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: Color.fromRGBO(184, 184, 184, 1))),
                    child: Row(
                      children: [
                        Text('watch_later',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontFamily: 'MaterialIcons',
                            )),
                        SizedBox(width: 5),
                        Text(
                          "Usually on time",
                          style: GoogleFonts.roboto(
                              fontSize: 13,
                              color: Color.fromRGBO(27, 27, 27, 1),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 7),
                  Container(
                    margin: EdgeInsets.only(top: 8, bottom: 6),
                    padding: EdgeInsets.fromLTRB(8, 4, 8, 4),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: Color.fromRGBO(184, 184, 184, 1))),
                    child: Row(
                      children: [
                        Text('thumb_down',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue,
                              fontFamily: 'MaterialIcons',
                            )),
                        SizedBox(width: 5),
                        Text(
                          "No realtime data",
                          style: GoogleFonts.roboto(
                              fontSize: 13,
                              color: Color.fromRGBO(27, 27, 27, 1),
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
            ],
          )),
      Row(
        children: [
          Stack(
            children: [
              Container(
                  margin: EdgeInsets.fromLTRB(12, 0, 0, 0),
                  color: Color.fromRGBO(201, 98, 98, 1),
                  height: 25,
                  width: 7),
              Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                          color: Color.fromRGBO(50, 50, 50, 0.5), blurRadius: 7)
                    ]),
                child: Text('place_outlined',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromRGBO(207, 11, 11, 1),
                        fontFamily: 'MaterialIcons',
                        shadows: [
                          BoxShadow(
                              color: Color.fromRGBO(207, 11, 11, 0.5),
                              blurRadius: 12)
                        ])),
              )
            ],
          ),
          SizedBox(width: 10),
          Container(
            constraints: BoxConstraints(maxWidth:MediaQuery.of(context).size.width - 200),
            child: MarqueeWidget(
              child: Text(
                masterresponse[widget.itemid]['getoutp'][1],
                style: GoogleFonts.roboto(
                    fontSize: 18,
                    color: Color.fromRGBO(21, 21, 21, 1),
                    fontWeight: FontWeight.w700),
              ),
            ),
          ),
          Spacer(),
          Text(
            masterresponse[widget.itemid]['getoutt'][1],
            style: GoogleFonts.roboto(
                fontSize: 18,
                color: Color.fromRGBO(21, 21, 21, 1),
                fontWeight: FontWeight.w700),
          ),
        ],
      ),
      SizedBox(height: 7),
      //Image(image: AssetImage('lib/assets/hail.png'))
    ]);
  }
}

import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';
import 'myFromandTo.dart';
import 'myHome.dart';
var suggestionWidgets=<Widget>[];
var isqueryopen=0;
var location = new Location();
var presentlat;
var presentlong;
var isfromfocused = 0;
var istofocused=0;
var fromtyped = "";
var totyped="";

StopObject fromselectedobject = StopObject();
StopObject toselectedobject = StopObject();

var fromolist=<StopObject>[];
var toolist=<StopObject>[];
double fromlat=0;
double fromlng=0;
double tolat=0;
double tolng=0;
var fromid=0;
var toid=0;
int i = 0;
var myFromController = TextEditingController();
var myToController = TextEditingController();
final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();

final GlobalKey<AnimatedListState> listKeyTo = GlobalKey<AnimatedListState>();

class StopObject{
  final double lat;
  final double lng;
  final String stopname;
  final int stopid;
  final String placeid;
  final String district;
  final String state ;
  StopObject({
    this.lat=0,
    this.lng=0,
    this.stopname="",
    this.stopid=0,
    this.placeid="",
    this.district="",
    this.state="",
  });
  Map<String, dynamic> stopMapped() {
    return {
      'stopid': stopid,
      'stopname': stopname,
      'lat':lat,
      'lng':lng,
      'placeid':placeid,
      'district':district,
      'state':state,
    };
  }
  @override
  String toString() {
    return 'StopObject{stopid: $stopid, stopname: $stopname, lat: $lat, lng: $lng, placeid: $placeid, district: $district, state: $state}';
  }
}




/*
Widget slideItTo(BuildContext context, int index, animation) {
  var item = index < jsonClosestsTo.length
      ? jsonClosestsTo[index]['stopname']
      : "NO RESULT FOUND";
  
  return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0.2, 0),
        end: Offset(0, 0),
      ).animate(
          CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
      child: index < lenofsuggestions
          ? Material(
              color: Colors.white.withOpacity(0.0),
              child: InkWell(
                  onTap: () {
                    fromBoxState.toselected();

                    FocusScope.of(context).unfocus();
                    //fromtyped = "$item";
                    toid=jsonClosestsTo[index]['stopid'];
                    tolat=jsonClosestsTo[index]['lat'];
                    tolng=jsonClosestsTo[index]['lng'];

                    myToController.text = "$item";
                    /*
                  fromtyped="$item";
                  */
                  },
                  child: Ink(
                    color: Colors.transparent,
                    // Actual widget to display
                    //constraints: BoxConstraints(maxWidth: 500),
                    //height: 50.0,
                    padding: EdgeInsets.only(top: 10, bottom: 9),
                    width: 90,
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.black87,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          //color:Colors.red,
                          width: 260,

                          child: RichText(
                              text: TextSpan(
                                  text:
                                      item.toString().length > totyped.length
                                          ? item
                                              .toString()
                                              .substring(0, totyped.length)
                                          : item.toString(),
                                  style: GoogleFonts.ptSansCaption(
                                      fontSize: 17,
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w700),
                                  children: [
                                if (item.toString().length > totyped.length)
                                  TextSpan(
                                      text: item
                                          .toString()
                                          .substring(totyped.length),
                                      style: GoogleFonts.ptSansCaption(
                                        fontSize: 17,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.normal,
                                      )),
                              ])),
                        ),
                      ],
                    ),
                  )),
            )
          : SizedBox(height: 5));
}

*/

var jsonstartone = [
  {
    'origin': "Loading",
    'dest': 'Loading',
    'depart': '--:--',
    'reach': '--:--',
    'busname': 'Loading...'
  }
];
var jsonsuggestions = [];
void myMainInit() {
  for (i = 0; i < 15; i++) {
    jsonsuggestions = jsonsuggestions + jsonstartone;
  }
}

var mymapstyle = """
[
    {
        "featureType": "administrative",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "color": "#686868"
            }
        ]
    },
    {
        "featureType": "landscape",
        "elementType": "all",
        "stylers": [
            {
                "color": "#f2f2f2"
            }
        ]
    },
    {
        "featureType": "poi",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "road",
        "elementType": "all",
        "stylers": [
            {
                "saturation": -100
            },
            {
                "lightness": 45
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "simplified"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "lightness": "-22"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "geometry.stroke",
        "stylers": [
            {
                "saturation": "11"
            },
            {
                "lightness": "-51"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "labels.text",
        "stylers": [
            {
                "saturation": "3"
            },
            {
                "lightness": "-56"
            },
            {
                "weight": "2.20"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "lightness": "-52"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "labels.text.stroke",
        "stylers": [
            {
                "weight": "6.13"
            }
        ]
    },
    {
        "featureType": "road.highway",
        "elementType": "labels.icon",
        "stylers": [
            {
                "lightness": "-10"
            },
            {
                "gamma": "0.94"
            },
            {
                "weight": "1.24"
            },
            {
                "saturation": "-100"
            },
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "geometry",
        "stylers": [
            {
                "lightness": "-16"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "saturation": "-41"
            },
            {
                "lightness": "-41"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "labels.text.stroke",
        "stylers": [
            {
                "weight": "5.46"
            }
        ]
    },
    {
        "featureType": "road.arterial",
        "elementType": "labels.icon",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "geometry.fill",
        "stylers": [
            {
                "weight": "0.72"
            },
            {
                "lightness": "-16"
            }
        ]
    },
    {
        "featureType": "road.local",
        "elementType": "labels.text.fill",
        "stylers": [
            {
                "lightness": "-37"
            }
        ]
    },
    {
        "featureType": "transit",
        "elementType": "all",
        "stylers": [
            {
                "visibility": "off"
            }
        ]
    },
    {
        "featureType": "water",
        "elementType": "all",
        "stylers": [
            {
                "color": "#b7e4f4"
            },
            {
                "visibility": "on"
            }
        ]
    }
]""";

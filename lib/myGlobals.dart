import 'package:location/location.dart';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

var location = new Location();
var isfromfocused = 0;
var isfromfocused1 = 0;
var jsonClosests = [];
int i = 0;


final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
int counter = 0;
List items = [];

Widget slideIt(BuildContext context, int index, animation) {
  var item = jsonClosests[index]['stopname'];
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset(0, 0),
    ).animate(CurvedAnimation(parent: animation, curve: Curves.fastOutSlowIn)),
    child: Container(
      // Actual widget to display
      constraints: BoxConstraints(maxWidth: 500),
      //height: 50.0,
      padding:EdgeInsets.only(top:10, bottom:9),
      width:90,
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
            width: 260,
            child: Text(item.toString(),
                style: GoogleFonts.ptSansCaption(
                  fontSize: 17,
                  color: Colors.black54,
                )),
          ),
        ],
      ),
    ),
  );
}

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

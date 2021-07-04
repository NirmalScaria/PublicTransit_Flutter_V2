import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'myHome.dart';
import 'myFromandTo.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'myGlobals.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import 'myFromandTo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'myTimePicker.dart';
import 'myResult.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:math';

late _SelectionPreviewState selectionPreviewState;

class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final Duration animationDuration, backDuration, pauseDuration;

  MarqueeWidget({
    required this.child,
    this.direction: Axis.horizontal,
    this.animationDuration: const Duration(milliseconds: 3000),
    this.backDuration: const Duration(milliseconds: 800),
    this.pauseDuration: const Duration(milliseconds: 800),
  });

  @override
  _MarqueeWidgetState createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  ScrollController? scrollController;

  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 50.0);
    WidgetsBinding.instance?.addPostFrameCallback(scroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: widget.child,
      scrollDirection: widget.direction,
      controller: scrollController,
    );
  }

  void scroll(_) async {
    while (scrollController!.hasClients) {
      await Future.delayed(widget.pauseDuration);
      if (scrollController!.hasClients)
        await scrollController!.animateTo(
            scrollController!.position.maxScrollExtent,
            duration: widget.animationDuration,
            curve: Curves.ease);
      await Future.delayed(widget.pauseDuration);
      if (scrollController!.hasClients)
        await scrollController!.animateTo(0.0,
            duration: widget.backDuration, curve: Curves.easeOut);
    }
  }
}

class SelectionPreview extends StatefulWidget {
  const SelectionPreview({Key? key}) : super(key: key);

  @override
  _SelectionPreviewState createState() {
    selectionPreviewState = _SelectionPreviewState();
    return selectionPreviewState;
  }
}

class _SelectionPreviewState extends State<SelectionPreview> {
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }

  Future<BitmapDescriptor> getBitmapDescriptorFromAssetBytes(
      String path, int width) async {
    final Uint8List imageData = await getBytesFromAsset(path, width);
    return BitmapDescriptor.fromBytes(imageData);
  }

  void search() async {
    developer.log("searching");
    var querytime =
        "${selectedTime.hour < 10 ? 0 : ""}${selectedTime.hour}${selectedTime.minute < 10 ? 0 : ""}${selectedTime.minute}00";

    fromBoxState.setState(() {
      isrotating = 0;

      markers.clear();
      polylines.clear();
    });
    myMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          (fromselectedobject.lat + toselectedobject.lat) / 2 -
              (0.05 * pow(2, 12.4 - (zoomlevel - 1.1))),
          (fromselectedobject.lng + toselectedobject.lng) / 2,
        ),
        bearing: 0,
        tilt: 0,
        zoom: zoomlevel - 1.1)));

    resultDetailsState.setState(() {
      showresultbox = 1;
    });
    await Future.delayed(Duration(milliseconds: 30));
    resultDetailsState.setState(() {
      focusedtileid = 0;
      appstatus = "waitingforresult";
    });
    setState(() {
      appstatus = "waitingforresult";
    });

    var url = Uri.parse("https://3buses.tk/api/searchapi.php");
    var response = await http.post(url, body: {
      "originselected": fromselectedobject.stopid.toString(),
      "destselected": toselectedobject.stopid.toString(),
      "timeselected": querytime,
      "startlagmax": "18000",
      "minlayover": "1",
      "maxlayover": "18000"
    });
    final myOriginIcon =
        await getBitmapDescriptorFromAssetBytes("lib/assets/hail.png", 100);
    final myLinkIcon =
        await getBitmapDescriptorFromAssetBytes("lib/assets/link.png", 100);
    final myTargetIcon =
        await getBitmapDescriptorFromAssetBytes("lib/assets/dest.png", 100);
        final myPointIcon =
        await getBitmapDescriptorFromAssetBytes("lib/assets/point.png", 40);
    //developer.log(response.body);
    masterresponse = jsonDecode(response.body);
    //developer.log(masterresponse.toString());
    resultDetailsState.setState(() {
      appstatus = "showresult";
      resultarrived = 1;
    });
    myMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          (fromselectedobject.lat + toselectedobject.lat) / 2 -
              (0.05 * pow(2, 12.4 - (zoomlevel - 0.3))),
          (fromselectedobject.lng + toselectedobject.lng) / 2,
        ),
        bearing: 0,
        zoom: zoomlevel - 0.3)));
developer.log(masterresponse[0]["lats"][0].toString());
List<LatLng> polylinepoints=[];
        for(int iii=0;iii<masterresponse[0]["lats"].length;iii++){
polylinepoints.add(LatLng((masterresponse[0]["lats"][iii].toDouble()),masterresponse[0]["lngs"][iii].toDouble()));
}

Polyline polyline = Polyline(
        width: 5,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        polylineId: PolylineId("polyres1"),
        color: Color.fromRGBO(201, 98, 98, 1),
        points: polylinepoints,
      );



    backgroundMapState.setState(() {

      for(int iii=1;iii<masterresponse[0]["lats"].length-1;iii++){
markers.add(Marker(
        anchor: const Offset(0.5,0.5),
          alpha: 1,
          markerId: MarkerId("point$iii"),
          icon: myPointIcon,
          position: LatLng(masterresponse[0]["lats"][iii],
              masterresponse[0]["lngs"][iii])));
}


      


      if(masterresponse[0]["numberofsteps"]==2){
      markers.add(Marker(
        anchor: const Offset(0.5,0.5),
          alpha: 1,
          markerId: MarkerId("origin"),
          icon: myOriginIcon,
          position: LatLng(masterresponse[0]["getinlat"][0],
              masterresponse[0]["getinlng"][0])));

      markers.add(Marker(
        anchor: const Offset(0.5,0.5),
          alpha: 1,
          markerId: MarkerId("link"),
          icon: myLinkIcon,
          position: LatLng(masterresponse[0]["getinlat"][1],
              masterresponse[0]["getinlng"][1])));

      markers.add(Marker(
        anchor: const Offset(0.5,0.5),
          alpha: 0.9,
          markerId: MarkerId("dest"),
          icon: myTargetIcon,
          position: LatLng(masterresponse[0]["getoutlat"][1],
              masterresponse[0]["getoutlng"][1])));
      }
      else{
        markers.add(Marker(
        anchor: const Offset(0.5,0.5),
          alpha: 1,
          markerId: MarkerId("origin"),
          icon: myOriginIcon,
          position: LatLng(masterresponse[0]["getinlat"],
              masterresponse[0]["getinlng"])));

      markers.add(Marker(
        anchor: const Offset(0.5,0.5),
          alpha: 1,
          markerId: MarkerId("dest"),
          icon: myTargetIcon,
          position: LatLng(masterresponse[0]["getoutlat"],
              masterresponse[0]["getoutlng"])));
      }
polylines.add(polyline);
    });

    //if first result is conect
    /*
    if (masterresponse[0]["numberofsteps"] == 2) {
      Polyline polyline = Polyline(
        width: 7,
        zIndex: 500,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        polylineId: PolylineId("polyres1"),
        color: Color.fromRGBO(201, 98, 98, 0.5),
        points: [
          LatLng(masterresponse[0]["getinlat"][0],
              masterresponse[0]["getinlng"][0]),
          LatLng(masterresponse[0]["getinlat"][1],
              masterresponse[0]["getinlng"][1])
        ],
      );
      Polyline polyline2 = Polyline(
        width: 4,
        zIndex: 500,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        polylineId: PolylineId("polyres2"),
        color: Color.fromRGBO(201, 98, 98, 1),
        points: [
          LatLng(masterresponse[0]["getinlat"][0],
              masterresponse[0]["getinlng"][0]),
          LatLng(masterresponse[0]["getinlat"][1],
              masterresponse[0]["getinlng"][1])
        ],
      );
      Polyline polyline3 = Polyline(
        width: 7,
        zIndex: 500,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        polylineId: PolylineId("polyres3"),
        color: Color.fromRGBO(201, 98, 98, 0.5),
        points: [
          LatLng(masterresponse[0]["getinlat"][1],
              masterresponse[0]["getinlng"][1]),
          LatLng(masterresponse[0]["getoutlat"][1],
              masterresponse[0]["getoutlng"][1])
        ],
      );
      Polyline polyline4 = Polyline(
        width: 4,
        zIndex: 500,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        polylineId: PolylineId("polyres4"),
        color: Color.fromRGBO(201, 98, 98, 1),
        points: [
          LatLng(masterresponse[0]["getinlat"][1],
              masterresponse[0]["getinlng"][1]),
          LatLng(masterresponse[0]["getoutlat"][1],
              masterresponse[0]["getoutlng"][1])
        ],
      );
      backgroundMapState.setState(() {
        markers.add(Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        alpha: 0.9,
        markerId: MarkerId("origin"),
        position: LatLng(masterresponse[0]["getinlat"][0],
              masterresponse[0]["getinlng"][0])));
            
            markers.add(Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
        alpha: 0.9,
        markerId: MarkerId("connect"),
        position: LatLng(masterresponse[0]["getinlat"][1],
              masterresponse[0]["getinlng"][1])));

              markers.add(Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        alpha: 0.9,
        markerId: MarkerId("dest"),
        position: LatLng(masterresponse[0]["getoutlat"][1],
              masterresponse[0]["getoutlng"][1])));

        polylines.add(polyline);
        polylines.add(polyline2);
        polylines.add(polyline3);
        polylines.add(polyline4);
      });
    }
    /*
    await Future.delayed(Duration(milliseconds: 1000));
    fromBoxState.setState((){
isrotating=1;
        });
      fromBoxState.keeprotating(fromselectedobject, toselectedobject, zoomlevel-0.3);
      */
//CONNECT END
*/
  }

  void toggledepartreach() {
    //developer.log("TOGGLE");
    if (departorreach == "depart") {
      setState(() {
        departorreach = "reach";
      });

//developer.log("TO REACH");
    } else {
      setState(() {
        departorreach = "depart";
      });

      //developer.log("TO DEPART");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: AnimatedContainer(
            duration: Duration(milliseconds: 800),
            curve: Curves.fastOutSlowIn,
            height: appstatus != "selectionpreview" ? 0 : 400,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: appstatus != "selectionpreview"
                  ? Color.fromRGBO(255, 255, 255, 0.3)
                  : Color.fromRGBO(255, 255, 255, 1),
              borderRadius: BorderRadius.circular(23),
              boxShadow: [
                BoxShadow(
                  color: appstatus != "selectionpreview"
                      ? Color.fromRGBO(255, 255, 255, 0)
                      : Colors.black38,
                  blurRadius: 17,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
          ),
        ),
        AnimatedOpacity(
          opacity: appstatus == "selectionpreview" ? 1 : 0,
          duration: Duration(milliseconds: 900),
          child: Align(
              alignment: Alignment.bottomCenter,
              child: appstatus == "selectionpreview"
                  ? Container(
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                      height: appstatus != "selectionpreview" ? 0 : 355,
                      width: MediaQuery.of(context).size.width - 40,

                      //color:Colors.red,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              Container(
                                margin: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width - 260,
                                    top: 52),
                                height: 81,
                                width: 200,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color.fromRGBO(0, 237, 255, 0.3),
                                      blurRadius: 17,
                                      offset: const Offset(0, 0),
                                    ),
                                    BoxShadow(
                                      color: Colors.white,
                                      spreadRadius: -5.0,
                                      blurRadius: 5.0,
                                    ),
                                  ],
                                  border: Border.all(
                                      color: Color.fromRGBO(2, 131, 255, 1),
                                      width: 1),
                                  borderRadius: BorderRadius.circular(42.5),
                                ),
                              ),
                              Container(
                                  margin: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width -
                                          330,
                                      top: 49),
                                  height: 71,
                                  width: 80,
                                  color: Colors.white),

                              //FROM BOX START
                              GestureDetector(
                                onTap: () {
                                  fromBoxState.closeselectionpreview();
                                  fromBoxState.openfrombox();
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left: 18, top: 21),
                                    height: 66,
                                    width:
                                        MediaQuery.of(context).size.width - 120,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                              100, 100, 100, 0.4),
                                          blurRadius: 5,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                      //border: Border.all(color: Colors.black38),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Text('hail',
                                            style: TextStyle(
                                                fontSize: 35,
                                                color: Color.fromRGBO(
                                                    128, 176, 204, 1),
                                                fontFamily: 'MaterialIcons',
                                                shadows: [
                                                  BoxShadow(
                                                      color: Color.fromRGBO(
                                                          0, 185, 255, 0.5),
                                                      blurRadius: 12)
                                                ])),
                                        SizedBox(width: 6),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "From",
                                              style: GoogleFonts.ptSansCaption(
                                                color: Color.fromRGBO(
                                                    143, 143, 143, 1),
                                                fontSize: 13,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  196,
                                              child: MarqueeWidget(
                                                child: Text(
                                                    "${fromselectedobject.stopname}",
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: GoogleFonts.ptMono(
                                                      fontSize: 17,
                                                      color: Color.fromRGBO(
                                                          79, 79, 79, 1),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                              ),

                              //TO BOX BEGIN

                              GestureDetector(
                                onTap: () {
                                  fromBoxState.closeselectionpreview();
                                  fromBoxState.opentobox();
                                },
                                child: Container(
                                    margin: EdgeInsets.only(left: 18, top: 102),
                                    height: 66,
                                    width:
                                        MediaQuery.of(context).size.width - 120,
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Color.fromRGBO(
                                              100, 100, 100, 0.4),
                                          blurRadius: 5,
                                          offset: const Offset(0, 0),
                                        ),
                                      ],
                                      //border: Border.all(color: Colors.black38),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Text('place_outlined',
                                            style: TextStyle(
                                                fontSize: 35,
                                                color: Color.fromRGBO(
                                                    253, 122, 122, 1),
                                                fontFamily: 'MaterialIcons',
                                                shadows: [
                                                  BoxShadow(
                                                      color: Color.fromRGBO(
                                                          211, 61, 61, 0.5),
                                                      blurRadius: 12)
                                                ])),
                                        SizedBox(width: 6),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "To",
                                              style: GoogleFonts.ptSansCaption(
                                                color: Color.fromRGBO(
                                                    143, 143, 143, 1),
                                                fontSize: 13,
                                              ),
                                            ),
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  196,
                                              child: MarqueeWidget(
                                                child: Text(
                                                    "${toselectedobject.stopname}",
                                                    style: GoogleFonts.ptMono(
                                                      fontSize: 17,
                                                      color: Color.fromRGBO(
                                                          79, 79, 79, 1),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    )),
                              ),
                            ],
                          ),
                          Container(
                              padding: EdgeInsets.only(left: 10),
                              margin: EdgeInsets.only(left: 18, top: 15),
                              height: 71,
                              width: MediaQuery.of(context).size.width - 86,
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromRGBO(100, 100, 100, 0.4),
                                    blurRadius: 5,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                                //border: Border.all(color: Colors.black38),
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text('access_time_outlined',
                                      style: TextStyle(
                                          fontSize: 35,
                                          color: departorreach == "depart"
                                              ? Color.fromRGBO(83, 175, 229, 1)
                                              : Color.fromRGBO(
                                                  253, 122, 122, 1),
                                          fontFamily: 'MaterialIcons',
                                          shadows: [
                                            BoxShadow(
                                                color: departorreach == "depart"
                                                    ? Color.fromRGBO(
                                                        0, 252, 228, 0.5)
                                                    : Color.fromRGBO(
                                                        211, 61, 61, 0.5),
                                                blurRadius: 12)
                                          ])),
                                  SizedBox(width: 10),
                                  GestureDetector(
                                    onTap: () {
                                      toggledepartreach();
                                    },
                                    child: Container(
                                        height: 52,
                                        width: 76,
                                        decoration: BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color.fromRGBO(
                                                  100, 100, 100, 0.4),
                                              blurRadius: 5,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                          //border:Border.all(color: Colors.black38),
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Stack(
                                          children: [
                                            AnimatedContainer(
                                              duration:
                                                  Duration(milliseconds: 300),
                                              curve: Curves.fastOutSlowIn,
                                              height: 23,
                                              width: 70,
                                              margin: EdgeInsets.only(
                                                  left: 3,
                                                  top: departorreach == "depart"
                                                      ? 3
                                                      : 26),
                                              decoration: BoxDecoration(
                                                color: departorreach == "depart"
                                                    ? Color.fromRGBO(
                                                        83, 175, 229, 1)
                                                    : Color.fromRGBO(
                                                        253, 122, 122, 1),
                                                borderRadius:
                                                    BorderRadius.circular(9),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: departorreach ==
                                                            "depart"
                                                        ? Color.fromRGBO(
                                                            0, 252, 228, 0.5)
                                                        : Color.fromRGBO(
                                                            211, 61, 61, 0.5),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 0),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Column(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Center(
                                                  child: Text(
                                                    "Depart",
                                                    style: GoogleFonts.roboto(
                                                        color: departorreach ==
                                                                "depart"
                                                            ? Colors.white
                                                            : Color.fromRGBO(83,
                                                                175, 229, 1),
                                                        fontSize: 14.5,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                                SizedBox(height: 6),
                                                Text(
                                                  "Reach",
                                                  style: GoogleFonts.roboto(
                                                    color: departorreach ==
                                                            "depart"
                                                        ? Color.fromRGBO(
                                                            225, 135, 135, 1)
                                                        : Colors.white,
                                                    fontSize: 14.5,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        )),
                                  ),
                                  SizedBox(width: 10),
                                  MyTimePicker(),
                                  SizedBox(width: 25)
                                ],
                              )),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: fromBoxState.closeselectionpreview,
                                child: Container(
                                  margin: EdgeInsets.only(left: 18, top: 15),
                                  height: 61,
                                  width: 61,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color.fromRGBO(100, 100, 100, 0.4),
                                        blurRadius: 5,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                    //border: Border.all(color: Colors.black38),
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text('close_outlined',
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Colors.black87,
                                          fontFamily: 'MaterialIcons',
                                        )),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  search();
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 18, top: 15),
                                  height: 61,
                                  width:
                                      MediaQuery.of(context).size.width - 165,
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Color.fromRGBO(100, 100, 100, 0.4),
                                        blurRadius: 5,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                    //border: Border.all(color: Colors.black38),
                                    color: Color.fromRGBO(0, 0, 0, 0.75),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('search',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontFamily: 'MaterialIcons',
                                          )),
                                      SizedBox(width: 10),
                                      Text("Search buses",
                                          style: GoogleFonts.ptMono(
                                            fontSize: 15,
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ))
                  : SizedBox()),
        )
      ],
    );
  }
}

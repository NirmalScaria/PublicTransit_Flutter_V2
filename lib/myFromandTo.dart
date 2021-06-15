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
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'dart:async';
import 'dart:math';
import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';
import 'package:maps_curved_line/maps_curved_line.dart';

var fromname = " WHERE?";
var toname = "WHERE TO?";
late _MyFromBoxState fromBoxState;
late FocusNode fromfocusnode;
late FocusNode tofocusnode;
var isrotating=0;

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
  var latestrequest = 1;
  @override
  //Init state of the form boxes execute a get location command.
  //When location is got, then occurs the get response command towards server.
  //When response is got, he location value is updated.
  void initState() {
    super.initState();
    fromfocusnode = FocusNode();
    tofocusnode = FocusNode();
    BackButtonInterceptor.add(myInterceptor);

    location.getLocation().then((LocationData locationData) {});
    initDatabase(0.0, 0.0);
  }

  void openfrombox() async {
    isrotating=0;
    isqueryopen = 1;
    istofocused = 0;
    if (isfromfocused == 0) {
      setState(() {
        isfromfocused = 1;
      });
      onFromChanged(fromtyped);

      fromfocusnode.requestFocus();
      myFromController.selection = TextSelection.fromPosition(
          TextPosition(offset: myFromController.text.length));
    }
  }

  void selectionComplete(StopObject fromStopObject, StopObject toStopObject) async {
    developer.log("LATLNG");
    developer.log(fromStopObject.lat.toString());
    developer.log(fromStopObject.lng.toString());
    developer.log(toStopObject.lat.toString());
    developer.log(toStopObject.lng.toString());
    closequerybox();

    /*
List<PointLatLng> result = await polylinePoints.getRouteBetweenCoordinates(
         "AIzaSyBhtyzHMMICP1n4YnTPHG_W-09hua7nzXw",
         fromStopObject.lat, 
         fromStopObject.lng,
         toStopObject.lat, 
         toStopObject.lng);
*/
    List<PointLatLng> result = [
      PointLatLng(fromStopObject.lat, fromStopObject.lng),
      PointLatLng(toStopObject.lat, toStopObject.lng)
    ];
    if (result.isNotEmpty) {
      result.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    setState(() {
      iscardvisible = 0;
      Polyline polyline = Polyline(
        width: 4,
        zIndex: 500,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        polylineId: PolylineId("poly"),
        color: Colors.blue.shade300,
        points: [
            LatLng(fromStopObject.lat, fromStopObject.lng),
            LatLng(toStopObject.lat, toStopObject.lng)],
      );
      Polyline polyline2 = Polyline(
        width: 10,
        zIndex: 500,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        polylineId: PolylineId("poly2"),
        color: Colors.blue.shade100,
        points: [
            LatLng(fromStopObject.lat, fromStopObject.lng),
            LatLng(toStopObject.lat, toStopObject.lng)],
      );
      polylines.clear();

      polylines.add(polyline2);
      polylines.add(polyline);
    });
    FocusScope.of(context).unfocus();
    double airdistance = sqrt(pow(fromStopObject.lat - toStopObject.lat, 2) +
        pow(fromStopObject.lng - toStopObject.lng, 2));
    developer.log("AIR DISTANCe");
    developer.log(airdistance.toString());
    double zoomlevel = 13;
    if (airdistance > 0.04) zoomlevel = 12;
    if (airdistance > 0.08) zoomlevel = 11;
    if (airdistance > 0.16) zoomlevel = 10;
    if (airdistance > 0.32) zoomlevel = 9;
    if (airdistance > 0.64) zoomlevel = 8;
    if (airdistance > 1.28) zoomlevel = 7;
    if (airdistance > 2.56) zoomlevel = 6;
    if (airdistance > 5.12) zoomlevel = 5;
    if (airdistance > 10.24) zoomlevel = 4;
    zoomlevel = zoomlevel + 0.4;
    markers.clear();
    markers.add(Marker(
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        alpha: 0.9,
        markerId: MarkerId("origin"),
        position: LatLng(fromStopObject.lat, fromStopObject.lng)));
    markers.add(Marker(
      infoWindow: InfoWindow(title:"DEST", snippet: "Dest"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        alpha: 0.9,
        markerId: MarkerId("dest"),
        position: LatLng(toStopObject.lat, toStopObject.lng)));
        
    myMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          (fromStopObject.lat + toStopObject.lat) / 2 ,
          (fromStopObject.lng + toStopObject.lng) / 2,
        ),
        bearing:0,
        tilt:89,
        zoom: zoomlevel)));
        await Future.delayed(Duration(milliseconds: 1500));
        isrotating=1;
        keeprotating(fromStopObject, toStopObject, zoomlevel);
  }

Future<void> keeprotating(StopObject fromStopObject, StopObject toStopObject, double zoomlevel) async {
  for(int i=0;i<1000000&&isrotating==1;i++){
    myMapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          (fromStopObject.lat + toStopObject.lat) / 2,
          (fromStopObject.lng + toStopObject.lng) / 2,
        ),
        bearing:i*0.25,
        tilt:89,
        zoom: zoomlevel)));
        await Future.delayed(Duration(milliseconds: 50));
  }
}
  
  void selectedOrigin(var id) {
    fromselectedobject = fromolist[id];
    developer.log("SeLeCted from:");
    developer.log(fromolist[id].stopname);
    fromtyped = fromolist[id].stopname;
    myFromController.text = fromolist[id].stopname;
    myFromController.selection = TextSelection.fromPosition(
        TextPosition(offset: myFromController.text.length));

    fromid = fromolist[id].stopid;
    if (fromid == toid) {
      toid = 0;
      totyped = "";
      myToController.text = "";
      movetoto();
    } else {
      if (toid == 0) {
        movetoto();
      } else {
        developer.log("SELECTION COMPLETED");
        developer.log("ORIIGIN IS:");
        developer.log(fromselectedobject.stopname);
        developer.log("DEST is;");
        developer.log(toselectedobject.stopname);
        selectionComplete(fromselectedobject, toselectedobject);
      }
    }
  }

  Future<void> selectedDestination(var id) async {
    toselectedobject = toolist[id];
    developer.log("SeLeCted to:");
    developer.log(toolist[id].stopname);
    totyped = toolist[id].stopname;
    myToController.text = toolist[id].stopname;
    myToController.selection = TextSelection.fromPosition(
        TextPosition(offset: myToController.text.length));

    toid = toolist[id].stopid;
    if (toid == fromid) {
      fromid = 0;
      fromtyped = "";
      myFromController.text = "";
      fromname = "WHERE?";
      openfrombox();
    } else {
      if (fromid == 0) {
        fromtyped = "";
        myFromController.text = "";
        fromname = "WHERE?";
        openfrombox();
      } else {
        developer.log("SELECTION COMPLETED");
        developer.log("ORIIGIN IS:");
        developer.log(fromselectedobject.stopname);
        developer.log("DEST is;");
        developer.log(toselectedobject.stopname);
        selectionComplete(fromselectedobject, toselectedobject);
      }
    }
  }

  void onFromChanged(String xx) async {
    setState(() {
      fromtyped = xx == "0" ? "" : xx;
    });
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      Path.join(await getDatabasesPath(), 'stopsdatabase.db'),
      version: 1,
    );
    final db = await database;

    List<Map> result = await db.rawQuery(
        "select stopid,stopname,placeid, lat, lng, state from stops ${xx == "" ? "" : "where stopname like '$xx%'"} order by abs(${presentlat.toString()}-lat)+abs(${presentlong.toString()}-lng) asc limit 20");

    fromolist = [];
    suggestionWidgets = [];
    if (result.length != 0) {
      for (i = 0; i < result.length; i++) {
        setState(() {
          fromolist.add(new StopObject(
              lat: result[i]["lat"],
              lng: result[i]["lng"],
              stopname: result[i]["stopname"],
              stopid: result[i]["stopid"],
              placeid: result[i]["placeid"],
              district: result[i]["district"],
              state: result[i]["state"]));
        });
      }
      suggestionWidgets = [];

      //developer.log(fromolist.toString());
      for (i = 0; i < result.length; i++) {
        setState(() {
          suggestionWidgets.add(fromolist[i].stopid != 0
              ? Container(
                  //color: Colors.red,
                  child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 9),
                  //width: 200,
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
                                text: fromolist[i].stopname.length >
                                        fromtyped.length
                                    ? fromolist[i]
                                        .stopname
                                        .substring(0, fromtyped.length)
                                    : fromolist[i].stopname.toString(),
                                style: GoogleFonts.ptSansCaption(
                                    fontSize: 17,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700),
                                children: [
                              if (fromolist[i].stopname.length >
                                  fromtyped.length)
                                TextSpan(
                                    text: fromolist[i]
                                        .stopname
                                        .substring(fromtyped.length),
                                    style: GoogleFonts.ptSansCaption(
                                      fontSize: 17,
                                      color: Colors.black54,
                                      fontWeight: FontWeight.normal,
                                    )),
                            ])),
                      ),
                    ],
                  ),
                ))
              : SizedBox());
        });
      }
//developer.log(fromolist.toString());
      //developer.log(result.toString());
      //developer.log(result.length.toString());
      //developer.log(xx);
    } else {
      setState(() {
        suggestionWidgets = [];
        developer.log("NO RESULT");
        suggestionWidgets.add(Center(
            child: Text("No result found",
                style: GoogleFonts.ptSansCaption(
                    fontSize: 17,
                    color: Colors.black45,
                    fontWeight: FontWeight.w700))));
      });
    }
  }

  void closequerybox() async {
    setState(() {
      isqueryopen = 0;
      isfromfocused = 0;
      istofocused = 0;
    });
  }

  void movetoto() {
    if (isfromfocused == 1) {
      setState(() {
        isfromfocused = 0;
        istofocused = 1;
      });
    }
    onToChanged(totyped);
    tofocusnode.requestFocus();
    myToController.selection = TextSelection.fromPosition(
        TextPosition(offset: myToController.text.length));
  }

  void opentobox() async {
    isrotating=0;
    if (istofocused == 0) {
      setState(() {
        istofocused = 1;
        isqueryopen = 1;
      });
      onToChanged(totyped);
    }
    tofocusnode.requestFocus();
    myToController.selection = TextSelection.fromPosition(
        TextPosition(offset: myToController.text.length));
  }

  void onToChanged(String xx) async {
    setState(() {
      totyped = xx == "0" ? "" : xx;
    });
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      Path.join(await getDatabasesPath(), 'stopsdatabase.db'),
      version: 1,
    );
    final db = await database;

    List<Map> result = await db.rawQuery(
        "select stopid,stopname,placeid, lat, lng, state from stops ${xx == "" ? "" : "where stopname like '$xx%'"} order by abs(${presentlat.toString()}-lat)+abs(${presentlong.toString()}-lng) asc limit 20");

    toolist = [];
    suggestionWidgets = [];
    //developer.log(result.length.toString());
    if (result.length != 0) {
      for (i = 0; i < result.length; i++) {
        setState(() {
          toolist.add(new StopObject(
              lat: result[i]["lat"],
              lng: result[i]["lng"],
              stopname: result[i]["stopname"],
              stopid: result[i]["stopid"],
              placeid: result[i]["placeid"],
              district: result[i]["district"],
              state: result[i]["state"]));
        });
      }
      suggestionWidgets = [];

      //developer.log(fromolist.toString());
      for (i = 0; i < result.length; i++) {
        //developer.log(toolist[i].stopname);
        setState(() {
          suggestionWidgets.add(toolist[i].stopid != 0
              ? Container(
                  //color: Colors.red,
                  child: Container(
                  padding: EdgeInsets.only(top: 10, bottom: 9),
                  //width: 200,
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
                                    toolist[i].stopname.length > totyped.length
                                        ? toolist[i]
                                            .stopname
                                            .substring(0, totyped.length)
                                        : toolist[i].stopname.toString(),
                                style: GoogleFonts.ptSansCaption(
                                    fontSize: 17,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700),
                                children: [
                              if (toolist[i].stopname.length > totyped.length)
                                TextSpan(
                                    text: toolist[i]
                                        .stopname
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
                ))
              : SizedBox());
        });
      }
//developer.log(fromolist.toString());
      //developer.log(result.toString());
      //developer.log(result.length.toString());
      //developer.log(xx);
    } else {
      setState(() {
        suggestionWidgets = [];
        developer.log("NO RESULT");
        suggestionWidgets.add(Center(
            child: Text("No result found",
                style: GoogleFonts.ptSansCaption(
                    fontSize: 17,
                    color: Colors.black45,
                    fontWeight: FontWeight.w700))));
      });
    }
  }

  void dispose() {
    BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
  }

  bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    closequerybox();
    return true;
  }

  Future<String> initDatabase(double lat, double lng) async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      Path.join(await getDatabasesPath(), 'stopsdatabase.db'),
      onCreate: (db, version) {
        return db.execute(
          """CREATE TABLE stops(
        stopid INTEGER PRIMARY KEY, 
        stopname TEXT, 
        district TEXT,
        lat DOUBLE,
        lng DOUBLE,
        placeid TEXT,
        state TEXT)
      """,
        );
      },
      version: 1,
    );

    Future<void> insertStop(StopObject stop) async {
      final db = await database;
      await db.insert(
        'stops',
        stop.stopMapped(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }

    //CHECK IF DATABASE IS NOT UPDATED
    Future<int> checkStopUpdate() async {
      final db = await database;

      int? count = Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM stops'));
      //developer.log("TOTAL ROWS:");
      //developer.log(count.toString());
      if (count! < 200) {
        developer.log("UPDATING DATABASE");
        //developer.log((1000 - count).toString());
        //UPDATE DATABASE
        db.rawQuery('DELETE FROM stops');
        var url = Uri.parse("https://nirmalpoonattu.tk/api/findallstops.php");
        var response = await http
            .post(url, body: {"gx": lat.toString(), "gy": lng.toString()});
        //developer.log(response.body);
        var jsondecoded = jsonDecode(response.body);
        //developer.log(jsondecoded.length.toString());
        for (i = 0; i < jsondecoded.length; i++) {
          var myStop = StopObject(
              lat: jsondecoded[i]['lat'],
              lng: jsondecoded[i]['lng'],
              stopname: jsondecoded[i]['stopname'],
              stopid: jsondecoded[i]['stopid'],
              state: jsondecoded[i]['state'],
              district: jsondecoded[i]['district'],
              placeid: jsondecoded[i]['placeid']);
          await insertStop(myStop);
        }
      } else {
        //developer.log("DATABASE UP TO DATE");
      }
      return (0);
    }

    checkStopUpdate();

    Future<List<StopObject>> displayStops() async {
      final db = await database;

      final List<Map<String, dynamic>> maps = await db.query('stops');

      return List.generate(maps.length, (i) {
        return StopObject(
            stopid: maps[i]['stopid'],
            stopname: maps[i]['stopname'],
            lat: maps[i]['lat'],
            lng: maps[i]['lng'],
            district: maps[i]['district'],
            state: maps[i]['state'],
            placeid: maps[i]['placeid']);
      });
    }

    return ("DONE");
  }

//LOAD FUNCTION END

// FROM BOX START
  Future<String> setFromBoxLocation(double lat, double lng) async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      Path.join(await getDatabasesPath(), 'stopsdatabase.db'),
      version: 1,
    );
    final db = await database;

    List<Map> result = await db.rawQuery(
        "select stopid,stopname,placeid, lat, lng from stops order by abs(${presentlat.toString()}-lat)+abs(${presentlong.toString()}-lng) asc limit 20");

    setState(() {
      fromname = "" + result[0]["stopname"];
      fromid = result[0]["stopid"];
    });
    return ("done");
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 60, 20, 0),
      child: Stack(
        children: [
          NewFromSuggestionsBox(),
          if (isqueryopen == 0)
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
          if (isqueryopen == 0)
            //TO BOX THAT IS DISPLAYED ON MAP
            AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 500),
                margin: EdgeInsets.fromLTRB(10, 190, 10, 0),
                padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.zero,
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
                        opentobox();
                      },
                      child: AnimatedContainer(
                          curve: Curves.fastOutSlowIn,
                          duration: Duration(milliseconds: 500),
                          width: 290,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                            children: [
                              SizedBox(width: 10),
                              Icon(
                                Icons.location_on,
                              ),
                              SizedBox(width: 7),
                              Text("TO: ",
                                  style: TextStyle(
                                    fontSize: 17,
                                    color: Colors.black87,
                                  )),
                              Expanded(
                                child: TextField(
                                  enabled: false,
                                  textInputAction: TextInputAction.next,
                                  controller: myToController,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'WHERE?'),
                                  onTap: () {
                                    opentobox();
                                  },
                                ),
                              ),
                            ],
                          )),
                    ),
                  ],
                )),
          //FROMBOX ON MAP
          AnimatedContainer(
              curve: Curves.fastOutSlowIn,
              duration: Duration(milliseconds: 500),
              height: isqueryopen == 0 ? 50 : 125,
              margin: isqueryopen == 1
                  ? EdgeInsets.fromLTRB(0, 0, 0, 0)
                  : EdgeInsets.fromLTRB(10, 40, 10, 0),
              padding: isqueryopen == 0
                  ? EdgeInsets.fromLTRB(0, 0, 0, 0)
                  : EdgeInsets.fromLTRB(10, 10, 10, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: isqueryopen == 0
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
              child: SingleChildScrollView(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Stack(
                      children: [
                        AnimatedContainer(
                          curve: Curves.fastOutSlowIn,
                          duration: Duration(milliseconds: 500),
                          width: MediaQuery.of(context).size.width - 110,
                          height: 50,
                          margin:
                              EdgeInsets.only(top: istofocused == 0 ? 0 : 55),
                          decoration: BoxDecoration(
                              color: isqueryopen == 0
                                  ? Colors.white
                                  : Color.fromRGBO(150, 150, 150, 0.2),
                              borderRadius: isqueryopen != 0
                                  ? BorderRadius.circular(10)
                                  : BorderRadius.circular(0)),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GestureDetector(
                              onTap: () {
                                openfrombox();
                              },
                              child: AnimatedContainer(
                                  curve: Curves.fastOutSlowIn,
                                  duration: Duration(milliseconds: 500),
                                  width: 290,
                                  decoration: BoxDecoration(
                                      borderRadius: isqueryopen != 0
                                          ? BorderRadius.circular(10)
                                          : BorderRadius.circular(0)),
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
                                          focusNode: fromfocusnode,
                                          textInputAction: TextInputAction.next,
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
                            if (isqueryopen == 1) SizedBox(height: 08),
                            if (isqueryopen == 1)
                              GestureDetector(
                                onTap: () {
                                  openfrombox();
                                },
                                //TOBOX THAT COMES UP WHEN EDITING
                                child: AnimatedContainer(
                                    curve: Curves.fastOutSlowIn,
                                    duration: Duration(milliseconds: 500),
                                    width: 290,
                                    decoration: BoxDecoration(
                                        borderRadius: isqueryopen != 0
                                            ? BorderRadius.circular(10)
                                            : BorderRadius.circular(0)),
                                    child: Row(
                                      children: [
                                        SizedBox(width: 10),
                                        Icon(
                                          Icons.location_on,
                                        ),
                                        SizedBox(width: 7),
                                        Text("TO: ",
                                            style: TextStyle(
                                              fontSize: 17,
                                              color: Colors.black87,
                                            )),
                                        Expanded(
                                          child: TextField(
                                            focusNode: tofocusnode,
                                            textInputAction:
                                                TextInputAction.next,
                                            onChanged: (String xx) {
                                              onToChanged(xx);
                                            },
                                            controller: myToController,
                                            textCapitalization:
                                                TextCapitalization.characters,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText: 'WHERE?'),
                                            onTap: movetoto,
                                          ),
                                        ),
                                      ],
                                    )),
                              ),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        closequerybox();
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                          color: Colors.white,
                          height: 40,
                          width: 40,
                          child: isqueryopen == 0
                              ? SizedBox(width: 5)
                              : Icon(Icons.arrow_back)),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

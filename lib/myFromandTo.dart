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
import 'myToSuggestions.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';
import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

var closests = [" WHERE ?", " TO?"];
var fromname = " WHERE?";
int fromval = 0;
var toname = "WHERE TO?";
int toval = 0;
late _MyFromBoxState fromBoxState;
late FocusNode fromfocusnode;
late FocusNode tofocusnode;

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
    setState(() {
      closests[0] = " WHERE?";
      closests[1] = " TO?";
    });
    location.getLocation().then((LocationData locationData) {});
    initDatabase(0.0, 0.0);
  }

  void openfrombox() async {
    isqueryopen = 1;
    istofocusednew = 0;
    if (isfromfocused == 0) {
      items = [];
      counter = 0;
      setState(() {
        isfromfocused = 1;
        isfromfocused1 = 1;
      });
      WidgetsFlutterBinding.ensureInitialized();
      final database = openDatabase(
        Path.join(await getDatabasesPath(), 'stopsdatabase.db'),
        version: 1,
      );
      final db = await database;

      List<Map> result = await db.rawQuery(
          "select stopid,stopname,placeid, lat, lng, state from stops ${fromtyped == "" ? "" : "where stopname like '$fromtyped%'"} order by abs(${presentlat.toString()}-lat)+abs(${presentlong.toString()}-lng) asc limit 10");
      fromfocusnode.requestFocus();
      fromolist = [];
      newfrom = [];
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

            newfrom.add(fromolist[i].stopid != 0
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
                    ),
                  )
                : SizedBox());
          });
        }
      } else {
        newfrom.add(Center(
            child: Text("No result found",
                style: GoogleFonts.ptSansCaption(
                    fontSize: 17,
                    color: Colors.black45,
                    fontWeight: FontWeight.w700))));
      }
    }
  }

  void fromselected(var id) {
    fromselectedobject = fromolist[id];
    developer.log("SeLeCted from:");
    developer.log(fromolist[id].stopname);
    fromtyped=fromolist[id].stopname;
    myFromController.text=fromolist[id].stopname;
    movetoto();
  }

    void toselected(var id) {
    toselectedobject = toolist[id];
    developer.log("SeLeCted to:");
    developer.log(toolist[id].stopname);
    totyped=toolist[id].stopname;
    myToController.text=toolist[id].stopname;
    tofocusnode.requestFocus();
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
    newfrom = [];
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
      newfrom = [];

      //developer.log(fromolist.toString());
      for (i = 0; i < result.length; i++) {
        setState(() {
          newfrom.add(fromolist[i].stopid != 0
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
        newfrom = [];
        developer.log("NO RESULT");
        newfrom.add(Center(
            child: Text("No result found",
                style: GoogleFonts.ptSansCaption(
                    fontSize: 17,
                    color: Colors.black45,
                    fontWeight: FontWeight.w700))));
      });
    }
  }

  void closequerybox() async {
    isqueryopen = 0;
    if (isfromfocused == 1) {
      setState(() {
        isfromfocused1 = 0;
        isfromfocused = 0;
      });
    }
  }

  void movetoto() {
    if (isfromfocused == 1) {
      setState(() {
        isfromfocused = 0;
        istofocusednew = 1;
      });
    }
    onToChanged(totyped);
    tofocusnode.requestFocus();
  }



  void opentobox() async {
    if (istofocused == 0) {
      setState(() {
        istofocusednew = 1;
        isqueryopen = 1;
      });
      onToChanged(totyped);
    }
    await Future.delayed(Duration(milliseconds: 400));
    tofocusnode.requestFocus();
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
    newfrom = [];
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
      newfrom = [];

      //developer.log(fromolist.toString());
      for (i = 0; i < result.length; i++) {
        //developer.log(toolist[i].stopname);
        setState(() {
          newfrom.add(toolist[i].stopid != 0
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
        newfrom = [];
        developer.log("NO RESULT");
        newfrom.add(Center(
            child: Text("No result found",
                style: GoogleFonts.ptSansCaption(
                    fontSize: 17,
                    color: Colors.black45,
                    fontWeight: FontWeight.w700))));
      });
    }
  }

  void closetobox() async {
    if (istofocused == 1) {
      setState(() {
        istofocused1 = 0;
        istofocused = 0;
      });
      while (items.length > -1) {
        if (items.length < 1) return;

        listKeyTo.currentState?.removeItem(
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

/*
    closests[0] = " (LOADING)";
    var url = Uri.parse(
        "https://nirmalpoonattu.tk/api/findclosestjson.php");
    var response = await http
        .post(url, body: {"gx": lat.toString(), "gy": lng.toString()});
developer.log(response.body);
    setState(() {
      jsonClosests = jsonDecode(response.body);
      jsonClosestsTo = jsonDecode(response.body);
      fromname = "" + jsonClosests[0]["stopname"];
      fromval = jsonClosests[0]["stopid"];
      toname = "" + jsonClosests[1]["stopname"];
      toval = jsonClosests[1]["stopid"];
    });
    return ("done");
    */
    return ("DONE");
  }

//LOAD FUNCTION END

// FROM BOX START
  Future<String> setFromBoxLocation(double lat, double lng) async {
    closests[0] = " (LOADING)";

    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      Path.join(await getDatabasesPath(), 'stopsdatabase.db'),
      version: 1,
    );
    final db = await database;

    List<Map> result = await db.rawQuery(
        "select stopid,stopname,placeid, lat, lng from stops order by abs(${presentlat.toString()}-lat)+abs(${presentlong.toString()}-lng) asc limit 20");

    setState(() {
      jsonClosests = result;
      jsonClosestsTo = result;
      fromname = "" + jsonClosests[0]["stopname"];
      fromval = jsonClosests[0]["stopid"];
      toname = "" + jsonClosests[1]["stopname"];
      toval = jsonClosests[1]["stopid"];
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
                                  textInputAction: TextInputAction.next,
                                  onChanged: (String xx) {
                                    onToChanged(xx);
                                  },
                                  controller: myToController,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'WHERE?'),
                                  onTap: opentobox,
                                ),
                              ),
                            ],
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        closetobox();
                        FocusScope.of(context).unfocus();
                      },
                      child: Container(
                          color: Colors.white,
                          height: 40,
                          width: 40,
                          child: istofocused == 0
                              ? SizedBox(width: 5)
                              : Icon(Icons.arrow_back)),
                    )
                  ],
                )),
          Visibility(
            visible: istofocused == 0 ? true : false,
            child: AnimatedContainer(
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
                            margin: EdgeInsets.only(
                                top: istofocusednew == 0 ? 0 : 55),
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
                                            textInputAction:
                                                TextInputAction.next,
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
          ),
        ],
      ),
    );
  }
}

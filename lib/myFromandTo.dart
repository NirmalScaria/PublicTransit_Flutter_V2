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

import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';
import 'package:flutter/widgets.dart';

var closests = [" WHERE ?", " TO?"];
var fromname = " WHERE?";
int fromval = 0;
var toname = "WHERE TO?";
int toval = 0;
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
  var latestrequest = 1;
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
    initDatabase(0.0, 0.0);
  }

  void openfrombox() async {
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
          "select stopid,stopname,placeid, lat, lng, state from stops order by abs(${presentlat.toString()}-lat)+abs(${presentlong.toString()}-lng) asc limit 10");

      fromolist = [];
      newfrom = [];
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
              ? Text(fromolist[i].stopname)
              : SizedBox());
        });
      }
    }
  }

  void onFromChanged(String xx) async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      Path.join(await getDatabasesPath(), 'stopsdatabase.db'),
      version: 1,
    );
    final db = await database;

    List<Map> result = await db.rawQuery(
        "select stopid,stopname,placeid, lat, lng, state from stops ${xx == "" ? "" : "where stopname like '$xx%'"} order by abs(${presentlat.toString()}-lat)+abs(${presentlong.toString()}-lng) asc limit 10");

    fromolist = [];
    newfrom = [];
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
    newfrom=[];

    //developer.log(fromolist.toString());
for (i = 0; i < result.length; i++) {
  developer.log(fromolist[i].stopname);
  setState(() {
    newfrom.add(fromolist[i].stopid != 0
            ? Text(fromolist[i].stopname)
            : SizedBox());
  });
 
}
 print(newfrom[0]);
//developer.log(fromolist.toString());
    //developer.log(result.toString());
    //developer.log(result.length.toString());
    //developer.log(xx);





    setState(() {
      fromtyped = xx == "0" ? "" : xx;
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

  void movetoto() {
    if (isfromfocused == 1) {
      setState(() {
        isfromfocused1 = 0;
        isfromfocused = 0;
      });
    }
  }

  void toselected() {
    if (istofocused == 1) {
      setState(() {
        istofocused1 = 0;
        istofocused = 0;
      });
    }
  }

  void opentobox() async {
    if (istofocused == 0) {
      items = [];
      counter = 0;
      setState(() {
        istofocused = 1;
        istofocused1 = 1;
      });
      if (myToController.text.length > 0) {
        //onToChanged(totyped);
      } else {
        for (int i = 0; i < jsonClosestsTo.length; i++) {
          if (istofocused == 1) {
            setState(() {
              listKeyTo.currentState?.insertItem(items.length,
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
    onToChanged("");
  }

  void onToChanged(String xx) async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      Path.join(await getDatabasesPath(), 'stopsdatabase.db'),
      version: 1,
    );
    final db = await database;

    List<Map> result = await db.rawQuery(
        "select stopid,stopname,placeid, lat, lng from stops ${xx == "" ? "" : "where stopname like '$xx%'"} order by abs(${presentlat.toString()}-lat)+abs(${presentlong.toString()}-lng) asc limit 20");

    setState(() {
      listKeyTo.currentState?.insertItem(items.length,
          duration: const Duration(milliseconds: 800));
      items = []
        ..add(counter++)
        ..addAll(items);
    });

    setState(() {
      jsonClosestsTo = result;
      toname = "" + jsonClosestsTo[0]["stopname"];
      toval = jsonClosestsTo[0]["stopid"];
      lenofsuggestions = jsonClosestsTo.length;
    });

    setState(() {
      totyped = xx == "0" ? "" : xx;
    });
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
    closefrombox();
    return true;
  }

  Future<String> initDatabase(double lat, double lng) async {
    WidgetsFlutterBinding.ensureInitialized();
    final database = openDatabase(
      Path.join(await getDatabasesPath(), 'stopsdatabase.db'),
      onCreate: (db, version) {
        return db.execute(
          """CREATE TABLE stops(
        stopid INTEGER, 
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
      if (count! < 1000) {
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

    print(await displayStops());
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
          ToSuggestionsBox(),
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
            if (istofocused1 == 0)
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
            AnimatedContainer(
                curve: Curves.fastOutSlowIn,
                duration: Duration(milliseconds: 500),
                margin: istofocused == 1
                    ? EdgeInsets.fromLTRB(0, 0, 0, 0)
                    : EdgeInsets.fromLTRB(10, 190, 10, 0),
                padding: istofocused == 0
                    ? EdgeInsets.fromLTRB(0, 0, 0, 0)
                    : EdgeInsets.fromLTRB(10, 10, 10, 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: istofocused == 0
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
                        opentobox();
                      },
                      child: AnimatedContainer(
                          curve: Curves.fastOutSlowIn,
                          duration: Duration(milliseconds: 500),
                          width: 290,
                          decoration: BoxDecoration(
                              color: istofocused == 0
                                  ? Colors.white
                                  : Colors.black12,
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
                                      hintText: '$toname'),
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

          /*
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
*/

          Visibility(
            visible: istofocused == 0 ? true : false,
            child: AnimatedContainer(
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
                              borderRadius: isfromfocused != 0
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
          ),
        ],
      ),
    );
  }
}

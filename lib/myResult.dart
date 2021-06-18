import 'package:flutter/material.dart';
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
import 'package:loading_animations/loading_animations.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'mySelectionPreview.dart';
import 'package:dotted_line/dotted_line.dart';

late _ResultDetailsState resultDetailsState;

class ResultDetails extends StatefulWidget {
  const ResultDetails({Key? key}) : super(key: key);

  @override
  _ResultDetailsState createState() {
    resultDetailsState = _ResultDetailsState();
    return (resultDetailsState);
  }
}

class _ResultDetailsState extends State<ResultDetails> {
  
  @override
  Widget build(BuildContext context) {
    return Visibility(
        visible: showresultbox == 1 ? true : false,
        child: resultarrived == 0
            ? Align(
                alignment: Alignment.bottomCenter,
                child: AnimatedContainer(
                    duration: Duration(milliseconds: 1000),
                    curve: Curves.fastOutSlowIn,
                    margin: EdgeInsets.only(left: 20, right: 20, bottom: 30),
                    height: appstatus != "waitingforresult" ? 355 : 334,
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(255, 255, 255, 1),
                      borderRadius: BorderRadius.circular(23),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 17,
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: AnimatedOpacity(
                        duration: Duration(milliseconds: 1000),
                        opacity: appstatus == "waitingforresult" ? 1 : 0.1,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            LoadingFlipping.circle(
                              size: 25,
                              borderColor: Colors.blueAccent,
                            ),
                            SizedBox(height: 15),
                            DefaultTextStyle(
                              style: GoogleFonts.ptSansCaption(
                                  fontSize: 20,
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w700),
                              child: AnimatedTextKit(
                                repeatForever: true,
                                animatedTexts: [
                                  TypewriterAnimatedText('Finding routes...'),
                                  TypewriterAnimatedText('Hold on...'),
                                  TypewriterAnimatedText('Just a moment'),
                                ],
                              ),
                            ),
                          ],
                        ))),
              )
            : Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: EdgeInsets.only(left: 0, right: 0, bottom: 0),
                  height: 574,
                  width: MediaQuery.of(context).size.width,
                  child: PageView.builder(
                    //scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    itemCount: masterresponse.length,
                    controller: PageController(viewportFraction: 0.99),
                    onPageChanged: (int index) =>
                        setState(() => focusedtileid = index),
                    itemBuilder: (_, i) {
                      return Transform.scale(
                          //scale:isfromfocused == 0 ? ( i == focusedtileid ? 1 : 0.9 ): 0.01,
                          scale: i == focusedtileid ? 1 : 0.9,
                          child: Container(
                            margin: EdgeInsets.only(
                                top: masterresponse[i]['numberofsteps'] == 1
                                    ? 209
                                    : 20,
                                left: 20,
                                right: 20,
                                bottom: 10),
                            padding: EdgeInsets.all(20),
                            width: MediaQuery.of(context).size.width - 40,
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(255, 255, 255, 1),
                              borderRadius: BorderRadius.circular(23),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 17,
                                  offset: const Offset(0, 0),
                                ),
                              ],
                            ),

                            //CHILD CONTENT START
                            child: masterresponse[i]['numberofsteps'] == 1
                                ?

                                //CONTENT FOR SINGLE PATH
                                Column(children: [
                                    Row(
                                      children: [
                                        if (i == 0)
                                          Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  9, 5, 9, 5),
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      102, 230, 115, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(9)),
                                              child: Row(
                                                children: [
                                                  Text('access_time_outlined',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'MaterialIcons')),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    "Reach first",
                                                    style: GoogleFonts
                                                        .ptSansCaption(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                  ),
                                                ],
                                              )),
                                        if (i == 0) SizedBox(width: 9),
                                        Container(
                                            padding:
                                                EdgeInsets.fromLTRB(9, 5, 9, 5),
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    102, 230, 115, 1),
                                                borderRadius:
                                                    BorderRadius.circular(9)),
                                            child: Row(
                                              children: [
                                                Text('timeline',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'MaterialIcons')),
                                                SizedBox(width: 4),
                                                Text(
                                                  "Direct route",
                                                  style:
                                                      GoogleFonts.ptSansCaption(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                    SizedBox(height: 13),
                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(14, 14, 14, 14),
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                              /*
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                          */
                                          border: Border.all(color: Colors.black26)
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                SizedBox(
                                                  width: 90,
                                                  child: Text(
                                                    "${masterresponse[i]['getint']}",
                                                    style: GoogleFonts
                                                        .ptSansCaption(
                                                            color:
                                                                Color.fromRGBO(
                                                                    178,
                                                                    51,
                                                                    51,
                                                                    1),
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                ),
                                                Text('hail',
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        color: Color.fromRGBO(
                                                            0, 95, 152, 1),
                                                        fontFamily:
                                                            'MaterialIcons',
                                                        shadows: [
                                                          BoxShadow(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      185,
                                                                      255,
                                                                      0.5),
                                                              blurRadius: 12)
                                                        ])),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      250,
                                                  child: MarqueeWidget(
                                                    child: Text(
                                                      "${masterresponse[i]['getinp']}",
                                                      style: GoogleFonts
                                                          .ptSansCaption(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      79,
                                                                      79,
                                                                      79,
                                                                      1),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 110.5,
                                                ),
                                                DottedLine(
                                                  direction: Axis.vertical,
                                                  dashColor: Colors.grey,
                                                  dashLength: 4.0,
                                                  lineLength: 70,
                                                  lineThickness: 3,
                                                ),
                                                SizedBox(width: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "KSRTC",
                                                      style: GoogleFonts
                                                          .ptSansCaption(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      95,
                                                                      95,
                                                                      95,
                                                                      1),
                                                              fontSize: 27,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    Container(
                                                        constraints: BoxConstraints(
                                                            maxWidth: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                250),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                9, 5, 9, 5),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Color.fromRGBO(
                                                                    198,
                                                                    198,
                                                                    198,
                                                                    1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        9)),
                                                        child: MarqueeWidget(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "${masterresponse[i]['originofbus']}",
                                                                style: GoogleFonts.ptSansCaption(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                  'arrow_right',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'MaterialIcons')),
                                                              Text(
                                                                "${masterresponse[i]['destofbus']}",
                                                                style: GoogleFonts.ptSansCaption(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              )
                                                            ],
                                                          ),
                                                        ))
                                                  ],
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                SizedBox(
                                                  width: 90,
                                                  child: Text(
                                                    "${masterresponse[i]['getoutt']}",
                                                    style: GoogleFonts
                                                        .ptSansCaption(
                                                            color:
                                                                Color.fromRGBO(
                                                                    178,
                                                                    51,
                                                                    51,
                                                                    1),
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                ),
                                                Text('place_outlined',
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        color: Color.fromRGBO(
                                                            253, 122, 122, 1),
                                                        fontFamily:
                                                            'MaterialIcons',
                                                        shadows: [
                                                          BoxShadow(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      211,
                                                                      61,
                                                                      61,
                                                                      0.5),
                                                              blurRadius: 12)
                                                        ])),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      250,
                                                  child: MarqueeWidget(
                                                    child: Text(
                                                      "${masterresponse[i]['getoutp']}",
                                                      style: GoogleFonts
                                                          .ptSansCaption(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      79,
                                                                      79,
                                                                      79,
                                                                      1),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    padding: EdgeInsets.fromLTRB(
                                                        9, 5, 9, 5),
                                                    decoration: BoxDecoration(
                                                        color: masterresponse[i][
                                                                    'statuscode'] ==
                                                                "ok"
                                                            ? Color.fromRGBO(
                                                                102, 230, 115, 1)
                                                            : masterresponse[i]['statuscode'] ==
                                                                    "late"
                                                                ? Color.fromRGBO(
                                                                    225, 87, 87, 1)
                                                                : masterresponse[i]['statuscode'] ==
                                                                        "exp"
                                                                    ? Color.fromRGBO(
                                                                        230,
                                                                        195,
                                                                        102,
                                                                        1)
                                                                    : Color.fromRGBO(
                                                                        80, 80, 80, 1),
                                                        borderRadius:
                                                            BorderRadius.circular(9)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            masterresponse[i][
                                                                        'statuscode'] ==
                                                                    "late"
                                                                ? 'error_outlined'
                                                                : "radio_button_checked_outlined",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'MaterialIcons')),
                                                        SizedBox(width: 4),
                                                        Container(
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${masterresponse[i]['status'].split(' ')[0]}",
                                                                  style: GoogleFonts.ptSansCaption(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                                Text(
                                                                  "${masterresponse[i]['status'].substring(masterresponse[i]['status'].split(' ')[0].length + 1, masterresponse[i]['status'].length)}",
                                                                  style: GoogleFonts.ptSansCaption(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ]),
                                                        ),
                                                      ],
                                                    )),
                                                SizedBox(width: 10),
                                                Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            9, 5, 9, 5),
                                                    decoration: BoxDecoration(
                                                        color: masterresponse[i]['statuscode'] ==
                                                                "ok"
                                                            ? Color.fromRGBO(
                                                                102, 230, 115, 1)
                                                            : masterresponse[i]['statuscode'] ==
                                                                    "late"
                                                                ? Color.fromRGBO(
                                                                    102,
                                                                    230,
                                                                    115,
                                                                    1)
                                                                : masterresponse[i]['statuscode'] ==
                                                                        "exp"
                                                                    ? Color.fromRGBO(
                                                                        225,
                                                                        87,
                                                                        87,
                                                                        1)
                                                                    : Color.fromRGBO(
                                                                        80,
                                                                        80,
                                                                        80,
                                                                        1),
                                                        borderRadius:
                                                            BorderRadius.circular(9)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            masterresponse[i][
                                                                        'statuscode'] ==
                                                                    "exp"
                                                                ? 'thumb_down_outlined'
                                                                : "task_alt_outlined",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'MaterialIcons')),
                                                        SizedBox(width: 4),
                                                        Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                width: 60,
                                                                child:
                                                                    MarqueeWidget(
                                                                  child: Text(
                                                                    "Realtime tracking",
                                                                    style: GoogleFonts.ptSansCaption(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 60,
                                                                child:
                                                                    MarqueeWidget(
                                                                  child: Text(
                                                                    masterresponse[i]['statuscode'] ==
                                                                            "ok"
                                                                        ? "available"
                                                                        : masterresponse[i]['statuscode'] ==
                                                                                "late"
                                                                            ? "available"
                                                                            : "not available",
                                                                    style: GoogleFonts.ptSansCaption(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          ],
                                        )),
                                        Row(
                            children: [
                              GestureDetector(
                                onTap: fromBoxState.closequerybox,
                                child: Container(
                                  margin: EdgeInsets.only(left: 0, top: 15),
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
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 20, top: 15),
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
                                      Text('notifications_active',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontFamily: 'MaterialIcons',
                                          )),
                                      SizedBox(width: 10),
                                      Text("Get updates",
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
                                  ])
                                :
                                
                                
                                
                                
                                
                                // CONTENT FOR DOUBLE PATH
                                Column(children: [
                                    Row(
                                      children: [
                                        if (i == 0)
                                          Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  9, 5, 9, 5),
                                              decoration: BoxDecoration(
                                                  color: Color.fromRGBO(
                                                      102, 230, 115, 1),
                                                  borderRadius:
                                                      BorderRadius.circular(9)),
                                              child: Row(
                                                children: [
                                                  Text('access_time_outlined',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 15,
                                                          color: Colors.white,
                                                          fontFamily:
                                                              'MaterialIcons')),
                                                  SizedBox(width: 4),
                                                  Text(
                                                    "Reach first",
                                                    style: GoogleFonts
                                                        .ptSansCaption(
                                                            color: Colors.white,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600),
                                                  ),
                                                ],
                                              )),
                                        if (i == 0) SizedBox(width: 9),
                                        Container(
                                            padding:
                                                EdgeInsets.fromLTRB(9, 5, 9, 5),
                                            decoration: BoxDecoration(
                                                color: Color.fromRGBO(
                                                    102, 230, 115, 1),
                                                borderRadius:
                                                    BorderRadius.circular(9)),
                                            child: Row(
                                              children: [
                                                Text('link_outlined',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 15,
                                                        color: Colors.white,
                                                        fontFamily:
                                                            'MaterialIcons')),
                                                SizedBox(width: 4),
                                                Text(
                                                  "Connect route",
                                                  style:
                                                      GoogleFonts.ptSansCaption(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                    SizedBox(height: 13),

                                    Container(
                                        padding:
                                            EdgeInsets.fromLTRB(14, 14, 14, 14),
                                        decoration: BoxDecoration(
                                          color:
                                              Color.fromRGBO(255, 255, 255, 1),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                              /*
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 10,
                                              offset: const Offset(0, 0),
                                            ),
                                          ],
                                          */
                                          border: Border.all(color: Colors.black26)
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                SizedBox(
                                                  width: 90,
                                                  child: Text(
                                                    "${masterresponse[i]['getint'][0]}",
                                                    style: GoogleFonts
                                                        .ptSansCaption(
                                                            color:
                                                                Color.fromRGBO(
                                                                    178,
                                                                    51,
                                                                    51,
                                                                    1),
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                ),
                                                Text('hail',
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        color: Color.fromRGBO(
                                                            0, 95, 152, 1),
                                                        fontFamily:
                                                            'MaterialIcons',
                                                        shadows: [
                                                          BoxShadow(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      0,
                                                                      185,
                                                                      255,
                                                                      0.5),
                                                              blurRadius: 12)
                                                        ])),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      250,
                                                  child: MarqueeWidget(
                                                    child: Text(
                                                      "${masterresponse[i]['getinp'][0]}",
                                                      style: GoogleFonts
                                                          .ptSansCaption(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      79,
                                                                      79,
                                                                      79,
                                                                      1),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 110.5,
                                                ),
                                                DottedLine(
                                                  direction: Axis.vertical,
                                                  dashColor: Colors.grey,
                                                  dashLength: 4.0,
                                                  lineLength: 70,
                                                  lineThickness: 3,
                                                ),
                                                SizedBox(width: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "KSRTC",
                                                      style: GoogleFonts
                                                          .ptSansCaption(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      95,
                                                                      95,
                                                                      95,
                                                                      1),
                                                              fontSize: 27,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    Container(
                                                        constraints: BoxConstraints(
                                                            maxWidth: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                250),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                9, 5, 9, 5),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Color.fromRGBO(
                                                                    198,
                                                                    198,
                                                                    198,
                                                                    1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        9)),
                                                        child: MarqueeWidget(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "${masterresponse[i]['originofbus'][0]}",
                                                                style: GoogleFonts.ptSansCaption(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                  'arrow_right',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'MaterialIcons')),
                                                              Text(
                                                                "${masterresponse[i]['destofbus'][0]}",
                                                                style: GoogleFonts.ptSansCaption(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              )
                                                            ],
                                                          ),
                                                        ))
                                                  ],
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                SizedBox(
                                                  width: 90,
                                                  child: Text(
                                                    "${masterresponse[i]['getoutt'][0]}",
                                                    style: GoogleFonts
                                                        .ptSansCaption(
                                                            color:
                                                                Color.fromRGBO(
                                                                    178,
                                                                    51,
                                                                    51,
                                                                    1),
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                ),
                                                Text('radio_button_checked_outlined',
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        color: Color.fromRGBO(
                                                            204, 106, 216, 1),
                                                        fontFamily:
                                                            'MaterialIcons',
                                                        shadows: [
                                                          BoxShadow(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      204,
                                                                      106,
                                                                      216,
                                                                      0.59),
                                                              blurRadius: 12)
                                                        ])),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      250,
                                                  child: MarqueeWidget(
                                                    child: Text(
                                                      "${masterresponse[i]['getoutp'][0]}",
                                                      style: GoogleFonts
                                                          .ptSansCaption(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      79,
                                                                      79,
                                                                      79,
                                                                      1),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    padding: EdgeInsets.fromLTRB(
                                                        9, 5, 9, 5),
                                                    decoration: BoxDecoration(
                                                        color: masterresponse[i][
                                                                    'statuscode'][0] ==
                                                                "ok"
                                                            ? Color.fromRGBO(
                                                                102, 230, 115, 1)
                                                            : masterresponse[i]['statuscode'][0] ==
                                                                    "late"
                                                                ? Color.fromRGBO(
                                                                    225, 87, 87, 1)
                                                                : masterresponse[i]['statuscode'][0] ==
                                                                        "exp"
                                                                    ? Color.fromRGBO(
                                                                        230,
                                                                        195,
                                                                        102,
                                                                        1)
                                                                    : Color.fromRGBO(
                                                                        80, 80, 80, 1),
                                                        borderRadius:
                                                            BorderRadius.circular(9)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            masterresponse[i][
                                                                        'statuscode'][0] ==
                                                                    "late"
                                                                ? 'error_outlined'
                                                                : "radio_button_checked_outlined",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'MaterialIcons')),
                                                        SizedBox(width: 4),
                                                        Container(
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${masterresponse[i]['status'][0].split(' ')[0]}",
                                                                  style: GoogleFonts.ptSansCaption(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                                Text(
                                                                  "${masterresponse[i]['status'][0].substring(masterresponse[i]['status'][0].split(' ')[0].length + 1, masterresponse[i]['status'][0].length)}",
                                                                  style: GoogleFonts.ptSansCaption(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ]),
                                                        ),
                                                      ],
                                                    )),
                                                SizedBox(width: 10),
                                                Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            9, 5, 9, 5),
                                                    decoration: BoxDecoration(
                                                        color: masterresponse[i]['statuscode'][0] ==
                                                                "ok"
                                                            ? Color.fromRGBO(
                                                                102, 230, 115, 1)
                                                            : masterresponse[i]['statuscode'][0] ==
                                                                    "late"
                                                                ? Color.fromRGBO(
                                                                    102,
                                                                    230,
                                                                    115,
                                                                    1)
                                                                : masterresponse[i]['statuscode'][0] ==
                                                                        "exp"
                                                                    ? Color.fromRGBO(
                                                                        225,
                                                                        87,
                                                                        87,
                                                                        1)
                                                                    : Color.fromRGBO(
                                                                        80,
                                                                        80,
                                                                        80,
                                                                        1),
                                                        borderRadius:
                                                            BorderRadius.circular(9)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            masterresponse[i]['statuscode'][0] ==
                                                                    "exp"
                                                                ? 'thumb_down_outlined'
                                                                : "check_circle",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'MaterialIcons')),
                                                        SizedBox(width: 4),
                                                        Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                width: 60,
                                                                child:
                                                                    MarqueeWidget(
                                                                  child: Text(
                                                                    "Realtime tracking",
                                                                    style: GoogleFonts.ptSansCaption(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 60,
                                                                child:
                                                                    MarqueeWidget(
                                                                  child: Text(
                                                                    masterresponse[i]['statuscode'][0] ==
                                                                            "ok"
                                                                        ? "available"
                                                                        : masterresponse[i]['statuscode'][0] ==
                                                                                "late"
                                                                            ? "available"
                                                                            : "not available",
                                                                    style: GoogleFonts.ptSansCaption(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                                      ],
                                                    )),
                                              ],
                                            ),
                                          
                                        
                                        
                                        SizedBox(height:15),
                                        DottedLine(
                                                  direction: Axis.horizontal,
                                                  dashColor: Colors.grey,
                                                  dashLength: 4.0,
                                                  lineThickness: 3,
                                                ),
                                                SizedBox(height:10),
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                SizedBox(
                                                  width: 90,
                                                  child: Text(
                                                    "${masterresponse[i]['getint'][1]}",
                                                    style: GoogleFonts
                                                        .ptSansCaption(
                                                            color:
                                                                Color.fromRGBO(
                                                                    178,
                                                                    51,
                                                                    51,
                                                                    1),
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                ),
                                                Text('radio_button_checked_outlined',
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        color: Color.fromRGBO(
                                                            204, 106, 216, 1),
                                                        fontFamily:
                                                            'MaterialIcons',
                                                        shadows: [
                                                          BoxShadow(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      204,
                                                                      106,
                                                                      216,
                                                                      0.59),
                                                              blurRadius: 12)
                                                        ])),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      250,
                                                  child: MarqueeWidget(
                                                    child: Text(
                                                      "${masterresponse[i]['getinp'][1]}",
                                                      style: GoogleFonts
                                                          .ptSansCaption(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      79,
                                                                      79,
                                                                      79,
                                                                      1),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(
                                                  width: 110.5,
                                                ),
                                                DottedLine(
                                                  direction: Axis.vertical,
                                                  dashColor: Colors.grey,
                                                  dashLength: 4.0,
                                                  lineLength: 70,
                                                  lineThickness: 3,
                                                ),
                                                SizedBox(width: 20),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      "KSRTC",
                                                      style: GoogleFonts
                                                          .ptSansCaption(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      95,
                                                                      95,
                                                                      95,
                                                                      1),
                                                              fontSize: 27,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600),
                                                    ),
                                                    Container(
                                                        constraints: BoxConstraints(
                                                            maxWidth: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width -
                                                                250),
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                9, 5, 9, 5),
                                                        decoration: BoxDecoration(
                                                            color:
                                                                Color.fromRGBO(
                                                                    198,
                                                                    198,
                                                                    198,
                                                                    1),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        9)),
                                                        child: MarqueeWidget(
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "${masterresponse[i]['originofbus'][1]}",
                                                                style: GoogleFonts.ptSansCaption(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              ),
                                                              Text(
                                                                  'arrow_right',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                      fontSize:
                                                                          15,
                                                                      color: Colors
                                                                          .white,
                                                                      fontFamily:
                                                                          'MaterialIcons')),
                                                              Text(
                                                                "${masterresponse[i]['destofbus'][1]}",
                                                                style: GoogleFonts.ptSansCaption(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        12,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600),
                                                              )
                                                            ],
                                                          ),
                                                        ))
                                                  ],
                                                )
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(width: 10),
                                                SizedBox(
                                                  width: 90,
                                                  child: Text(
                                                    "${masterresponse[i]['getoutt'][1]}",
                                                    style: GoogleFonts
                                                        .ptSansCaption(
                                                            color:
                                                                Color.fromRGBO(
                                                                    178,
                                                                    51,
                                                                    51,
                                                                    1),
                                                            fontSize: 17,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                  ),
                                                ),
                                                Text('place_outlined',
                                                    style: TextStyle(
                                                        fontSize: 24,
                                                        color: Color.fromRGBO(
                                                            253, 122, 122, 1),
                                                        fontFamily:
                                                            'MaterialIcons',
                                                        shadows: [
                                                          BoxShadow(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      211,
                                                                      61,
                                                                      61,
                                                                      0.5),
                                                              blurRadius: 12)
                                                        ])),
                                                SizedBox(width: 10),
                                                Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      250,
                                                  child: MarqueeWidget(
                                                    child: Text(
                                                      "${masterresponse[i]['getoutp'][1]}",
                                                      style: GoogleFonts
                                                          .ptSansCaption(
                                                              color: Color
                                                                  .fromRGBO(
                                                                      79,
                                                                      79,
                                                                      79,
                                                                      1),
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w700),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                    padding: EdgeInsets.fromLTRB(
                                                        9, 5, 9, 5),
                                                    decoration: BoxDecoration(
                                                        color: masterresponse[i][
                                                                    'statuscode'][1] ==
                                                                "ok"
                                                            ? Color.fromRGBO(
                                                                102, 230, 115, 1)
                                                            : masterresponse[i]['statuscode'][1] ==
                                                                    "late"
                                                                ? Color.fromRGBO(
                                                                    225, 87, 87, 1)
                                                                : masterresponse[i]['statuscode'][1] ==
                                                                        "exp"
                                                                    ? Color.fromRGBO(
                                                                        230,
                                                                        195,
                                                                        102,
                                                                        1)
                                                                    : Color.fromRGBO(
                                                                        80, 80, 80, 1),
                                                        borderRadius:
                                                            BorderRadius.circular(9)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            masterresponse[i][
                                                                        'statuscode'][1] ==
                                                                    "late"
                                                                ? 'error_outlined'
                                                                : "radio_button_checked_outlined",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'MaterialIcons')),
                                                        SizedBox(width: 4),
                                                        Container(
                                                          child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${masterresponse[i]['status'][1].split(' ')[0]}",
                                                                  style: GoogleFonts.ptSansCaption(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                                Text(
                                                                  "${masterresponse[i]['status'][1].substring(masterresponse[i]['status'][1].split(' ')[0].length + 1, masterresponse[i]['status'][1].length)}",
                                                                  style: GoogleFonts.ptSansCaption(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          10,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600),
                                                                ),
                                                              ]),
                                                        ),
                                                      ],
                                                    )),
                                                SizedBox(width: 10),
                                                Container(
                                                    padding:
                                                        EdgeInsets.fromLTRB(
                                                            9, 5, 9, 5),
                                                    decoration: BoxDecoration(
                                                        color: masterresponse[i]['statuscode'][1] ==
                                                                "ok"
                                                            ? Color.fromRGBO(
                                                                102, 230, 115, 1)
                                                            : masterresponse[i]['statuscode'][1] ==
                                                                    "late"
                                                                ? Color.fromRGBO(
                                                                    102,
                                                                    230,
                                                                    115,
                                                                    1)
                                                                : masterresponse[i]['statuscode'][1] ==
                                                                        "exp"
                                                                    ? Color.fromRGBO(
                                                                        225,
                                                                        87,
                                                                        87,
                                                                        1)
                                                                    : Color.fromRGBO(
                                                                        80,
                                                                        80,
                                                                        80,
                                                                        1),
                                                        borderRadius:
                                                            BorderRadius.circular(9)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Text(
                                                            masterresponse[i]['statuscode'][1] ==
                                                                    "exp"
                                                                ? 'thumb_down_outlined'
                                                                : "check_circle",
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .white,
                                                                fontFamily:
                                                                    'MaterialIcons')),
                                                        SizedBox(width: 4),
                                                        Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                width: 60,
                                                                child:
                                                                    MarqueeWidget(
                                                                  child: Text(
                                                                    "Realtime tracking",
                                                                    style: GoogleFonts.ptSansCaption(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                width: 60,
                                                                child:
                                                                    MarqueeWidget(
                                                                  child: Text(
                                                                    masterresponse[i]['statuscode'][1] ==
                                                                            "ok"
                                                                        ? "available"
                                                                        : masterresponse[i]['statuscode'][1] ==
                                                                                "late"
                                                                            ? "available"
                                                                            : "not available",
                                                                    style: GoogleFonts.ptSansCaption(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            10,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              ),
                                                            ]),
                                                      ],
                                                    )),
                                              ],
                                            )
                                          ],
                                        )
                                        ),
                                       Row(
                            children: [
                              GestureDetector(
                                onTap: fromBoxState.closequerybox,
                                child: Container(
                                  margin: EdgeInsets.only(left: 0, top: 15),
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
                                },
                                child: Container(
                                  margin: EdgeInsets.only(left: 20, top: 15),
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
                                      Text('notifications_active',
                                          style: TextStyle(
                                            fontSize: 20,
                                            color: Colors.white,
                                            fontFamily: 'MaterialIcons',
                                          )),
                                      SizedBox(width: 10),
                                      Text("Get updates",
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
                                  ]),
                          ));
                    },
                  ),
                )));
  }
}

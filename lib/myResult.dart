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
import 'myResultPreview.dart';
import 'myResultproxy.dart';
import 'package:expandable/expandable.dart';

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
                    height: appstatus != "waitingforresult" ? 400 : 474,
                    width: MediaQuery.of(context).size.width,
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
            : 
            appstatus!="errorfromserver" ?
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 474,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(13, 20, 13, 0),
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(23),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 17,
                            offset: const Offset(0, 0),
                          ),
                        ]),


                        
                    
                        child: ListView.builder(
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            itemCount: masterresponse.length + 3,
                            itemBuilder: (_, index) => ResultProxy(
                                  itemid: index,
                                )),
                                
                    
                  ),
                ),
              )
              : 
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 474,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    padding: EdgeInsets.fromLTRB(13, 20, 13, 0),
                    width: MediaQuery.of(context).size.width - 40,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(23),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 17,
                            offset: const Offset(0, 0),
                          ),
                        ]),


                        
                    
                        child: GestureDetector(
                          onTap:(){
                            selectionPreviewState.search();
                          },
                                                  child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('refresh',
                                  style: TextStyle(
                                    fontSize: 50,
                                    color: Colors.blueAccent,
                                    fontFamily: 'MaterialIcons',
                                  )),
                              SizedBox(height: 15),
                              Text(
                                responseerror,
                                style: GoogleFonts.ptSansCaption(
                                    fontSize: 20,
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w700),
                                
                              ),
                            ],
                          ),
                        )
                                
                    
                  ),
                ),
              )
              
              )
              
              
              
              ;
  }
}

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
import 'myResult.dart';
import 'myResultDetails.dart';
import 'myResultDetailsDouble.dart';
import 'mySelectionPreview.dart';
class ResultPreview extends StatefulWidget {
  const ResultPreview({Key? key, required this.itemid}) : super(key: key);
  final int itemid;
  @override
  _ResultPreviewState createState() => _ResultPreviewState();
}

class _ResultPreviewState extends State<ResultPreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(top: 10),
        padding: EdgeInsets.all(17),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Color.fromRGBO(194, 194, 194, 1), width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('hail',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(2, 176, 240, 1),
                        fontFamily: 'MaterialIcons',
                        shadows: [
                          BoxShadow(
                              color: Color.fromRGBO(0, 185, 255, 0.5),
                              blurRadius: 12)
                        ])),
                Text('chevron_right_outlined',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(140, 140, 140, 1),
                      fontFamily: 'MaterialIcons',
                    )),
                Text('directions_bus',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(10, 10, 10, 1),
                      fontFamily: 'MaterialIcons',
                    )),
                Text('chevron_right_outlined',
                    style: TextStyle(
                      fontSize: 18,
                      color: Color.fromRGBO(140, 140, 140, 1),
                      fontFamily: 'MaterialIcons',
                    )),
                if (masterresponse[widget.itemid]["numberofsteps"] > 1)
                  Text('link',
                      style: TextStyle(
                          fontSize: 20,
                          color: Color.fromRGBO(158, 31, 115, 1),
                          fontFamily: 'MaterialIcons',
                          shadows: [
                            BoxShadow(
                                color: Color.fromRGBO(158, 31, 115, 0.5),
                                blurRadius: 12)
                          ])),
                if (masterresponse[widget.itemid]["numberofsteps"] > 1)
                  Text('chevron_right_outlined',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(140, 140, 140, 1),
                        fontFamily: 'MaterialIcons',
                      )),
                if (masterresponse[widget.itemid]["numberofsteps"] > 1)
                  Text('directions_bus',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(10, 10, 10, 1),
                        fontFamily: 'MaterialIcons',
                      )),
                if (masterresponse[widget.itemid]["numberofsteps"] > 1)
                  Text('chevron_right_outlined',
                      style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(140, 140, 140, 1),
                        fontFamily: 'MaterialIcons',
                      )),
                Text('place_outlined',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromRGBO(207, 11, 11, 1),
                        fontFamily: 'MaterialIcons',
                        shadows: [
                          BoxShadow(
                              color: Color.fromRGBO(207, 11, 11, 0.5),
                              blurRadius: 12)
                        ])),
                Spacer(),
                Text(
                  masterresponse[widget.itemid]['timedifference'],
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      color: Color.fromRGBO(10, 10, 10, 1),
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            //TITLE BAR COMPLETED
            SizedBox(height: 8),
            Row(
              children: [
                masterresponse[widget.itemid]["numberofsteps"] == 1
                    ?
                    //TAG FOR DIRECT BUS
                    Container(
                        padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(176, 209, 165, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Text('timeline',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'MaterialIcons',
                                )),
                            SizedBox(width: 5),
                            Text(
                              "Direct route",
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ))
                    :
                    //TAG FOR DIRECT BUS
                    Container(
                        padding: EdgeInsets.fromLTRB(7, 4, 7, 4),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(232, 207, 144, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Text('link',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                  fontFamily: 'MaterialIcons',
                                )),
                            SizedBox(width: 5),
                            Text(
                              "Change bus at ${masterresponse[widget.itemid]["getoutp"][0]}",
                              style: GoogleFonts.roboto(
                                  fontSize: 14,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ))
              ],
            ),
            SizedBox(height: 10),
            openedroute == widget.itemid ? 
            
            masterresponse[widget.itemid]['numberofsteps']==1 ? 
            
            ResultExpandedSingle(itemid:widget.itemid)

            :

            ResultExpandedDouble(itemid:widget.itemid)
            :
            Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 160),
                child: Text(
                  "${masterresponse[widget.itemid]["message"]}",
                  style: GoogleFonts.roboto(
                      fontSize: 12,
                      color: Color.fromRGBO(107, 107, 107, 1),
                      fontWeight: FontWeight.w400),
                )),
            SizedBox(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                RichText(
                    text: TextSpan(
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Color.fromRGBO(112, 112, 112, 1),
                            fontWeight: FontWeight.w700),
                        children: [
                      TextSpan(text: "Reach destination by "),
                      TextSpan(
                        text:
                            masterresponse[widget.itemid]["numberofsteps"] == 1
                                ? masterresponse[widget.itemid]["getoutt"]
                                : masterresponse[widget.itemid]["getoutt"][1],
                        style: GoogleFonts.roboto(
                            fontSize: 14,
                            color: Color.fromRGBO(41, 170, 21, 1),
                            fontWeight: FontWeight.w700),
                      )
                    ])),
                GestureDetector(
                  onTap: () {
                    if (openedroute == widget.itemid) {
                      resultDetailsState.setState(() {
                        openedroute = 999;
                      });
                    } else {
                      resultDetailsState.setState(() {
                        openedroute = widget.itemid;
                        selectionPreviewState.showOnMap(openedroute);
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 4, 10, 4),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(20, 20, 20, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Text(
                          openedroute == widget.itemid ? "Close" : "View",
                          style: GoogleFonts.roboto(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(width: 5),
                        Text(openedroute == widget.itemid ? 'expand_less' : 'expand_more',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontFamily: 'MaterialIcons',
                            )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}

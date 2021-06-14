import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'myGlobals.dart';
import 'package:google_fonts/google_fonts.dart';

class ToSuggestionsBox extends StatefulWidget {
  @override
  _ToSuggestionsBoxState createState() => _ToSuggestionsBoxState();
}

class _ToSuggestionsBoxState extends State<ToSuggestionsBox> {
  double _myheight = 10;
  @override
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AnimatedContainer(
        duration: Duration(milliseconds: 800),
        curve: Curves.fastOutSlowIn,
        margin: istofocused == 0
            ? EdgeInsets.only(top: 70, left: 10, right: 10)
            : EdgeInsets.only(top: 80),
        height:
            istofocused == 0 ? 0 : MediaQuery.of(context).size.height - 280,
        decoration: BoxDecoration(
          color: istofocused == 0
              ? Color.fromRGBO(255, 255, 255, 0.3)
              : Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: istofocused == 0
                  ? Color.fromRGBO(255, 255, 255, 0)
                  : Colors.black38,
              blurRadius: 17,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
      Container(
        height:istofocused == 0 ? 0 : MediaQuery.of(context).size.height - 280,
        margin:EdgeInsets.only(top: 80),
        padding: const EdgeInsets.all(25.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (istofocused1 == 1)
            Text(
              "Nearby",
              style: GoogleFonts.ptSansCaption(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: Color.fromRGBO(152, 152, 152, 1)),
            ),
          if (istofocused == 1) SizedBox(height: 8),
          Expanded(
            child: AnimatedList(
              physics: BouncingScrollPhysics(),
              key: listKeyTo,
              initialItemCount: 0,
              itemBuilder: (context, index, animation) {
                return Text("UNWANTEd");
                //return slideItTo(context, index, animation);
              },
            ),
          )

          /*
                Expanded(
                  child: AnimatedList(
                    key:listKey,
                      padding: EdgeInsets.all(8),
                      initialItemCount: 3,
                      itemBuilder: (context, index, animation) {
                        return SlideIt(
                          position:animation.drive(),
                                                child: Row(
                            children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: Colors.black87,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text("ERATTAYAR",
                                  style: GoogleFonts.ptSansCaption(
                                    fontSize: 17,
                                    color: Colors.black87,
                                  )),
                            ],
                          ),
                        );
                      },
                      ),
                )
                */
        ]),
      ),
    ]);
  }
}



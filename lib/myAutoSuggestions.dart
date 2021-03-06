import 'package:busmap2/myFromandTo.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'myGlobals.dart';
import 'package:google_fonts/google_fonts.dart';

class NewFromSuggestionsBox extends StatefulWidget {
  @override
  _NewFromSuggestionsBoxState createState() => _NewFromSuggestionsBoxState();
}

class _NewFromSuggestionsBoxState extends State<NewFromSuggestionsBox> {
  double _myheight = 10;
  @override
  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      AnimatedContainer(
        duration: Duration(milliseconds: 800),
        curve: Curves.fastOutSlowIn,
        margin: isqueryopen == 0
            ? EdgeInsets.only(top: 200, left: 10, right: 10)
            : EdgeInsets.only(top: 140),
        height:
            isqueryopen == 0 ? 0 : MediaQuery.of(context).size.height - 280,
        decoration: BoxDecoration(
          color: isqueryopen == 0
              ? Color.fromRGBO(255, 255, 255, 0.3)
              : Color.fromRGBO(255, 255, 255, 1),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: isqueryopen == 0
                  ? Color.fromRGBO(255, 255, 255, 0)
                  : Colors.black38,
              blurRadius: 17,
              offset: const Offset(0, 0),
            ),
          ],
        ),
      ),
      Container(
        height: isqueryopen == 0 ? 0 : MediaQuery.of(context).size.height - 280,
        margin: EdgeInsets.only(top: 140),
        padding: EdgeInsets.all(25.0),
        //ow,
        child: AnimatedOpacity(
          curve: Curves.easeIn,
          opacity: isqueryopen == 1 ? 1.0 : 0.0,
          duration: Duration(milliseconds: 1000),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            if (isqueryopen == 1)
              Text(
                "Nearby",
                style: GoogleFonts.ptSansCaption(
                    fontWeight: FontWeight.w900,
                    fontSize: 14,
                    color: Color.fromRGBO(152, 152, 152, 1)),
              ),
            if (isqueryopen == 1) SizedBox(height: 8),
            Container(
              height: MediaQuery.of(context).size.height - 400,
              child: ListView.builder(
                itemCount: suggestionWidgets.length,
                itemBuilder: (context, key){
                  return GestureDetector(
                    child: suggestionWidgets[key],
                    onTap: (){
                      if(istofocused==1){
                        fromBoxState.selectedDestination(key);
                      }
                        else{
                      fromBoxState.selectedOrigin(key);}
                    });
                },
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                padding: EdgeInsets.zero,
                
              ),
            ),
          ]),
        ),
      ),
    ]);
  }
}

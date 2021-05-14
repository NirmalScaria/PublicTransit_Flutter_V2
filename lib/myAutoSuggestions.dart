import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:decorated_icon/decorated_icon.dart';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'myGlobals.dart';

class FromSuggestionsBox extends StatefulWidget {
  @override
  _FromSuggestionsBoxState createState() => _FromSuggestionsBoxState();
}

class _FromSuggestionsBoxState extends State<FromSuggestionsBox> {
  double _myheight=10;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _myheight=10;
    });
    setState(() {
      _myheight=500;
    });
  }
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,

      child: AnimatedContainer(
          duration: Duration(milliseconds: 800),
          curve: Curves.fastOutSlowIn,
          margin: isfromfocused==0? EdgeInsets.only(top: 0, left:10, right:10) : EdgeInsets.only(top: 10),
          child: Text(""),
          height: isfromfocused==0? 0 : MediaQuery.of(context).size.height-280,
          decoration: BoxDecoration(
            
            color: isfromfocused==0? Color.fromRGBO(255, 255, 255, 0.3) : Color.fromRGBO(255, 255, 255, 1),
            borderRadius:  BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: isfromfocused==0? Color.fromRGBO(255, 255, 255, 0) : Colors.black38,
                blurRadius: 17,
                offset: const Offset(0, 0),
              ),
            ],
          )),
    );
  }
}

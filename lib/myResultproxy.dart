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
import 'myResultPreview.dart';

class ResultProxy extends StatefulWidget {
  const ResultProxy({Key? key, required this.itemid}) : super(key: key);
  final int itemid;
  @override
  _ResultProxyState createState() => _ResultProxyState();
}

class _ResultProxyState extends State<ResultProxy> {
  @override
  Widget build(BuildContext context) {
    return widget.itemid == 0
        ? Row(
            children: [
              SizedBox(width: 10),
              Text(
                "REACH FIRST",
                style: GoogleFonts.roboto(
                    fontSize: 14,
                    color: Color.fromRGBO(111, 111, 111, 1),
                    fontWeight: FontWeight.w700),
              ),
            ],
          )
        : widget.itemid == 1




            ? ResultPreview(itemid: 0)
            
            : widget.itemid == 2
                ? SizedBox(height: 10)
                : widget.itemid == 3
                    ? Row(
                        children: [
                          SizedBox(width: 10),
                          Text(
                            "OTHER ROUTES",
                            style: GoogleFonts.roboto(
                                fontSize: 14,
                                color: Color.fromRGBO(111, 111, 111, 1),
                                fontWeight: FontWeight.w700),
                          ),
                        ],
                      )
                    : ResultPreview(itemid: widget.itemid - 3);
  }
}

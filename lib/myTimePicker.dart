import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'myHome.dart';
import 'myFromandTo.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'myGlobals.dart';
import 'package:http/http.dart' as http;
import 'dart:developer' as developer;

import 'myFromandTo.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animated_button/flutter_animated_button.dart';
import 'package:date_format/date_format.dart';
import 'myGlobals.dart';
import 'package:flutter/material.dart';

class MyTimePicker extends StatefulWidget {
  const MyTimePicker({Key? key}) : super(key: key);

  @override
  _MyTimePickerState createState() => _MyTimePickerState();
}

class _MyTimePickerState extends State<MyTimePicker> {
  
  String? _hour, _minute, _time;

  String? dateTime;


  

  String _timeController = "${formatDate(DateTime(2021,1,11,TimeOfDay.now().hour,TimeOfDay.now().minute),[hh])}:${TimeOfDay.now().minute<10?"0":""}${TimeOfDay.now().minute} ${formatDate(DateTime(2021,1,11,TimeOfDay.now().hour,TimeOfDay.now().minute),[am])}";
           Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      helpText: "Enter $departorreach time",
      initialEntryMode: TimePickerEntryMode.input,
      context: context,
      initialTime: selectedTime,
    );
    fromBoxState.setState(() {
          isrotating = 1;
          fromBoxState.keeprotating(fromselectedobject, toselectedobject, zoomlevel);
          fromBoxState.keepmoving(fromselectedobject, toselectedobject, zoomlevel);
        });
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour! + ' : ' + _minute!;
        _timeController = _time!;
        _timeController = "${formatDate(DateTime(2021,1,11,picked.hour,picked.minute),[hh])}:${picked.minute<10?"0":""}${picked.minute} ${formatDate(DateTime(2021,1,11,picked.hour,picked.minute),[am])}";
           developer.log(selectedTime.minute.toString());
      });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        fromBoxState.setState(() {
          isrotating = 0;
        });
        _selectTime(context);
      },
      child: Text(_timeController,
          style: GoogleFonts.ptMono(
            fontSize: 25,
            color: Color.fromRGBO(79, 79, 79, 0.8),
            fontWeight: FontWeight.bold,
          )),
    );
  }
}

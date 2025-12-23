import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DropShadow {
  static const drop_thumb = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.1), // Shadow color and opacity
    offset: Offset(0, 10), // X, Y offset of the shadow
    blurRadius: 30, // The softness of the shadow
    spreadRadius: 0, // The extent to
  );

  static const drop_popup = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.1), // Shadow color and opacity
    offset: Offset(0, 10),
    blurRadius: 30,
    spreadRadius: 0,
  );

  static const drop_card = BoxShadow(
    color: Color.fromRGBO(0, 0, 0, 0.1), // Shadow color and opacity
    offset: Offset(0, 5),
    blurRadius: 10,
    spreadRadius: 0,
  );
}

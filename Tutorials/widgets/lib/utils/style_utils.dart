
import 'dart:ui';

import 'package:flutter/material.dart';

TextStyle getRequiredTextStyle ({
  Color textColor = Colors.black, FontWeight fontWeight = FontWeight.w300, FontStyle fontStyle = FontStyle.italic, double fontSize = 15,
}) {
  return TextStyle(
    fontFamily: "Regular",
    fontWeight: fontWeight,
    fontSize: fontSize,
    color: textColor
  );
}
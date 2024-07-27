import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

enum CustomFontWeight {
  light,
  normal,
  semiBold,
  bold,
}

enum CustomFontSize {
  smallDoubleExtra,
  smallTripleExtra,
  smallExtra,
  small,
  normal,
  large,
  largeExtra,
}

class CustomText extends StatelessWidget {

  const CustomText({
    super.key,
    required this.text,
    this.maxLines,
    this.customFontSize,
    this.customFontWeight,
    this.decoration,
    this.textColor,
    this.onTap,
    this.textAlignment,
    this.textOverflow,
  });

  final String text;
  final int? maxLines;
  final CustomFontSize? customFontSize;
  final CustomFontWeight? customFontWeight;
  final TextDecoration? decoration;
  final Color? textColor;
  final Function()? onTap;
  final TextAlign? textAlignment;
  final TextOverflow? textOverflow;

  @override
  Widget build(BuildContext context) {
    FontWeight fontWeight;
    if (customFontWeight == null) {
      fontWeight = FontWeight.w400;
    } else {
      if (customFontWeight == CustomFontWeight.light) {
        fontWeight = FontWeight.w200;
      } else if (customFontWeight == CustomFontWeight.semiBold) {
        fontWeight = FontWeight.w600;
      } else if (customFontWeight == CustomFontWeight.bold) {
        fontWeight = FontWeight.w800;
      } else {
        fontWeight = FontWeight.w400;
      }
    }

    double fontSize;
    if (customFontSize == null) {
      fontSize = 16.sp;
    } else {
      if (customFontSize == CustomFontSize.smallTripleExtra) {
        fontSize = 8.sp;
      } else if (customFontSize == CustomFontSize.smallDoubleExtra) {
        fontSize = 10.sp;
      } else if (customFontSize == CustomFontSize.smallExtra) {
        fontSize = 12.sp;
      } else if (customFontSize == CustomFontSize.small) {
        fontSize = 14.sp;
      } else if (customFontSize == CustomFontSize.large) {
        fontSize = 18.sp;
      } else if (customFontSize == CustomFontSize.largeExtra) {
        fontSize = 20.sp;
      } else {
        fontSize = 16.sp;
      }
    }

    return InkWell(
      onTap: onTap,
      child: Text(
        text,
        textAlign: textAlignment,
        maxLines: maxLines,
        overflow: textOverflow,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor,
          decoration: decoration,
        ),
      ),
    );
  }
}

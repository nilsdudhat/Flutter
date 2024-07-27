import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import '../constants/image_constants.dart';

class SquareLogo extends StatelessWidget {
  const SquareLogo({
    super.key,
    required this.size,
    this.padding,
    this.radius,
    this.backgroundColor,
    this.elevation,
  });

  final double size;
  final EdgeInsets? padding;
  final double? radius;
  final Color? backgroundColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor ?? ColorConstants.transparentColor,
      shape: OutlineInputBorder(
        borderSide: BorderSide(color: ColorConstants.transparentColor),
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 0)),
      ),
      elevation: elevation,
      child: Container(
        padding: padding,
        width: size,
        height: size,
        child: Image.asset(ImageConstants.logo),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../constants/color_constants.dart';

class CustomContainer extends Container {
  CustomContainer({
    super.key,
    this.width,
    this.height,
    this.radius,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.containerPadding,
    this.containerMargin,
    this.containerChild,
  });

  final double? width;
  final double? height;
  final double? radius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final EdgeInsets? containerPadding;
  final EdgeInsets? containerMargin;
  final Widget? containerChild;

  @override
  Clip get clipBehavior => Clip.hardEdge;

  @override
  BoxConstraints? get constraints => (width != null || height != null)
      ? super.constraints?.tighten(width: width, height: height) ??
          BoxConstraints.tightFor(width: width, height: height)
      : null;

  @override
  EdgeInsets get padding => containerPadding ?? const EdgeInsets.all(12);

  @override
  EdgeInsets get margin => containerMargin ?? EdgeInsets.zero;

  @override
  Widget? get child => containerChild;

  @override
  BoxDecoration get decoration => BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 12),
        color: backgroundColor ?? ColorConstants.whiteColor,
      );

  @override
  Decoration get foregroundDecoration => BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 12),
        border: (borderWidth == null)
            ? Border.all(
                color: borderColor ?? ColorConstants.primaryColor,
                width: 1,
              )
            : (borderWidth == 0)
                ? null
                : Border.all(
                    color: borderColor ?? ColorConstants.primaryColor,
                    width: borderWidth!,
                  ),
      );
}

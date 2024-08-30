import 'package:flutter/material.dart';

import '../constants/color_constants.dart';
import 'custom_text.dart';

class CustomLinearProgressIndicator extends StatelessWidget {
  const CustomLinearProgressIndicator({
    super.key,
    required this.percentage,
    required this.height,
    this.text,
  });

  final double percentage;
  final double height;
  final String? text;

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (text != null) {
      widget = Stack(
        children: [
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              double width = (constraints.maxWidth * percentage) / 100;
              return Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  const Spacer(),
                  Container(
                    width: width,
                    color: (percentage < 25)
                        ? ColorConstants.redColor
                        : ColorConstants.primaryLightColor,
                  ),
                ],
              );
            },
          ),
          Positioned.fill(
            top: 0,
            left: 0,
            bottom: 0,
            right: 0,
            child: Center(
              child: CustomText(
                text: text!,
                textColor: ColorConstants.whiteColor,
                textAlignment: TextAlign.center,
                customFontSize: CustomFontSize.normal,
                customFontWeight: CustomFontWeight.normal,
              ),
            ),
          ),
        ],
      );
    } else {
      widget = LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          double width = (constraints.maxWidth * percentage) / 100;
          return Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              Container(
                width: width,
                color: ColorConstants.primaryLightColor,
              ),
            ],
          );
        },
      );
    }

    return Container(
      color: ColorConstants.primaryDarkColor,
      height: height,
      child: widget,
    );
  }
}

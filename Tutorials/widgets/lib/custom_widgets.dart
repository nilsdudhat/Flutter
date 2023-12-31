import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  String btnName;
  Icon? icon;
  Color? bgColor;
  TextStyle? textStyle;
  VoidCallback? voidCallback;

  RoundedButton(
      {required this.btnName,
      this.icon,
      this.bgColor = Colors.blue,
      this.textStyle,
      this.voidCallback});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            shadowColor: bgColor,
            shape: RoundedRectangleBorder(
                // borderRadius: BorderRadius.circular(10)
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    topLeft: Radius.circular(10)))),
        onPressed: () {
          voidCallback!();
        },
        child: icon != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon!,
                  Container(
                    width: 5,
                  ),
                  Text(
                    btnName,
                    style: textStyle,
                  )
                ],
              )
            : Text(
                btnName,
                style: textStyle,
              ));
  }
}

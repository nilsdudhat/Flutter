import 'package:flutter/material.dart';

class CommonOutlinedButton extends StatefulWidget {
  const CommonOutlinedButton({
    super.key,
    required this.isFullWidth,
    required this.onPressed,
    required this.text,
    this.borderColor,
    this.borderWidth,
    this.splashColor,
    this.textColor,
    this.radius,
  });

  final Function() onPressed;
  final String text;

  /// to display full width button or not
  final bool isFullWidth;

  /// default: 1
  final double? borderWidth;

  /// default: Theme.of(context).colorScheme.primary
  final Color? borderColor;

  /// default: Theme.of(context).colorScheme.onPrimaryContainer
  final Color? splashColor;

  /// default: Theme.of(context).colorScheme.primary
  final Color? textColor;

  /// default: 45
  final double? radius;

  @override
  State<CommonOutlinedButton> createState() => _CommonOutlinedButtonState();
}

class _CommonOutlinedButtonState extends State<CommonOutlinedButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isFullWidth ? double.infinity : null,
      child: OutlinedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          side: MaterialStateProperty.all(BorderSide(
            color: widget.borderColor ?? Theme.of(context).colorScheme.primary,
            width: widget.borderWidth ?? 1,
          )),
          overlayColor: MaterialStateProperty.all(
              widget.splashColor ?? Theme.of(context).colorScheme.onPrimaryContainer),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 45))),
        ),
        child: Text(widget.text,
            style: TextStyle(
                color: widget.textColor ??
                    Theme.of(context).colorScheme.primary)),
      ),
    );
  }
}

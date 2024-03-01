import 'package:flutter/material.dart';

class CommonFilledButton extends StatefulWidget {
  const CommonFilledButton({
    super.key,
    required this.isFullWidth,
    required this.onPressed,
    required this.text,
    this.backgroundColor,
    this.splashColor,
    this.textColor,
    this.radius,
  });

  final Function() onPressed;
  final String text;

  /// to display full width button or not
  final bool isFullWidth;

  /// default: Theme.of(context).colorScheme.primary
  final Color? backgroundColor;

  /// default: Theme.of(context).colorScheme.inversePrimary
  final Color? splashColor;

  /// default: Theme.of(context).colorScheme.onPrimary
  final Color? textColor;

  /// default: 45
  final double? radius;

  @override
  State<CommonFilledButton> createState() => _CommonFilledButtonState();
}

class _CommonFilledButtonState extends State<CommonFilledButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.isFullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
              widget.backgroundColor ?? Theme.of(context).colorScheme.primary),
          overlayColor: MaterialStateProperty.all(widget.splashColor ??
              Theme.of(context).colorScheme.inversePrimary),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(widget.radius ?? 45))),
        ),
        child: Text(
          widget.text,
          style: TextStyle(
              color:
                  widget.textColor ?? Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:first_app/custom_widgets/gradient_container.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(
        body: GradientContainer([
          Colors.purpleAccent,
          Colors.deepPurpleAccent
        ])
      ),
    ),
  );
}

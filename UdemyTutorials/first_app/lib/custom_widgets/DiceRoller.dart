import 'dart:math';

import 'package:first_app/custom_widgets/styled_text.dart';
import 'package:flutter/material.dart';

class DiceRoller extends StatefulWidget {
  const DiceRoller({super.key});

  @override
  State<DiceRoller> createState() {
    return _DiceRollerState();
  }
}

class _DiceRollerState extends State<DiceRoller> {
  String activeDiceImagePath = "assets/images/dice-1.png";
  final Random random = Random();

  void rollDice() {
    var randomNumber = random.nextInt(6) + 1;
    setState(() {
      activeDiceImagePath = "assets/images/dice-$randomNumber.png";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(activeDiceImagePath, width: 200),
        const SizedBox(height: 28),
        TextButton(
          onPressed: rollDice,
          style: TextButton.styleFrom(
            // padding: const EdgeInsets.only(top: 28),
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 28)),
          child: const StyledText('Roll Dice'),
        )
      ],
    );
  }
}
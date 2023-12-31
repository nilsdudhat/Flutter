import 'package:flutter/material.dart';

class MealItemData extends StatelessWidget {
  final IconData iconData;
  final String label;

  const MealItemData({super.key, required this.label, required this.iconData});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          iconData,
          size: 16,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall!.copyWith(
              color: Theme.of(context).colorScheme.onPrimaryContainer),
        ),
      ],
    );
  }
}

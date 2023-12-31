import 'package:flutter/material.dart';
import 'package:meals/models/category_model.dart';
import 'package:meals/models/meals_model.dart';

class CategoryItem extends StatelessWidget {
  final CategoryModel category;
  final void Function() onSelectCategory;

  const CategoryItem({super.key, required this.category, required this.onSelectCategory});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onSelectCategory,
        splashColor: Theme.of(context).primaryColor,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              category.color.withOpacity(0.55),
              category.color.withOpacity(0.90)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Text(
            category.title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
        ),
      ),
    );
  }
}

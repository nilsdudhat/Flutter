import 'package:flutter/material.dart';
import 'package:meals/models/meals_model.dart';
import 'package:meals/screens/meal_details_screen.dart';
import 'package:meals/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  final String? title;
  final List<MealModel> mealList;

  const MealsScreen({super.key,
    this.title,
    required this.mealList,});

  void _onSelectMeal(BuildContext context, MealModel mealModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            MealDetailScreen(
                mealModel: mealModel
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Uh Oh.... nothing found!",
            style: Theme
                .of(context)
                .textTheme
                .headlineLarge!
                .copyWith(
              color: Theme
                  .of(context)
                  .colorScheme
                  .onSecondaryContainer,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            "Try selecting a different Category!",
            style: Theme
                .of(context)
                .textTheme
                .titleLarge!
                .copyWith(
              color: Theme
                  .of(context)
                  .colorScheme
                  .onSecondaryContainer,
            ),
          ),
        ],
      ),
    );

    if (mealList.isNotEmpty) {
      content = ListView.builder(
          itemCount: mealList.length,
          itemBuilder: (context, index) {
            return MealItem(
              mealModel: mealList[index],
              onSelectMeal: (mealModel) {
                _onSelectMeal(context, mealModel);
              },
            );
          });
    }

    if (title == null) {
      return content;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text(title!),
        ),
        body: content);
  }
}

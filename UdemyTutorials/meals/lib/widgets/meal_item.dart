import 'package:flutter/material.dart';
import 'package:meals/models/meals_model.dart';
import 'package:meals/widgets/meal_item_data.dart';
import 'package:transparent_image/transparent_image.dart';

class MealItem extends StatelessWidget {
  final MealModel mealModel;
  final void Function(MealModel mealModel) onSelectMeal;

  const MealItem(
      {super.key, required this.mealModel, required this.onSelectMeal});

  String firstLetterCapitalised(String name) {
    return name[0].toUpperCase() + name.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    String affordabilityText =
        firstLetterCapitalised(mealModel.affordability.name);
    String complexityText = firstLetterCapitalised(mealModel.complexity.name);

    return Card(
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      clipBehavior: Clip.hardEdge,
      elevation: 2,
      child: InkWell(
        onTap: () {
          onSelectMeal(mealModel);
        },
        child: Stack(
          children: [
            Hero(
              tag: mealModel.id,
              child: FadeInImage(
                placeholder: MemoryImage(kTransparentImage),
                image: NetworkImage(mealModel.imageUrl),
                height: MediaQuery.of(context).size.height * 0.4,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.black54,
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 64),
                child: Column(
                  children: [
                    Text(
                      mealModel.title,
                      maxLines: 2,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSecondaryContainer),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        MealItemData(
                          label: "${mealModel.duration} min",
                          iconData: Icons.schedule,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        MealItemData(
                          label: affordabilityText,
                          iconData: Icons.work,
                        ),
                        const SizedBox(
                          width: 16,
                        ),
                        MealItemData(
                          label: complexityText,
                          iconData: Icons.attach_money,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

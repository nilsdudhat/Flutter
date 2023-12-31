import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/meals_model.dart';

class FavoriteMealsNotifier extends StateNotifier<List<MealModel>> {
  FavoriteMealsNotifier() : super([]);

  bool updateFavoriteMeals(MealModel mealModel) {
    final isMealFavorite = state.contains(mealModel);

    if (isMealFavorite) {
      state = state.where((element) => element.id != mealModel.id).toList();
      return false;
    } else {
      state = [...state, mealModel];
      return true;
    }
  }
}

final favoriteMealsProvider =
    StateNotifierProvider<FavoriteMealsNotifier, List<MealModel>>((ref) {
  return FavoriteMealsNotifier();
});

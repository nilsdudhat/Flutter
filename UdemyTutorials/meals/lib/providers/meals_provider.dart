import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/models/category_model.dart';

final mealsProvider = Provider(
  (ref) {
    return dummyMeals;
  },
);

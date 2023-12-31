import 'package:shopping/models/category_model.dart';

class GroceryModel {
  final String id;
  final String name;
  final int quantity;
  final Category category;

  const GroceryModel({required this.id, required this.name, required this.quantity, required this.category});
}

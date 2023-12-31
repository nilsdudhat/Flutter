import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

final formatter = DateFormat.yMd();

enum Category {
  food,
  travel,
  leisure,
  work,
}

Map categoryIcons = {
  Category.food: Icons.emoji_food_beverage,
  Category.travel: Icons.travel_explore,
  Category.leisure: Icons.movie_filter_outlined,
  Category.work: Icons.work_outlined
};

class ExpenseModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final Category category;

  ExpenseModel(
      {required this.title,
      required this.amount,
      required this.date,
      required this.category})
      : id = uuid.v4();

  String get formattedDate {
    return formatter.format(date);
  }
}

class ExpenseBucket {
  final Category category;
  final List<ExpenseModel> categoryExpenseList;

  ExpenseBucket.forCategory({
    required this.category,
    required List<ExpenseModel> expenseList,
  }) : categoryExpenseList = expenseList.where(
          (element) {
            if (element.category == category) {
              return true;
            }
            return false;
          },
        ).toList();

  ExpenseBucket({required this.category, required this.categoryExpenseList});

  double get totalExpenses {
    double sum = 0;

    for (final expense in categoryExpenseList) {
      sum += expense.amount;
    }

    return sum;
  }
}

import 'package:expense_tracker/models/expense_model.dart';
import 'package:flutter/material.dart';

class ExpenseItem extends StatelessWidget {
  final ExpenseModel _expenseModel;

  const ExpenseItem({super.key, required ExpenseModel expenseModel})
      : _expenseModel = expenseModel;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_expenseModel.title, style: Theme.of(context).textTheme.titleLarge,),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Text("\$${_expenseModel.amount.toStringAsFixed(2)}"),
                const Spacer(),
                Row(
                  children: [
                    Icon(categoryIcons[_expenseModel.category]),
                    Text(_expenseModel.formattedDate)
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

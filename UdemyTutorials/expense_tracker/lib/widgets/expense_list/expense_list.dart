import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/widgets/expense_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpenseList extends StatelessWidget {
  final List<ExpenseModel> _expenseList;
  final void Function(ExpenseModel expenseModel, bool isAdd) updateList;

  const ExpenseList(
      {super.key,
      required List<ExpenseModel> expenseList,
      required this.updateList})
      : _expenseList = expenseList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: _expenseList.length,
        itemBuilder: (ctx, index) {
          return Dismissible(
            key: ValueKey(_expenseList[index]),
            direction: DismissDirection.startToEnd,
            background: Card(
              margin: Theme.of(context).cardTheme.margin,
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Container(
                padding: const EdgeInsets.only(left: 16),
                alignment: AlignmentDirectional.centerStart,
                child: const Icon(
                  Icons.delete,
                  color: Colors.redAccent,
                ),
              ),
            ),
            child: ExpenseItem(
              expenseModel: _expenseList[index],
            ),
            onDismissed: (direction) {
              updateList(_expenseList[index], false);
            },
          );
        });
  }
}

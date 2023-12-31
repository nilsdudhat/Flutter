import 'package:expense_tracker/models/expense_model.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/create_expense.dart';
import 'package:expense_tracker/widgets/expense_list/expense_list.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<ExpenseModel> _registeredList = [
    ExpenseModel(
        title: "Flutter Course",
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    ExpenseModel(
        title: "Cinema",
        amount: 15.69,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void updateList(ExpenseModel expenseModel, bool isAdd) {
    int expenseIndex = _registeredList.indexOf(expenseModel);

    setState(() {
      if (isAdd) {
        _registeredList.add(expenseModel);
      } else {
        _registeredList.remove(expenseModel);
      }
    });

    if (!isAdd) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Expense Deleted"),
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: "Undo",
            onPressed: () {
              setState(() {
                _registeredList.insert(expenseIndex, expenseModel);
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final aspect = MediaQuery.of(context).size.aspectRatio;

    Widget dataWidget = const Center(
      child: Text("No expenses found... Start Adding some!"),
    );

    if (_registeredList.isNotEmpty) {
      dataWidget =
          ExpenseList(expenseList: _registeredList, updateList: updateList);
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        actions: [
          IconButton(onPressed: _addExpense, icon: const Icon(Icons.add))
        ],
      ),
      body: (aspect < 1)
          ? SizedBox(
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Chart(expenses: _registeredList),
                  Expanded(child: dataWidget),
                ],
              ),
            )
          : Row(
              children: [
                Expanded(child: Chart(expenses: _registeredList)),
                Expanded(child: dataWidget),
              ],
            ),
    );
  }

  void _addExpense() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return CreateExpense(updateList);
      },
    );
  }
}

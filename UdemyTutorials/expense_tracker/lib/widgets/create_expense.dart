import 'dart:io';

import 'package:expense_tracker/models/expense_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateExpense extends StatefulWidget {
  final void Function(ExpenseModel expenseModel, bool isAdd) updateList;

  const CreateExpense(this.updateList, {super.key});

  @override
  State<CreateExpense> createState() => _CreateExpenseState();
}

class _CreateExpenseState extends State<CreateExpense> {
  final _titleEditingController = TextEditingController();
  final _amountEditingController = TextEditingController();
  var _selectedCategory = Category.leisure;

  DateTime? _selectedDate;

  void _showDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    var selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );

    setState(() {
      _selectedDate = selectedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Invalid Input"),
            content: const Text(
                "Please make sure a valid title, amount, date and category was entered"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Okay"),
              )
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text(
              "Please make sure a valid title, amount, date and category was entered"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Okay"),
            )
          ],
        ),
      );
    }
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountEditingController.text);
    final isEnteredAmountIsValid = enteredAmount == null || enteredAmount <= 0;

    if (_titleEditingController.text.trim().isEmpty ||
        isEnteredAmountIsValid ||
        _selectedDate == null) {
      // show error message
      _showDialog();
      return;
    }

    final expenseModel = ExpenseModel(
        title: _titleEditingController.text.trim(),
        amount: enteredAmount,
        date: _selectedDate!,
        category: _selectedCategory);
    widget.updateList(expenseModel, true);

    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleEditingController.dispose();
    _amountEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyBoardHeight = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double width = constraints.maxWidth;
        double height = constraints.maxHeight;
        double aspect = width / height;

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: 16, right: 16, bottom: keyBoardHeight + 16, left: 16),
              child: Column(
                children: [
                  TextField(
                    maxLength: 50,
                    controller: _titleEditingController,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                      label: Text("Title"),
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _amountEditingController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            label: Text("Amount"),
                            prefixText: "\$ ",
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      if (aspect >= 1)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            DropdownButton(
                                value: _selectedCategory,
                                items: Category.values
                                    .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name.toUpperCase())))
                                    .toList(),
                                onChanged: (value) {
                                  if (value == null) {
                                    return;
                                  }
                                  setState(() {
                                    _selectedCategory = value;
                                  });
                                }),
                            const SizedBox(
                              width: 16,
                            ),
                          ],
                        ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text((_selectedDate == null)
                                ? "No Date Selected"
                                : formatter.format(_selectedDate!).toString()),
                            IconButton(
                              onPressed: _showDatePicker,
                              icon: const Icon(Icons.calendar_month),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  Row(
                    children: [
                      if (aspect < 1)
                        DropdownButton(
                            value: _selectedCategory,
                            items: Category.values
                                .map((category) => DropdownMenuItem(
                                    value: category,
                                    child: Text(category.name.toUpperCase())))
                                .toList(),
                            onChanged: (value) {
                              if (value == null) {
                                return;
                              }
                              setState(() {
                                _selectedCategory = value;
                              });
                            }),
                      const Spacer(),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel")),
                      const SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: _submitExpenseData,
                        child: const Text("Create Expense"),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

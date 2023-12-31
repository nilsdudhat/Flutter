import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/data/category_list.dart';
import 'package:shopping/models/category_model.dart';
import 'package:shopping/models/grocery_model.dart';

class CreateNewGroceryScreen extends StatefulWidget {
  const CreateNewGroceryScreen({super.key});

  @override
  State<CreateNewGroceryScreen> createState() => _CreateNewGroceryScreenState();
}

class _CreateNewGroceryScreenState extends State<CreateNewGroceryScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isSending = false;

  var _quantity = 1;
  var _name = "";
  var _selectedCategory = category_list[Categories.vegetables]!;

  void _saveItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      setState(() {
        _isSending = true;
      });

      final url = Uri.https(
          "udemy-tutorial-grocery-default-rtdb.firebaseio.com",
          "grocery-list.json");

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: json.encode(
            {
              "name": _name,
              "quantity": _quantity,
              "category": _selectedCategory.category,
            },
          ),
        );

        final Map<String, dynamic> responseBody = json.decode(response.body);

        if (context.mounted) {
          Navigator.pop(
              context,
              GroceryModel(
                  id: responseBody["name"],
                  name: _name,
                  quantity: _quantity,
                  category: _selectedCategory));
        }
      } catch (exception) {
        print(exception);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Failed to create Category"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a new item"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text("Name"),
                ),
                validator: (value) {
                  if ((value == null) ||
                      (value.isEmpty) ||
                      (value.trim().length <= 1) ||
                      (value.trim().length > 50)) {
                    return "Must be between 1 and 50 characters";
                  }
                  return null;
                },
                onSaved: (value) {
                  _name = value!;
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text("Quantity"),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: _quantity.toString(),
                      validator: (value) {
                        if ((value == null) ||
                            (value.isEmpty) ||
                            (int.tryParse(value) == null) ||
                            (int.tryParse(value)! <= 0)) {
                          return "Must be a valid positive number";
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _quantity = int.parse(value!);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedCategory,
                      items: [
                        for (final category in category_list.entries)
                          DropdownMenuItem(
                              value: category.value,
                              child: Row(
                                children: [
                                  Container(
                                    width: 16,
                                    height: 16,
                                    color: category.value.color,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(category.value.category),
                                ],
                              ))
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedCategory = value!;
                        });
                      },
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: _isSending
                        ? null
                        : () {
                            _formKey.currentState!.reset();
                          },
                    child: const Text("Reset"),
                  ),
                  ElevatedButton(
                    onPressed: _saveItem,
                    child: _isSending
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(),
                          )
                        : const Text("Add Item"),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

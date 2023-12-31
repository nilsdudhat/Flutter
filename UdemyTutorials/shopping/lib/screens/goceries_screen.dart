import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shopping/data/category_list.dart';
import 'package:shopping/models/grocery_model.dart';
import 'package:shopping/screens/create_new_grocery_screen.dart';

class GroceriesScreen extends StatefulWidget {
  const GroceriesScreen({super.key});

  @override
  State<GroceriesScreen> createState() => _GroceriesScreenState();
}

class _GroceriesScreenState extends State<GroceriesScreen> {
  List<GroceryModel> groceryList = [];

  var _isLoading = true;
  String? _errorMessage;

  void _loadGroceryList() async {
    final url = Uri.https("udemy-tutorial-grocery-default-rtdb.firebaseio.com",
        "grocery-list.json");

    try {
      final response = await http.get(url);
      if (response.body == "null") {
        setState(() {
          _isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> groceriesMap = json.decode(response.body);

      final List<GroceryModel> tempGroceryList = [];
      for (final item in groceriesMap.entries) {
        final category = category_list.entries
            .firstWhere((searchCategory) =>
        item.value["category"] == searchCategory.value.category)
            .value;
        tempGroceryList.add(
          GroceryModel(
            id: item.key,
            name: item.value["name"],
            quantity: item.value["quantity"],
            category: category,
          ),
        );
      }

      setState(() {
        _isLoading = false;
        groceryList = tempGroceryList;
      });
    } catch (exception) {
      setState(() {
        _errorMessage = exception.toString();
      });
    }
  }

  void _addItem(BuildContext context) async {
    final newGrocery =
        await Navigator.of(context).push<GroceryModel>(MaterialPageRoute(
      builder: (context) {
        return const CreateNewGroceryScreen();
      },
    ));

    if (newGrocery != null) {
      setState(() {
        groceryList.add(newGrocery);
      });
    }
  }

  void _removeGrocery(int index) async {
    final item = groceryList[index];

    setState(() {
      groceryList.remove(item);
    });

    final url = Uri.https(
      "udemy-tutorial-grocery-default-rtdb.firebaseio.com",
      "grocery-list/${item.id}.json",
    );
    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Could not delete grocery")));
        groceryList.insert(index, item);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _loadGroceryList();
  }

  @override
  Widget build(BuildContext context) {
    Widget activeWidget = ListView.builder(
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(DateTime.now().toString()),
          onDismissed: (direction) {
            _removeGrocery(index);
          },
          background: Container(
            color: Colors.redAccent,
          ),
          direction: DismissDirection.startToEnd,
          child: ListTile(
            trailing: Text(groceryList[index].quantity.toString()),
            leading: Container(
              height: 24,
              width: 24,
              color: groceryList[index].category.color,
            ),
            title: Text(groceryList[index].name),
          ),
        );
      },
      itemCount: groceryList.length,
    );

    if (groceryList.isEmpty) {
      activeWidget = const Center(
        child: Text(
          "No Groceries available",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      );
    }

    if (_isLoading) {
      activeWidget = const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage != null) {
      activeWidget = Center(
        child: Text(_errorMessage!),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Groceries"),
        actions: [
          IconButton(
            onPressed: () {
              _addItem(context);
            },
            icon: const Icon(
              Icons.add,
            ),
          ),
        ],
      ),
      body: activeWidget,
    );
  }
}

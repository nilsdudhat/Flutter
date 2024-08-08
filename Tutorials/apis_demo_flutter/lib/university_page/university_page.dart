import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UniversityPage extends ConsumerStatefulWidget {
  const UniversityPage({super.key});

  @override
  ConsumerState<UniversityPage> createState() => _UniversityPageState();
}

class _UniversityPageState extends ConsumerState<UniversityPage> {
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey();
    final countryTextController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("University"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      validator: (value) {
                        if (countryTextController.text.isEmpty) {
                          return "Please enter your country name";
                        }
                        return null;
                      },
                      controller: countryTextController,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {

                    },
                    child: const Text("Search"),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

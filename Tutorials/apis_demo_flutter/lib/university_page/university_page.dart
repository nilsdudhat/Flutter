import 'package:apis_demo_flutter/university_page/university.dart';
import 'package:apis_demo_flutter/university_page/university_provider.dart';
import 'package:apis_demo_flutter/utils/progress_utils.dart';
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
    final formKey = GlobalKey<FormState>();
    final countryTextController = TextEditingController();

    ValueNotifier<List<University>> listNotifier = ValueNotifier([]);

    final countryNotifier = ValueNotifier("");

    void searchUniversities(String country) {
      ProgressUtils.show(context);
      ref
          .read(universityProvider)
          .getUniversityList(
            country: country,
            onError: (error) {
              ProgressUtils.hide();
              countryTextController.text = "";
            },
          )
          .then((value) {
        if (value != null) {
          listNotifier.value = value;
          ProgressUtils.hide();
          countryTextController.text = "";
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder(
          valueListenable: countryNotifier,
          builder: (context, value, child) {
            return Text(value.isEmpty
                ? "Search Universities"
                : "Universities of $value");
          },
        ),
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
                      if ((formKey.currentState != null) &&
                          formKey.currentState!.validate()) {
                        searchUniversities(countryTextController.text);
                      }
                    },
                    child: const Text("Search"),
                  ),
                ],
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable: listNotifier,
                  builder: (context, value, child) {
                    return ListView.separated(
                      itemBuilder: (context, index) {
                        final item = listNotifier.value[index];
                        String websites = "";
                        if (item.webPages != null) {
                          for (int i = 0; i < item.webPages!.length; i++) {
                            String web = item.webPages![i];

                            if (websites.isEmpty) {
                              websites = web;
                            } else {
                              websites = "$websites,\n$web";
                            }
                          }
                        }

                        return Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              if (websites.isNotEmpty)
                                Text(
                                  websites,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 1,
                          color: Colors.black,
                        );
                      },
                      itemCount: listNotifier.value.length,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

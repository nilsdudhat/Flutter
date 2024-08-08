import 'package:apis_demo_flutter/api_provider.dart';
import 'package:apis_demo_flutter/university_page/university_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class APIPage extends ConsumerStatefulWidget {
  const APIPage({super.key});

  @override
  ConsumerState<APIPage> createState() => _APIPageState();
}

class _APIPageState extends ConsumerState<APIPage> {
  List<Map<String, String>> list = [];

  @override
  void initState() {
    super.initState();

    list = ref.read(apiProvider).getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: ListView.separated(
          itemCount: list.length,
          itemBuilder: (context, index) {
            final Map<String, String> item = list[index];

            return InkWell(
              onTap: () {
                if (item["title"].toString() == "Universities") {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return const UniversityPage();
                    },
                  ));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item["title"].toString(),
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item["sample_url"].toString(),
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) {
            return Container(
              color: Colors.black,
              height: 1,
            );
          },
        ),
      ),
    );
  }
}

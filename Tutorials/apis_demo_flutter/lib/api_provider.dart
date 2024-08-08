import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiProvider = ChangeNotifierProvider((ref) => APINotifier());

class APINotifier extends ChangeNotifier {
  List<Map<String, String>> list = [];

  List<Map<String, String>> getList() {
    list.add({
      "title": "Universities",
      "sample_url":
          "http://universities.hipolabs.com/search?country=United+States",
    });
    list.add({
      "title": "Area Identifier",
      "sample_url":
          "https://api.zippopotam.us/us/33162",
    });

    return list;
  }
}

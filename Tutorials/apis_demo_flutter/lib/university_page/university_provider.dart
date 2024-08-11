import 'dart:convert';
import 'dart:developer';

import 'package:apis_demo_flutter/university_page/university.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final universityProvider =
    ChangeNotifierProvider((ref) => UniversityNotifier());

class UniversityNotifier extends ChangeNotifier {
  Future<List<University>?> getUniversityList({
    required String country,
    required Function(String error) onError,
  }) async {
    final uri =
        Uri.parse("http://universities.hipolabs.com/search?country=$country");
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      log("--response-- ${response.body}");

      final gson = jsonDecode(response.body);
      return List<University>.from(
          gson.map((model) => University.fromJson(model)));
    } else {
      onError.call("Response Code: ${response.statusCode}");
    }
    return null;
  }
}

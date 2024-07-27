import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:movies_tmdb/models/polpular_movies_data.dart';

final homePageProvider = ChangeNotifierProvider<HomePageNotifier>((ref) {
  return HomePageNotifier();
});

class HomePageNotifier extends ChangeNotifier {
  Future<PopularMoviesData?> getPopularMoviesData({
    required int pageNumber,
    required Function(String error) onError,
  }) async {
    try {
      final uri = Uri.parse(
          "https://api.themoviedb.org/3/movie/popular?api_key=6e5f5546476088e0a63a56b18c88d367&page=$pageNumber");
      Map<String, String> requestHeaders = {
        'accept': 'application/json',
        // 'Authorization':
        //     'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2ZTVmNTU0NjQ3NjA4OGUwYTYzYTU2YjE4Yzg4ZDM2NyIsIm5iZiI6MTcyMTg5MDMwMy4zMjQyOTEsInN1YiI6IjY2MGU2OGViMTVkZWEwMDE3YzM3NTg2NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.9qbjxmchbZhO9CPmnSiALk1c1OZqMuXvrVbyS2iG4Pg'
      };
      final response = await http.get(uri, headers: requestHeaders);
      if (response.statusCode == 200) {
        log("--movies-- ${response.body.toString()}");

        final gson = jsonDecode(response.body);
        return PopularMoviesData.fromJson(gson);
      } else {
        log("--movies-- error");
        onError.call("");
      }
    } catch (exception) {
      log("--movies-- $exception");
      onError.call(exception.toString());
    }
    return null;
  }
}

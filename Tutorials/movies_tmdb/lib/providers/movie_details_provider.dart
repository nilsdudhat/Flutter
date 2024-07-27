import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../models/movie_details.dart';

final movieDetailsProvider = ChangeNotifierProvider(
  (ref) => MovieNotifier(),
);

class MovieNotifier extends ChangeNotifier {
  Future<MovieDetails?> getMovieDetails({
    required int movieID,
    required Function(String exception) onError,
  }) async {
    try {
      final url = Uri.parse("https://api.themoviedb.org/3/movie/$movieID");
      Map<String, String> requestHeaders = {
        'accept': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI2ZTVmNTU0NjQ3NjA4OGUwYTYzYTU2YjE4Yzg4ZDM2NyIsInN1YiI6IjY2MGU2OGViMTVkZWEwMDE3YzM3NTg2NyIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ho8ppcda5-Ul1BejIxbh2yceKfc1Kj2JjL2DUfPftGw'
      };

      final response = await http.get(url, headers: requestHeaders);

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return MovieDetails.fromJson(body);
      } else {
        onError.call("");
      }
    } catch (exception) {
      onError.call(exception.toString());
    }
    return null;
  }
}

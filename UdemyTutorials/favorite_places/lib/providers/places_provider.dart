import 'dart:io';

import 'package:favorite_places/models/place_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as sys_path;
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDatabase() async {
  final dbPath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbPath, "places.db"),
    onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE user_places (id TEXT PRIMARY KEY, placeName TEXT, image TEXT, latitude REAL, longitude REAL)");
    },
    version: 1,
  );
  return db;
}

class PlacesNotifier extends StateNotifier<List<PlaceModel>> {
  PlacesNotifier() : super(const []);

  Future<void> loadPlaces() async {
    final db = await _getDatabase();

    final data = await db.query("user_places");

    final placeList = data
        .map((place) => PlaceModel(
            placeName: place["placeName"] as String,
            image: File(place["image"] as String),
            placeLocation: PlaceLocation(
                latitude: place["latitude"] as double,
                longitude: place["longitude"] as double)))
        .toList();

    state = placeList;
  }

  void addPlace(
      String placeName, File imageFile, PlaceLocation placeLocation) async {
    final appDir = await sys_path.getApplicationDocumentsDirectory();
    final fileName = path.basename(imageFile.path);
    final copiedImage = await imageFile.copy("${appDir.path}/$fileName");

    final newPlace = PlaceModel(
        placeName: placeName, image: copiedImage, placeLocation: placeLocation);

    final db = await _getDatabase();

    db.insert("user_places", {
      "id": newPlace.id,
      "placeName": newPlace.placeName,
      "image": newPlace.image.path,
      "latitude": newPlace.placeLocation.latitude,
      "longitude": newPlace.placeLocation.longitude,
    });

    state = [newPlace, ...state];
  }

  void removeModel(PlaceModel placeModel) {
    state = [
      for (final place in state)
        if (place != placeModel) place,
    ];
  }
}

final placesProvider = StateNotifierProvider<PlacesNotifier, List<PlaceModel>>(
  (ref) => PlacesNotifier(),
);

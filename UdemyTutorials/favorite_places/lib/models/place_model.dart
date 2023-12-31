import 'dart:io';

import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class PlaceModel {
  final String placeName;
  final String id;
  final File image;
  final PlaceLocation placeLocation;

  PlaceModel({
    required this.placeName,
    required this.image,
    required this.placeLocation,
    id,
  }) : id = id ?? uuid.v4();
}

class PlaceLocation {
  final double latitude;
  final double longitude;

  const PlaceLocation({
    required this.latitude,
    required this.longitude,
  });
}

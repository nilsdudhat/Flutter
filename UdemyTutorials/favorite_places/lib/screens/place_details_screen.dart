import 'package:favorite_places/models/place_model.dart';
import 'package:flutter/material.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final PlaceModel placeModel;

  const PlaceDetailsScreen(this.placeModel, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${placeModel.placeName} Details"),
      ),
      body: Stack(
        children: [
          Image.file(
            placeModel.image!,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                        end: Alignment.bottomCenter,
                        begin: Alignment.topCenter,
                        colors: [Colors.transparent, Colors.black])),
                child: Text(
                  "Latitude: ${placeModel.placeLocation!.latitude},\nLongitude: ${placeModel.placeLocation!.longitude}",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                      color: Theme.of(context).colorScheme.onBackground),
                ),
              )),
        ],
      ),
    );
  }
}

import 'package:favorite_places/models/place_model.dart';
import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/screens/place_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PlacesList extends ConsumerWidget {
  final List<PlaceModel> placeList;

  const PlacesList(this.placeList, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return Dismissible(
          key: ValueKey(placeList[index].id),
          direction: DismissDirection.startToEnd,
          onDismissed: (direction) {
            ref.read(placesProvider.notifier).removeModel(placeList[index]);
          },
          child: ListTile(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return PlaceDetailsScreen(placeList[index]);
                  },
                ),
              );
            },
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: FileImage(placeList[index].image!),
            ),
            subtitle: Text(
              "Latitude: ${placeList[index].placeLocation!.latitude}, Longitude: ${placeList[index].placeLocation!.longitude}",
              style: Theme.of(context)
                  .textTheme
                  .labelMedium!
                  .copyWith(color: Colors.white),
            ),
            title: Text(
              placeList[index].placeName,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: Colors.white),
            ),
          ),
        );
      },
      itemCount: placeList.length,
    );
  }
}

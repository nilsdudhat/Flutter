import 'dart:io';

import 'package:favorite_places/models/place_model.dart';
import 'package:favorite_places/providers/places_provider.dart';
import 'package:favorite_places/widgets/image_input.dart';
import 'package:favorite_places/widgets/location_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddPlaceScreen extends ConsumerStatefulWidget {
  const AddPlaceScreen({super.key});

  @override
  ConsumerState<AddPlaceScreen> createState() => _AddPlaceScreenState();
}

class _AddPlaceScreenState extends ConsumerState<AddPlaceScreen> {
  final _placeEditingController = TextEditingController();
  var _isError = false;
  var _errorMessage = "";
  File? _selectedImage;
  PlaceLocation? _placeLocation;

  void _onLocationPicked(PlaceLocation placeLocation) {
    _placeLocation = placeLocation;
  }

  void _onImagePicked(File imageFile) {
    _selectedImage = imageFile;
  }

  void _savePlace(BuildContext context) {
    if (_placeEditingController.text.isEmpty) {
      setState(() {
        _isError = true;
        _errorMessage = "Enter Place Name";
      });
    } else if (_selectedImage == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please Pick Image")));
    } else if (_placeLocation == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Please get current location")));
    } else {
      ref.read(placesProvider.notifier).addPlace(
            _placeEditingController.text.toString(),
            _selectedImage!,
            _placeLocation!,
          );
      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _placeEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Place"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextField(
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.onBackground),
                keyboardType: TextInputType.text,
                controller: _placeEditingController,
                decoration: InputDecoration(
                  label: const Text("Enter Place Name"),
                  errorText: _isError ? _errorMessage : null,
                ),
                onChanged: (value) {
                  if (_isError) {
                    setState(() {
                      _isError = false;
                    });
                  }
                },
              ),
              const SizedBox(
                height: 25,
              ),
              ImageInput(onImagePicked: _onImagePicked),
              const SizedBox(
                height: 25,
              ),
              LocationInput(onLocationPicked: _onLocationPicked),
              const SizedBox(
                height: 25,
              ),
              ElevatedButton.icon(
                  onPressed: () {
                    _savePlace(context);
                  },
                  icon: const Icon(Icons.add),
                  label: const Text("Add Place"))
            ],
          ),
        ),
      ),
    );
  }
}

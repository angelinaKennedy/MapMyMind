import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'alert_dialog_button.dart';

class GetLocation extends StatefulWidget {
  final Function() getCurrentPosition;
  final Function(String) getInputtedPosition;
  final Function(LatLng) onLocationSelected;

  const GetLocation({
    Key? key,
    required this.getCurrentPosition,
    required this.getInputtedPosition,
    required this.onLocationSelected
  }) : super(key: key);

  @override
  State<GetLocation> createState() => _GetLocationState();
}

class _GetLocationState extends State<GetLocation> {

  final _inputtedLocationController = TextEditingController();

  Future<List<dynamic>> _fetchLocationSuggestions(String query) async {
    final url = Uri.parse('https://nominatim.openstreetmap.org/search?q=$query&format=json&addressdetails=1');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data;
    } else {
      throw Exception('Failed to fetch location suggestions');
    }
  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text( 'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.brown.shade200,
        content: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text( "Add a location",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AlertDialogButtons(
                      buttonName: "Get location",
                      buttonIcon: Icons.pin_drop,
                      onPressed: () async {
                        await _handleLocationPermission();
                        widget.getCurrentPosition();
                        Navigator.of(context).pop();
                      },
                    ),
                    const Text("\nor\n", style: TextStyle(fontWeight: FontWeight.w700,)),
                    SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      child: TypeAheadField(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller: _inputtedLocationController,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Type location',
                          ),
                        ),
                        suggestionsCallback: _fetchLocationSuggestions,
                        itemBuilder: (context, dynamic suggestion) {
                          final location = suggestion['display_name'];
                          return ListTile(
                            title: Text(location),
                          );
                        },
                        onSuggestionSelected: (dynamic suggestion) {
                          final location = suggestion['display_name'];
                          _inputtedLocationController.text = location;
                          widget.getInputtedPosition(location);

                          final latitude = double.parse(suggestion['lat']);
                          final longitude = double.parse(suggestion['lon']);
                          final position = LatLng(latitude, longitude);
                          widget.onLocationSelected(position);

                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ],
          ),
        ),
    );
  }
}
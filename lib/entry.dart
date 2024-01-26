import 'dart:convert';
import 'package:floor/floor.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

@entity
class Entry {
  @primaryKey
  final String title;
  String content = '';
  String date;
  String location = '';
  List<String> images = [];
  LatLng? position = LatLng(0, 0);

  Entry(this.title, this.content, this.date, this.location, this.images, this.position);
}

class ListStringConverter extends TypeConverter<List<String>, String> {
  @override
  List<String> decode(String databaseValue) {
    final jsonFile = json.decode(databaseValue);
    return  List<String>.from(jsonFile['images']);
  }

  @override
  String encode(List value) {
    final data = <String, dynamic>{};
    data.addAll({'images': value});
    return json.encode(data);
  }
}

class LatLngConverter extends TypeConverter<LatLng?, String> {
  @override
  LatLng? decode(String databaseValue) {
    final array = databaseValue.split(',');
    return LatLng(double.parse(array[0]), double.parse(array[1]));
  }

  @override
  String encode(LatLng? value) {
    final lat = (value!.latitude).toString();
    final long = (value!.longitude).toString();
    return "$lat,$long";
  }
}
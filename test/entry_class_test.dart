import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_my_mind/entry.dart';

void main() {
  group('ListStringConverter class test', () {
    final ListStringConverter converter = ListStringConverter();

    test('Test to encode a List of strings to a JSON string', () {
      final input = ['image1.jpg', 'image2.jpg'];
      final encoded = converter.encode(input);
      final decoded = json.decode(encoded);
      expect(decoded['images'], input);
    });

    test('Test to decode a JSON string to a List of strings', () {
      final input = {'images': ['image1.jpg', 'image2.jpg']};
      final encoded = json.encode(input);
      final decoded = converter.decode(encoded);
      expect(decoded, input['images']);
    });
  });

  group('LatLngConverter class test', () {
    final LatLngConverter converter = LatLngConverter();

    test('Test to encode a LatLng object to a string', () {
      const input = LatLng(37.4213, -122.4);
      final encoded = converter.encode(input);
      final decoded = converter.decode(encoded);
      expect(decoded, input);
    });

    test('Test to decode a string to a LatLng object', () {
      const input = '37.4213, -122.4';
      final decoded = converter.decode(input);
      expect(decoded, const LatLng(37.4213, -122.4));
    });
  });
}

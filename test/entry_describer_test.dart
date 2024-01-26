import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_my_mind/entry.dart';
import 'package:map_my_mind/entry_describer.dart';
import 'package:map_my_mind/entry_view_model.dart';

void main() {
  testWidgets('Event describer works as expected', (WidgetTester tester) async {

    var entry = Entry("title", "content", "date", "location", ["img"], LatLng(0, 0));

    expect(entry.entryTitle, "title");
    expect(entry.entryContent, "content");
    expect(entry.entryLocation, "location");
    expect(entry.entryImages, ["img"]);
    expect(entry.entryDate, "date");
    expect(entry.entryPosition, LatLng(0, 0));

  });

  testWidgets('Event view model getters works as expected', (WidgetTester tester) async {

    var entryVM = EntryViewModel();

    expect(entryVM.entryTitles, []);
    expect(entryVM.entryContents, []);
    expect(entryVM.entryLocations, []);
    expect(entryVM.entryImages, []);
    expect(entryVM.entryDates, []);
    expect(entryVM.entryPosition, []);

  });
}

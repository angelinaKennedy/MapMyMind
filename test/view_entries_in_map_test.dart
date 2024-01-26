import 'package:flutter_test/flutter_test.dart';
import 'package:map_my_mind/display_images.dart';
import 'package:map_my_mind/entry_view_model.dart';
import 'package:map_my_mind/view_entries_in_map.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class MockEntryViewModel extends EntryViewModel {
  @override
  List<String> get entryTitles => ['Entry Title'];

  @override
  List<String> get entryDates => ['Entry Date'];

  @override
  List<String> get entryLocations => ['Entry Location'];

  @override
  List<String?> get entryContents => ['Entry Content'];

  @override
  List<List<String>> get entryImages => [['path/to/image1.jpg', 'path/to/image2.jpg']];
}


void main() {
  late MockEntryViewModel mockEntryViewModel;

  setUp(() {
    mockEntryViewModel = MockEntryViewModel();
  });

  Widget buildViewEntry(int index) {
    return ChangeNotifierProvider<EntryViewModel>(
      create: (_) => mockEntryViewModel,
      child: MaterialApp(
        home: ViewEntry(index: index),
      ),
    );
  }

  testWidgets('ViewEntry displays correct data', (WidgetTester tester) async {
    const index = 0;

    await tester.pumpWidget(buildViewEntry(index));

    expect(find.text('Entry Title'), findsOneWidget);
    expect(find.text('Entry Date'), findsOneWidget);
    expect(find.text('Location: Entry Location'), findsOneWidget);
    expect(find.text('Entry Content'), findsOneWidget);

    expect(find.byType(DisplayImages), findsOneWidget);
    expect(find.byType(Image), findsNWidgets(2));
  });
}

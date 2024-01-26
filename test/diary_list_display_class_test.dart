import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:map_my_mind/display_diary_entries.dart';

void main() {
  group('DiaryListDisplay class test file', () {
    const entryTitle = 'Test Entry';
    const creationDate = '05/19';
    onPressedDelete(BuildContext context) {}
    onTapViewEntries() {}
    final diaryListDisplay = DiaryListDisplay(
      entryTitle: entryTitle,
      creationDate: creationDate,
      onPressedDelete: onPressedDelete,
      onTapViewEntries: onTapViewEntries,
    );

    testWidgets('should display the creation date and entry title', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: diaryListDisplay)));
      final titleFinder = find.text("$creationDate | $entryTitle");
      expect(titleFinder, findsOneWidget);
    });

    testWidgets('should call onTapViewEntries when the tile is tapped', (WidgetTester tester) async {
      var tileTapped = false;
      onTapViewEntries() {
        tileTapped = true;
      }
      final diaryListDisplay = DiaryListDisplay(
        entryTitle: entryTitle,
        creationDate: creationDate,
        onPressedDelete: onPressedDelete,
        onTapViewEntries: onTapViewEntries,
      );
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: diaryListDisplay)));
      final listTile = find.byType(ListTile);
      await tester.tap(listTile);
      expect(tileTapped, isTrue);
    });

    testWidgets('should display the Slidable widget', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: diaryListDisplay)));
      final slidableFinder = find.byType(Slidable);
      expect(slidableFinder, findsOneWidget);
    });
  });
}

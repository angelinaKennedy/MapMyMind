import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:map_my_mind/add_button_to_open_new_diary.dart';
import 'package:map_my_mind/create_diary_page.dart';
import 'package:flutter/material.dart';
import 'package:map_my_mind/entry_view_model.dart';
import 'package:provider/provider.dart';



void main() {
  group('DiaryPage class test file', () {
    testWidgets('Test to check if all buttons are showing up and to check if a list is showing up after user creates one', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<EntryViewModel>(
          create: (_) => EntryViewModel(),
          child: const MaterialApp(
            home: DiaryPage(),
          ),
        ),
      );

      expect(find.text('MapMyMind'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(find.byType(CurvedNavigationBar), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      expect(find.text('Map Your Title'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'New Diary Entry');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('New Diary Entry'), findsOneWidget);

      await tester.tap(find.text('New Diary Entry'));
      await tester.pumpAndSettle();

      expect(find.text('New Diary Entry'), findsOneWidget);
    });

    testWidgets('Test for map button', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<EntryViewModel>(
          create: (_) => EntryViewModel(),
          child: const MaterialApp(
            home: DiaryPage(),
          ),
        ),
      );
      await tester.tap(find.byIcon(Icons.map_outlined));
      await tester.pumpAndSettle();
    });

    testWidgets('Test for user entering empty title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<EntryViewModel>(
          create: (_) => EntryViewModel(),
          child: const MaterialApp(
            home: DiaryPage(),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), '');
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets('Test to check there is no list if the user did not enter a title', (WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<EntryViewModel>(
          create: (_) => EntryViewModel(),
          child: const MaterialApp(
            home: DiaryPage(),
          ),
        ),
      );

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(find.byType(AddButtonForNewDiary), findsNothing);
    });
  });
}

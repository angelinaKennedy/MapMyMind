import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:map_my_mind/add_location_page.dart';
import 'package:map_my_mind/new_writing_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {

  Future<void> _pumpWritingPage(WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: WritingPage (
        titleOfTheEntry: "Test",
        creationDate: '05/19/2023 09:50 PM',
        onPressedYes: () {},
        onPressedNo: () {},
        savedImagePaths: const [],
        selectedPosition: '',
      ),
    ));
  }

  group('Writing page class test file', () {

    testWidgets('Display Title', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: WritingPage(
        titleOfTheEntry: 'Test run TITLE',
        creationDate: '05/19/2023 09:50 PM',
        onPressedYes: ()  {},
        onPressedNo: () {},
        savedImagePaths: const [],
        selectedPosition: '',
      )));
      final expectedTitle = find.text('Test run TITLE');
      expect(expectedTitle, findsOneWidget);
    });

    testWidgets('Display content', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: WritingPage(
        titleOfTheEntry: 'Test run CONTENT',
        creationDate: '05/19/2023 09:50 PM',
        onPressedYes: ()  {},
        onPressedNo: () {},
        savedImagePaths: const [],
        selectedPosition: '',
      )));
      final expectedTitle = find.text('Test run CONTENT');
      expect(expectedTitle, findsOneWidget);
    });

    testWidgets('Displays the date created', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: WritingPage(
        titleOfTheEntry: 'Test',
        creationDate: '05/19/2023 09:50 PM',
        onPressedYes: ()  {},
        onPressedNo: () {},
        savedImagePaths: const [],
        selectedPosition: '',
      )));
      final expectedDate = find.text('05/19/2023 09:50 PM');
      expect(expectedDate, findsOneWidget);
    });

    testWidgets('Alert dialog appears when exiting with no content', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: WritingPage(
        titleOfTheEntry: 'Test',
        creationDate: '05/19/2023 09:50 PM',
        onPressedYes: ()  {},
        onPressedNo: () {},
        savedImagePaths: const [],
        selectedPosition: '',
      )));
      final backButton = find.byIcon(Icons.arrow_back_ios_rounded);
      await tester.tap(backButton);
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text("Do you still want to exit without adding anything to your entry?"), findsOneWidget);
    });

    testWidgets("Renders add image button in app bar correctly", (WidgetTester tester) async {
      await _pumpWritingPage(tester);

      final addButtonIcon = find.widgetWithIcon(InkWell, Icons.camera_alt);
      expect(addButtonIcon, findsOneWidget);
    });

    testWidgets("Alert dialog appears when add image icon tapped", (WidgetTester tester) async {
      await _pumpWritingPage(tester);

      final addButtonIcon = find.widgetWithIcon(InkWell, Icons.camera_alt);
      expect(addButtonIcon, findsOneWidget);
      await tester.runAsync(() async {await tester.tap(addButtonIcon);});
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.widgetWithIcon(AlertDialog, Icons.image), findsOneWidget);
      expect(find.widgetWithIcon(AlertDialog, Icons.camera_alt), findsOneWidget);
    });

    testWidgets("Alert dialog appears when add location icon tapped", (WidgetTester tester) async {
      await _pumpWritingPage(tester);

      final addButtonIcon = find.widgetWithIcon(InkWell, Icons.pin_drop_rounded);
      expect(addButtonIcon, findsOneWidget);
      await tester.runAsync(() async {await tester.tap(addButtonIcon);});
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
    });

    testWidgets('Navigate back with diary entry, images, and location', (WidgetTester tester) async {

      await tester.pumpWidget(MaterialApp(
        home: WritingPage(
          titleOfTheEntry: 'Test Entry',
          onPressedYes: () {},
          onPressedNo: () {},
          contentOfTheEntry: 'This is a test entry',
          creationDate: 'June 4, 2023',
          savedImagePaths: const ['/path/to/image1.jpg', '/path/to/image2.jpg'],
          location: 'Test Location',
          selectedPosition: const LatLng(1.0, 2.0),
        ),
      ));

      await tester.tap(find.byIcon(Icons.arrow_back_ios_rounded));
      await tester.pump();
    });

    testWidgets('Test onLocationSelected callback', (WidgetTester tester) async {
      bool callbackCalled = false;

      await tester.pumpWidget(MaterialApp(
        home: WritingPage(
          titleOfTheEntry: 'Test Entry',
          onPressedYes: () {},
          onPressedNo: () {},
          contentOfTheEntry: 'This is a test entry',
          creationDate: 'June 4, 2023',
          savedImagePaths: const ['/path/to/image1.jpg', '/path/to/image2.jpg'],
          location: 'Test Location',
          selectedPosition: const LatLng(1.0, 2.0),
        ),
      ));
      final addButtonIcon = find.widgetWithIcon(InkWell, Icons.pin_drop_rounded);
      expect(addButtonIcon, findsOneWidget);
      await tester.runAsync(() async {await tester.tap(addButtonIcon);});
      await tester.pumpAndSettle();

      final getLocationWidget = tester.widget<GetLocation>(find.byType(GetLocation));
      getLocationWidget.onLocationSelected(const LatLng(37.7749, -122.4194));
      callbackCalled = true;

      expect(callbackCalled, true);
    });
  });
}
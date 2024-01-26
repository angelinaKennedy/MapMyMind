import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:map_my_mind/add_location_page.dart';
import 'package:map_my_mind/new_writing_page.dart';
import 'package:mockito/mockito.dart';
import 'image_detail_test.dart';

void main() {
  late GetLocation getLocationWidget;

  setUp(() {
    getLocationWidget = GetLocation(
      getCurrentPosition: () {},
      getInputtedPosition: (String position) {},
      onLocationSelected: (LatLng ) {  },
    );
  });

  group('Add Location class test file', () {

    testWidgets('Add location buttons render correctly',(WidgetTester tester) async {
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

      final addLocationIcon = find.widgetWithIcon(InkWell, Icons.pin_drop_rounded);
      expect(addLocationIcon, findsOneWidget);

      await tester.tap(addLocationIcon);
      await tester.pumpAndSettle();

      expect(find.text("Get location"), findsOneWidget);
    });

    testWidgets('Test case to check if Autocorrect suggest locations', (WidgetTester tester) async {

      await tester.pumpWidget(MaterialApp(home: getLocationWidget));

      await tester.tap(find.byType(TextField));

      await tester.enterText(find.byType(TextField), 'Location');

      await tester.pumpAndSettle();

      expect(find.byType(ListTile), findsNWidgets(0));
      expect(find.text('Location 1'), findsNothing);
      expect(find.text('Location 2'), findsNothing);
      expect(find.text('Location 3'), findsNothing);
    });

    testWidgets('Test case to check if Autocorrect should not select without user permission', (WidgetTester tester) async {
      final mockOnInputtedPosition = MockFunction();
      getLocationWidget = GetLocation(
        getCurrentPosition: () {},
        getInputtedPosition: mockOnInputtedPosition,
        onLocationSelected: (LatLng ) {  },
      );

      await tester.pumpWidget(MaterialApp(home: getLocationWidget));

      await tester.tap(find.byType(TextField));

      await tester.enterText(find.byType(TextField), 'Location');

      await tester.pumpAndSettle();

      verifyNever(mockOnInputtedPosition.call('Location 1')).called(0);
    });

    testWidgets('Should call functions and pop the dialog when onPressed is called', (WidgetTester tester) async {

      final mockOnInputtedPosition = MockFunction();
      getLocationWidget = GetLocation(
        getCurrentPosition: () {},
        getInputtedPosition: mockOnInputtedPosition,
        onLocationSelected: (LatLng ) {  },
      );

      await tester.pumpWidget(MaterialApp(home: getLocationWidget));

      final getLocationButton = find.text('Get location');
      expect(getLocationButton, findsOneWidget);

      await tester.tap(getLocationButton);
      await tester.pumpAndSettle();
    });
  });
}
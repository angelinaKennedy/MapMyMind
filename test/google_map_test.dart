import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_my_mind/google_maps.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
class MockGoogleMapController extends Mock implements GoogleMapController {}

void main() {
  group('GoogleMapStyle class test file', ()  {
    late MockNavigatorObserver mockObserver;
    GoogleMapController controller;

    setUp(() async {
      mockObserver = MockNavigatorObserver();
      controller = MockGoogleMapController();
    });

    Future<void> _PumpGoogleMapStyleState(WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: GoogleMapStyle(locations: [], onMarkerTapped: (LatLng ) {  },),
        navigatorObservers: [mockObserver],
      ));
    }

    testWidgets('renders app bar title correctly',
            (WidgetTester tester) async {
          await _PumpGoogleMapStyleState(tester);

          final appBarTitle = find.text('MapMyMind');

          expect(appBarTitle, findsOneWidget);
        });

    testWidgets('renders home button in bottom navigation bar correctly',
            (WidgetTester tester) async {
          await _PumpGoogleMapStyleState(tester);

          final homeButtonIcon = find.widgetWithIcon(CurvedNavigationBar, Icons.home_outlined).first;

          expect(homeButtonIcon, findsOneWidget);
        });

    testWidgets('renders map button in bottom navigation bar correctly',
            (WidgetTester tester) async {
          await _PumpGoogleMapStyleState(tester);

          final mapButtonIcon = find.widgetWithIcon(CurvedNavigationBar, Icons.map_outlined).last;

          expect(mapButtonIcon, findsOneWidget);
        });

    testWidgets('renders navigation button in floating action correctly', (WidgetTester tester) async {
          (WidgetTester tester) async {
        await _PumpGoogleMapStyleState(tester);

        final floatingButtonIcon = find.widgetWithIcon(FloatingActionButton, Icons.navigation_outlined);

        expect(floatingButtonIcon, findsOneWidget);
      };
    });

    testWidgets('Should navigate to home page when index is 0', (WidgetTester tester) async {
      final mockObserver = MockNavigatorObserver();
      final widget = MaterialApp(
        home: GoogleMapStyle(locations: [], onMarkerTapped: (LatLng ) {  },),
        navigatorObservers: [mockObserver],
      );
      await tester.pumpWidget(widget);

      final curvedNavigationBar = find.byType(CurvedNavigationBar);
      expect(curvedNavigationBar, findsOneWidget);

      final homeButton = find.byIcon(Icons.home_outlined);
      expect(homeButton, findsOneWidget);

      await tester.tap(homeButton);
      await tester.pumpAndSettle();
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_my_mind/image_detail_screen.dart';
import 'package:mockito/mockito.dart';

class MockFunction extends Mock {
  void call(String path);
}

void main() {
  group('DetailScreen Widget Test', () {
    testWidgets('Test Case to check if the widget Displays the image', (WidgetTester tester) async {
      final image = XFile('path/to/image.jpg');
      await tester.pumpWidget(
        MaterialApp(
          home: DetailScreen(
            image: image,
            onDeleteImage: (_) {},
          ),
        ),
      );
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('Test case to see if delete button calls onDeleteImage', (WidgetTester tester) async {
      final mockFunction = MockFunction();
      final image = XFile('path/to/image.jpg');
      await tester.pumpWidget(
        MaterialApp(
          home: DetailScreen(
            image: image,
            onDeleteImage: mockFunction,
          ),
        ),
      );
      final deleteButton = find.byIcon(Icons.delete_outline);
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      verify(mockFunction.call(image.path)).called(1);
    });

    testWidgets('Test case to check if delete button pops the screen', (WidgetTester tester) async {
      final mockFunction = MockFunction();
      final image = XFile('path/to/image.jpg');
      await tester.pumpWidget(
        MaterialApp(
          home: DetailScreen(
            image: image,
            onDeleteImage: mockFunction,
          ),
        ),
      );
      final deleteButton = find.byIcon(Icons.delete_outline);
      expect(deleteButton, findsOneWidget);
      await tester.tap(deleteButton);
      await tester.pumpAndSettle();
      expect(find.byType(DetailScreen), findsNothing);
    });

    testWidgets('Test case to check if tapping screen pops the screen', (WidgetTester tester) async {
      final image = XFile('path/to/image.jpg');
      await tester.pumpWidget(
        MaterialApp(
          home: DetailScreen(
            image: image,
            onDeleteImage: (_) {},
          ),
        ),
      );
      final screen = find.byType(DetailScreen);
      expect(screen, findsOneWidget);
      await tester.tap(screen);
      await tester.pumpAndSettle();
      expect(find.byType(DetailScreen), findsNothing);
    });
  });
}

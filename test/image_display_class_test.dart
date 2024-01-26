import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_my_mind/add_image_alert.dart';
import 'package:map_my_mind/alert_dialog_button.dart';
import 'package:map_my_mind/display_images.dart';
import 'package:mockito/mockito.dart';

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('DisplayImages class testing', () {
    late List<XFile> images;
    late Function(String) onDeleteImage;
    late MockNavigatorObserver mockNavigatorObserver;

    setUp(() {
      images = [
        XFile('path/to/image1.jpg'),
        XFile('path/to/image2.jpg'),
      ];

      onDeleteImage = (String imagePath) {
      };

      mockNavigatorObserver = MockNavigatorObserver();
    });

    testWidgets('Test to check if the images grid are displayed', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DisplayImages(
            images: images,
            onDeleteImage: onDeleteImage,
          ),
          navigatorObservers: [mockNavigatorObserver],
        ),
      );

      expect(find.byType(DisplayImages), findsOneWidget);
      expect(find.byType(GestureDetector), findsNWidgets(images.length));
      expect(find.byType(Image), findsNWidgets(images.length));
    });

    testWidgets('Test to check if an image is deleted ', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: DisplayImages(
            images: images,
            onDeleteImage: onDeleteImage,
          ),
          navigatorObservers: [mockNavigatorObserver],
        ),
      );

      expect(find.byType(Image), findsNWidgets(images.length));

      await tester.tap(find.byType(GestureDetector).first);
      await tester.pumpAndSettle();
      
      expect(find.byType(Image), findsNWidgets(images.length - 1));
    });

    testWidgets('Test AlertDialogButtons in AddImageAlert - From Gallery', (WidgetTester tester) async {
      ImageSource selectedImageSource = ImageSource.camera;
      await tester.pumpWidget(
        MaterialApp(
          home: Material(
            child: AddImageAlert(
              getImageFunc: (source) {
                selectedImageSource = source;
              },
            ),
          ),
        ),
      );

      final fromGalleryButton = find.widgetWithText(AlertDialogButtons, 'From Gallery');
      expect(fromGalleryButton, findsOneWidget);
      await tester.tap(fromGalleryButton);
      await tester.pumpAndSettle();

      expect(selectedImageSource, ImageSource.gallery);

      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  testWidgets('Test AlertDialogButtons in AddImageAlert - From Camera', (WidgetTester tester) async {
    ImageSource selectedImageSource = ImageSource.gallery;

    await tester.pumpWidget(
      MaterialApp(
        home: Material(
          child: AddImageAlert(
            getImageFunc: (source) {
              selectedImageSource = source;
            },
          ),
        ),
      ),
    );

    final fromCameraButton = find.widgetWithText(AlertDialogButtons, 'From Camera');
    expect(fromCameraButton, findsOneWidget);
    await tester.tap(fromCameraButton);
    await tester.pumpAndSettle();

    expect(selectedImageSource, ImageSource.camera);

    expect(find.byType(AlertDialog), findsNothing);
  });
}

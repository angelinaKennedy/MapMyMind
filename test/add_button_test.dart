import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:map_my_mind/add_button_to_open_new_diary.dart';

void main() {
  group('AddButtonForNewDiary', () {
    late TextEditingController titleController;
    late Function() onPressedSave;
    late Function() onPressedCancel;

    setUp(() {
      titleController = TextEditingController();
      onPressedSave = () {};
      onPressedCancel = () {};
    });

    testWidgets('should show the correct text', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: AddButtonForNewDiary(
            titleController: titleController,
            onPressedSave: onPressedSave,
            onPressedCancel: onPressedCancel,
          ),
        ),
      );

      expect(find.text('Map Your Title'), findsOneWidget);
      expect(find.text('Title for new entry'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });

    testWidgets('should call onPressedSave when Save button is pressed',
            (WidgetTester tester) async {
          var saveButtonPressed = false;
          onPressedSave = () {
            saveButtonPressed = true;
          };

          await tester.pumpWidget(
            MaterialApp(
              home: AddButtonForNewDiary(
                titleController: titleController,
                onPressedSave: onPressedSave,
                onPressedCancel: onPressedCancel,
              ),
            ),
          );

          await tester.tap(find.text('Save'));
          expect(saveButtonPressed, isTrue);
        });

    testWidgets('should call onPressedCancel when Cancel button is pressed',
            (WidgetTester tester) async {
          var cancelButtonPressed = false;
          onPressedCancel = () {
            cancelButtonPressed = true;
          };

          await tester.pumpWidget(
            MaterialApp(
              home: AddButtonForNewDiary(
                titleController: titleController,
                onPressedSave: onPressedSave,
                onPressedCancel: onPressedCancel,
              ),
            ),
          );

          await tester.tap(find.text('Cancel'));
          expect(cancelButtonPressed, isTrue);
        });
  });
}

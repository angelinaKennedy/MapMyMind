import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:map_my_mind/alert_dialog_button.dart';

void main() {

  group("Testing the alert dialog button class", () {

    testWidgets('should call onPressed when the button is pressed', (WidgetTester tester) async {

      var buttonPressed = false;
      onPressedTest() {
        buttonPressed = true;
      }

      final alertDialogButton = AlertDialogButtons (
        buttonName: 'Test Button',
        onPressed: onPressedTest,
        buttonIcon: Icons.add,
      );

      await tester.pumpWidget(MaterialApp(home: Scaffold(body: alertDialogButton)));
      final button = find.text('Test Button');
      await tester.tap(button);
      await tester.pumpAndSettle();

      expect(buttonPressed, isTrue);
    });

  });
}


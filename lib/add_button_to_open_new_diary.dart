import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_my_mind/alert_dialog_button.dart';

class AddButtonForNewDiary extends StatefulWidget {

  final titleController;
  Function() onPressedSave;
  Function() onPressedCancel;

  AddButtonForNewDiary({
    Key? key,
    required this.titleController,
    required this.onPressedSave,
    required this.onPressedCancel,
  }) : super(key: key);

  @override
  State<AddButtonForNewDiary> createState() => _AddButtonForNewDiaryState();
}

class _AddButtonForNewDiaryState extends State<AddButtonForNewDiary> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.brown.shade200,
        content: SingleChildScrollView(
        child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
              const Align(
              alignment: Alignment.center,
              child: Text(
                "Map Your Title",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0,
                ),
              ),
          ),
            TextField(
              controller: widget.titleController,
              decoration: const InputDecoration (
                border: OutlineInputBorder(),
                hintText: "Title for new entry",
              ),
              maxLength: 30,
              maxLengthEnforcement: MaxLengthEnforcement.enforced,
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AlertDialogButtons(buttonName: "Save", onPressed: widget.onPressedSave),
                AlertDialogButtons(buttonName: "Cancel", onPressed: widget.onPressedCancel),
              ],
            )
          ]
        ),
      ),
    );
  }
}

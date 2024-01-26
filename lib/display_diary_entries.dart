import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class DiaryListDisplay extends StatelessWidget {

  final String entryTitle;
  final String creationDate;
  Function(BuildContext)? onPressedDelete;
  final Function() onTapViewEntries;

  DiaryListDisplay({
    super.key,
    required this.entryTitle,
    this.onPressedDelete,
    required this.onTapViewEntries,
    required this.creationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            SlidableAction(
              onPressed: onPressedDelete,
              icon: Icons.delete_forever,
              backgroundColor: Colors.red.shade300,
              borderRadius: BorderRadius.circular(12),
            ),
          ],
        ),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.grey.shade800, //new change
              borderRadius: BorderRadius.circular(12)
          ),
          child: ListTile (
            title: Text("${creationDate.substring(0, 5)} | $entryTitle",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15.0,
                color: Colors.white,
              ),
            ),
            onTap: onTapViewEntries,
          ),
        ),
      ),
    );
  }
}

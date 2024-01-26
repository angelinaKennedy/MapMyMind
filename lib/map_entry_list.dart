import 'package:flutter/material.dart';

class MapEntryList extends StatelessWidget {

  final String entryTitle;
  final String creationDate;
  final Function() onTapViewEntries;

  const MapEntryList({
    super.key,
    required this.entryTitle,
    required this.onTapViewEntries,
    required this.creationDate,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 25),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.grey.shade800,
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
    );
  }
}

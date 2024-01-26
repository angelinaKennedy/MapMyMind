import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:map_my_mind/entry_describer.dart';
import 'entry.dart';
import 'entry_database.dart';

class EntryViewModel extends ChangeNotifier {
  List<Entry> _entries = [];
  late EntryDatabase database;

  EntryViewModel() {
    _initiate();
  }

  void _initiate() async {
    database = await $FloorEntryDatabase.databaseBuilder('entry_database.dart').build();
    _updateEntryList();
    notifyListeners();
  }

  void _updateEntryList() async {
    _entries = await database.entryDao.getEntries();
    notifyListeners();
  }

  void addEntry(Entry entry) async {
    await database.entryDao.insertEntry(entry);
    _updateEntryList();
    notifyListeners();
  }

  void deleteEntry(int index) async {
    final toDelete = _entries[index];
    await database.entryDao.deleteEntry(toDelete);
    _updateEntryList();
    notifyListeners();
  }

  void editEntry(int index, Entry entry) async {
    await database.entryDao.updateEntry(entry);
    _updateEntryList();
    notifyListeners();
  }

  int get entryCount => _entries.length;

  List<String> get entryTitles => _entries.map((entry) => entry.entryTitle).toList();

  List<String> get entryDates => _entries.map((entry) => entry.entryDate).toList();

  List<String?> get entryContents => _entries.map((entry) => entry.entryContent).toList();

  List<List<String>> get entryImages => _entries.map((entry) => entry.entryImages).toList();

  List<String> get entryLocations => _entries.map((entry) => entry.entryLocation).toList();

  List<dynamic> get entryPosition => _entries.map((entry) => entry.entryPosition).toList();
}
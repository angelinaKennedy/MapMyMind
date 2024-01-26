import 'package:map_my_mind/entry_dao.dart';
import 'package:map_my_mind/entry_database.dart';
import 'package:mockito/mockito.dart';
import 'package:map_my_mind/entry.dart';

class MockEntryDatabase extends Mock implements EntryDatabase {
  @override
  EntryDao get entryDao => MockEntryDao();
}

class MockEntryDao extends Mock implements EntryDao {
  List<Entry> entries = [];

  @override
  Future<List<Entry>> getEntries() {
    return Future.value(entries);
  }

  @override
  Future<void> insertEntry(Entry entry) {
    entries.add(entry);
    return Future.value();
  }
}
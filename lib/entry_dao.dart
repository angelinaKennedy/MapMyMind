import 'package:floor/floor.dart';
import 'entry.dart';

@dao
abstract class EntryDao {

  @Query('SELECT * FROM Entry')
  Future<List<Entry>> getEntries();

  @insert
  Future<void> insertEntry(Entry entry);

  @delete
  Future<void> deleteEntry(Entry entry);

  @update
  Future<void> updateEntry(Entry entry);
}

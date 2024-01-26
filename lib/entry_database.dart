import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'entry_dao.dart';
import 'entry.dart';

part 'entry_database.g.dart';

@TypeConverters([ListStringConverter, LatLngConverter])
@Database(version: 1, entities: [Entry])
abstract class EntryDatabase extends FloorDatabase {
  EntryDao get entryDao;
}
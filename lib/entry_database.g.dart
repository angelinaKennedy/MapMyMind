// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorEntryDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$EntryDatabaseBuilder databaseBuilder(String name) =>
      _$EntryDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$EntryDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$EntryDatabaseBuilder(null);
}

class _$EntryDatabaseBuilder {
  _$EntryDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$EntryDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$EntryDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<EntryDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$EntryDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$EntryDatabase extends EntryDatabase {
  _$EntryDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  EntryDao? _entryDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Entry` (`title` TEXT NOT NULL, `content` TEXT NOT NULL, `date` TEXT NOT NULL, `location` TEXT NOT NULL, `images` TEXT NOT NULL, `position` TEXT, PRIMARY KEY (`title`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  EntryDao get entryDao {
    return _entryDaoInstance ??= _$EntryDao(database, changeListener);
  }
}

class _$EntryDao extends EntryDao {
  _$EntryDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _entryInsertionAdapter = InsertionAdapter(
            database,
            'Entry',
            (Entry item) => <String, Object?>{
                  'title': item.title,
                  'content': item.content,
                  'date': item.date,
                  'location': item.location,
                  'images': _listStringConverter.encode(item.images),
                  'position': _latLngConverter.encode(item.position)
                }),
        _entryUpdateAdapter = UpdateAdapter(
            database,
            'Entry',
            ['title'],
            (Entry item) => <String, Object?>{
                  'title': item.title,
                  'content': item.content,
                  'date': item.date,
                  'location': item.location,
                  'images': _listStringConverter.encode(item.images),
                  'position': _latLngConverter.encode(item.position)
                }),
        _entryDeletionAdapter = DeletionAdapter(
            database,
            'Entry',
            ['title'],
            (Entry item) => <String, Object?>{
                  'title': item.title,
                  'content': item.content,
                  'date': item.date,
                  'location': item.location,
                  'images': _listStringConverter.encode(item.images),
                  'position': _latLngConverter.encode(item.position)
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Entry> _entryInsertionAdapter;

  final UpdateAdapter<Entry> _entryUpdateAdapter;

  final DeletionAdapter<Entry> _entryDeletionAdapter;

  @override
  Future<List<Entry>> getEntries() async {
    return _queryAdapter.queryList('SELECT * FROM Entry',
        mapper: (Map<String, Object?> row) => Entry(
            row['title'] as String,
            row['content'] as String,
            row['date'] as String,
            row['location'] as String,
            _listStringConverter.decode(row['images'] as String),
            _latLngConverter.decode(row['position'] as String)));
  }

  @override
  Future<void> insertEntry(Entry entry) async {
    await _entryInsertionAdapter.insert(entry, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateEntry(Entry entry) async {
    await _entryUpdateAdapter.update(entry, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteEntry(Entry entry) async {
    await _entryDeletionAdapter.delete(entry);
  }
}

// ignore_for_file: unused_element
final _listStringConverter = ListStringConverter();
final _latLngConverter = LatLngConverter();

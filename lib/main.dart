import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:map_my_mind/entry_view_model.dart';
import 'create_diary_page.dart';
import 'entry_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp(database: await $FloorEntryDatabase.databaseBuilder('app_database.db').build()));
}

class MyApp extends StatelessWidget {
  final EntryDatabase database;
  const MyApp({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EntryViewModel(),
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: DiaryPage(),
      )
    );
  }
}
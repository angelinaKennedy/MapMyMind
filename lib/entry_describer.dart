import 'package:intl/intl.dart';
import 'entry.dart';

extension EntryDescriber on Entry {
  String get entryTitle => title;
  String? get entryContent => content;
  String get entryDate => date;
  String get entryLocation => location;
  List<String> get entryImages => images;
  dynamic get entryPosition => position;
}
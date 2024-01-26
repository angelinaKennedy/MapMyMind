import 'package:flutter_test/flutter_test.dart';
import 'package:map_my_mind/create_diary_page.dart';

import 'package:map_my_mind/main.dart';

import 'entry_database_test.mocks.dart';

void main() {
  testWidgets('MyApp runs correctly', (WidgetTester tester) async {

    final database = MockEntryDatabase();

    await tester.pumpWidget(MyApp(database: database,));

    expect(find.byType(DiaryPage), findsOneWidget);
  });
}

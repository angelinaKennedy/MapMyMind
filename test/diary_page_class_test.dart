import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:map_my_mind/add_button_to_open_new_diary.dart';
import 'package:map_my_mind/create_diary_page.dart';
import 'package:map_my_mind/display_diary_entries.dart';
import 'package:map_my_mind/entry_view_model.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';


class MockNavigatorObserver extends Mock implements NavigatorObserver {}

void main() {
  group('DiaryPage class test file', () {
    late MockNavigatorObserver mockObserver;
    final titleController = TextEditingController();
    final diaryEntry = [];

    setUp(() {
      mockObserver = MockNavigatorObserver();
    });

    Future<void> _pumpDiaryPage(WidgetTester tester) async {
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<EntryViewModel>(
              create: (_) => EntryViewModel(),
            ),
          ],
          child: MaterialApp(
            home: const DiaryPage(),
            navigatorObservers: [mockObserver],
          ),
        ),
      );
    }
    void mockSaveTheTitle() {}
    void mockCreateNewEntry() {}
    void mockSaveNewEntry(result) {
        diaryEntry.add([titleController.text, result['entryText'], result['images']]);
    }
    void mockDeleteEntry(int index) {
      diaryEntry.removeAt(index);
    }
    testWidgets('renders app bar title correctly',
            (WidgetTester tester) async {
          await _pumpDiaryPage(tester);

          final appBarTitle = find.text('MapMyMind');

          expect(appBarTitle, findsOneWidget);
        });

    testWidgets('renders add button in bottom navigation bar correctly',
            (WidgetTester tester) async {
          await _pumpDiaryPage(tester);

          final addButtonIcon = find.widgetWithIcon(CurvedNavigationBar, Icons.home_outlined).first;

          expect(addButtonIcon, findsOneWidget);
        });

    testWidgets('createNewEntry displays AddButtonForNewDiary widget', (WidgetTester tester) async {
      (WidgetTester tester) async {
        await _pumpDiaryPage(tester);

        final addButtonIcon = find.widgetWithIcon(FloatingActionButton, Icons.add_box_outlined);
        await tester.tap(addButtonIcon);
        await tester.pumpAndSettle();

        expect(find.byType(AddButtonForNewDiary), findsOneWidget);
      };
    });

    testWidgets('Testing createNewEntry() for snackbar', (WidgetTester tester) async {
          (WidgetTester tester) async {
        await _pumpDiaryPage(tester);
        titleController.text = '';
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        expect(find.byType(SnackBar), findsOneWidget);
      };
    });

    testWidgets('Testing createNewEntry() to check if onPressedSave calls saveTheTitle() when title is non-empty', (WidgetTester tester) async {
          (WidgetTester tester) async {
        await _pumpDiaryPage(tester);
        titleController.text = 'New Entry';
        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();
        expect(find.byType(AddButtonForNewDiary), findsNothing);
        verify(mockSaveTheTitle()).called(1);
      };
    });

    testWidgets('Testing createNewEntry() to verify that onPressedCancel clears the text field and close the dialog', (WidgetTester tester) async {
          (WidgetTester tester) async {
        await _pumpDiaryPage(tester);

        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();
        expect(titleController.text, isEmpty);
        expect(find.byType(AddButtonForNewDiary), findsNothing);
      };
    });

    testWidgets('Testing saveTheTitle() by having non-empty title', (WidgetTester tester) async {
      (WidgetTester tester) async {
        await _pumpDiaryPage(tester);

        final titleField = find.byKey(const Key('titleField'));
        final saveButton = find.byKey(const Key('saveButton'));

        await tester.enterText(titleField, 'My Diary Entry');
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        expect(find.byType(DiaryPage), findsOneWidget);
      };
    });

    testWidgets('Testing saveTheTitle() by having empty title', (WidgetTester tester) async {
          (WidgetTester tester) async {
        await _pumpDiaryPage(tester);

        final titleField = find.byKey(const Key('titleField'));
        final saveButton = find.byKey(const Key('saveButton'));

        await tester.enterText(titleField, '');
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        expect(find.byType(SnackBar), findsOneWidget);
        expect(find.text('Please fill in the title'), findsOneWidget);
      };
    });

    testWidgets('saving a new entry', (WidgetTester tester) async {
          (WidgetTester tester) async {
        await _pumpDiaryPage(tester);

        const title = 'Test Entry';
        const result = 'Test Result';

        mockCreateNewEntry();
        titleController.text = title;
        mockSaveTheTitle();
        mockSaveNewEntry(result[0]);

        expect(diaryEntry.length, 1);
        expect(diaryEntry[0][0], title);
        expect(diaryEntry[0][1], result[0]);
      };
    });

    testWidgets('deleting a new entry', (WidgetTester tester) async {
          (WidgetTester tester) async {
        await _pumpDiaryPage(tester);

        const title = 'Test Entry';
        const result = 'Test Result';

        mockCreateNewEntry();
        titleController.text = title;
        mockSaveTheTitle();
        mockSaveNewEntry(result);
        mockDeleteEntry(0);

        expect(diaryEntry.length, 0);
      };
    });

    testWidgets('Diary list is displayed when at least 1 entry exists', (WidgetTester tester) async {
          (WidgetTester tester) async {
        await _pumpDiaryPage(tester);

        const title = 'Test Entry';
        const result = 'Test Result';

        mockCreateNewEntry();
        titleController.text = title;
        mockSaveTheTitle();
        mockSaveNewEntry(result);

        expect(diaryEntry.length, 1);
        expect(find.byType(DiaryListDisplay), findsOneWidget);
      };
    });

    testWidgets('Test case to see if a new entry is saved with images', (WidgetTester tester) async {
      await _pumpDiaryPage(tester);

      const title = 'Test Entry';
      const result = {
        'entryText': 'Test Result',
        'images': ['image1.jpg', 'image2.jpg'],
      };

      mockCreateNewEntry();
      titleController.text = title;
      mockSaveTheTitle();
      mockSaveNewEntry(result);

      expect(diaryEntry.length, 1);
      expect(diaryEntry[0][0], title);
      expect(diaryEntry[0][1], result['entryText']);
      expect(diaryEntry[0][2], result['images']);
    });
  });
}

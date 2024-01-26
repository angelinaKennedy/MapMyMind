import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_my_mind/view_entries_in_map.dart';
import 'package:provider/provider.dart';
import 'add_button_to_open_new_diary.dart';
import 'google_maps.dart';
import 'map_entry_list.dart';
import 'new_writing_page.dart';
import 'display_diary_entries.dart';
import 'package:map_my_mind/entry_view_model.dart';
import 'package:map_my_mind/entry.dart';

class DiaryPage extends StatefulWidget {
  const DiaryPage({Key? key}) : super(key: key);

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {

  final _titleController = TextEditingController();
  int _currentIndex = 0;

  void createNewEntry() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AddButtonForNewDiary(
            titleController: _titleController,
            onPressedSave: () {saveTheTitle();},
            onPressedCancel: () {
            Navigator.of(context).pop();
            _titleController.clear();
          },
          );
        },
    );
  }

  void saveTheTitle() {
    if(_titleController.text.isNotEmpty) {
      Navigator.of(context).pop();
      viewNewOrOldPage();
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in the title')),
      );
    }
  }

  void saveNewEntry(Map<String, dynamic> result) {
    final entryVM = context.read<EntryViewModel>();
    Entry newEntry = Entry(
        _titleController.text,
        result['entryText'],
        DateFormat('MM/dd/yyyy hh:mm aaa').format(DateTime.now()),
        result['location'],
        result['images'],
        result['selectedPosition']
    );
    entryVM.addEntry(newEntry);
  }

  void saveEditedEntry(Map<String, dynamic> result, int index) {
    final entryVM = context.read<EntryViewModel>();
    if(result['entryText'] != entryVM.entryContents[index] || result['images'] != entryVM.entryImages[index] || result['location'] != entryVM.entryLocations[index] || result['selectedPosition'] != entryVM.entryPosition[index]) {
      Entry editedEntry = Entry(
          entryVM.entryTitles[index],
          result['entryText'],
          DateFormat('MM/dd/yyyy hh:mm aaa').format(DateTime.now()),
          result['location'],
          result['images'],
          result['selectedPosition']
      );
      entryVM.editEntry(index, editedEntry);
    }
  }

  Future<void>  viewNewOrOldPage({int index = -1}) async {
    late String title;
    late String creationDate;
    late String content;
    late String oldOrNewEntry;
    late List<String> photos;
    late String location;
    late dynamic position;
    final entryVM = context.read<EntryViewModel>();

    if(_titleController.text.isEmpty) {
      title = entryVM.entryTitles[index];
      creationDate = entryVM.entryDates[index];
      content = entryVM.entryContents[index]!;
      photos = entryVM.entryImages[index];
      location = entryVM.entryLocations[index];
      position = entryVM.entryPosition[index];
      oldOrNewEntry = 'old';
    }
    else {
      title = _titleController.text;
      creationDate = DateFormat('MM/dd/yyyy hh:mm aaa').format(DateTime.now());
      content = '';
      photos = [];
      location = '';
      position = '';
      oldOrNewEntry = 'new';
    }

    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (context) => WritingPage(
        titleOfTheEntry: title,
        contentOfTheEntry: content,
        creationDate: creationDate,
        savedImagePaths: photos,
        location: location,
        selectedPosition: position,
        onPressedYes: () {
          Navigator.popUntil(context, ModalRoute.withName('/'));
            if(index != -1) {
              entryVM.deleteEntry(index);
            }
          },
        onPressedNo: () {
          Navigator.of(context).pop();
          },
      ),
      ),
    );

    if (result != null && (result['images'].isNotEmpty || result['entryText'].isNotEmpty || result['location'].isNotEmpty || result['selectedPosition'])) {
      if(oldOrNewEntry == 'new') {
        saveNewEntry(result);
      }
      else if(oldOrNewEntry == 'old'){
        saveEditedEntry(result, index);
      }
    }
    if(index == -1) {
      _titleController.clear();
    }
  }

  void navigateToMapPage() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final entryVM = context.read<EntryViewModel>();
    List<LatLng> toAddLocationMarkers = [];

    if(entryVM.entryCount == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => GoogleMapStyle(locations: toAddLocationMarkers, onMarkerTapped: (LatLng ) {  },)),
      );
    }
    else {
      for (int i = 0; i < entryVM.entryCount; i++) {
        if (entryVM.entryPosition[i] != null) {
          toAddLocationMarkers.add(entryVM.entryPosition[i]);
        }
      }
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GoogleMapStyle(
            locations: toAddLocationMarkers,
            onMarkerTapped: (LatLng location) {
              final entriesOnLocation = [];
              for (int i = 0; i < entryVM.entryCount; i++) {
                if (entryVM.entryPosition[i] == location) {
                  entriesOnLocation.add([
                    entryVM.entryTitles[i],
                    entryVM.entryDates[i],
                    i
                  ]);
                }
              }
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Scaffold(
                    backgroundColor: Colors.brown.shade200,
                    appBar: AppBar(
                      centerTitle: true,
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/notebook.png',
                            scale: 12,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            'MapMyMind',
                          ),
                        ],
                      ),
                      backgroundColor: Colors.grey.shade800,
                      elevation: 0,
                      leading: IconButton (
                        icon: const Icon(
                            Icons.arrow_back_ios_rounded,
                            color: Colors.white
                        ),
                        onPressed: () { Navigator.pop(context); },
                      ),
                    ),
                    body: Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: entriesOnLocation.length,
                            itemBuilder: (context, index) {
                              return MapEntryList(
                                entryTitle: entriesOnLocation[index][0],
                                creationDate: entriesOnLocation[index][1],
                                onTapViewEntries: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                      builder: (context) => ViewEntry(index: entriesOnLocation[index][2]))
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
    setState(() {
      _currentIndex = 0;
    });
  }

@override
  Widget build(BuildContext context) {
  final entryVM = context.watch<EntryViewModel>();
  final entryTitles = entryVM.entryTitles;
  final entryDates = entryVM.entryDates;

    return Scaffold(
      backgroundColor: Colors.brown.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/notebook.png',
              scale: 12,
            ),
            const SizedBox(
              width: 10,
            ),
            const Text(
              'MapMyMind',
            ),
          ],
        ),
        backgroundColor: Colors.grey.shade800,
        elevation: 0,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewEntry,
        backgroundColor: Colors.grey.shade800,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.brown.shade200,
          color: Colors.grey.shade800,
          animationDuration: const Duration(milliseconds: 300),
          onTap: (index){
            if (index == 1) {
              navigateToMapPage();
            }
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            Icon(Icons.home_outlined, color: Colors.white),
            Icon(Icons.map_outlined, color: Colors.white)
          ],
        index: _currentIndex,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: entryVM.entryCount,
              itemBuilder: (context, index) {
                return DiaryListDisplay(
                  entryTitle: entryTitles[index],
                  creationDate: entryDates[index],
                  onPressedDelete: (context) => entryVM.deleteEntry(index),
                  onTapViewEntries: () {
                    viewNewOrOldPage(index: index);
                  }
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

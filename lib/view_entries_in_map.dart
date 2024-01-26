import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'display_images.dart';
import 'entry_view_model.dart';

class ViewEntry extends StatefulWidget {
  final int index;

  const ViewEntry({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  State<ViewEntry> createState() => _ViewEntryState();
}

class _ViewEntryState extends State<ViewEntry> {
  List<XFile> images = [];
  final _diaryEntryController = TextEditingController();

  @override
  void didChangeDependencies() {
    final entryVM = context.read<EntryViewModel>();
    _diaryEntryController.text = entryVM.entryContents[widget.index]!;
    super.didChangeDependencies();
    previousOrNewImages();
  }

  void previousOrNewImages() {
    final entryVM = context.read<EntryViewModel>();
    if(entryVM.entryImages[widget.index].isNotEmpty) {
      for (String path in entryVM.entryImages[widget.index]) {
        images.add(XFile(path));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final entryVM = context.read<EntryViewModel>();
    return Scaffold(
      backgroundColor: Colors.brown.shade200,
      appBar: AppBar(
        title: Text(entryVM.entryTitles[widget.index]),
          backgroundColor: Colors.grey.shade800,
          elevation: 0,
          centerTitle: true,
          leading: IconButton (
            icon: const Icon(
                Icons.arrow_back_ios_rounded,
                color: Colors.white
            ),
            onPressed: () { Navigator.pop(context); },
          ),
        ),
      body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column (
            children: [
              Text(entryVM.entryDates[widget.index]),
              entryVM.entryLocations[widget.index].isNotEmpty
                  ? Text('Location: ${entryVM.entryLocations[widget.index]}', textAlign: TextAlign.center,)
                  : const Text(""),
              TextField(
                controller: _diaryEntryController,
                enabled: false,
                maxLines: null,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                ),
                style: const TextStyle(
                  color: Colors.black,
                ),
              ),
              DisplayImages(
                images: images,
              )
            ],
          )
      ),
    );
  }
}

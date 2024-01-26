import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'image_detail_screen.dart';

class DisplayImages extends StatefulWidget {
  List<XFile> images;
  final Function(String)? onDeleteImage;

  DisplayImages({
    Key? key,
    required this.images,
    this.onDeleteImage
  }) : super(key: key);

  @override
  State<DisplayImages> createState() => _DisplayImagesState();
}

class _DisplayImagesState extends State<DisplayImages> {

  void _navigateToDetailScreen(XFile image) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (_) {
      return DetailScreen(
        image: image,
        onDeleteImage: widget.onDeleteImage,
      );
    }));

    if (result == true) {
      setState(() {
        widget.images.remove(image);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16
      ),
      children: [
        for (var image in widget.images)
          GestureDetector(
          onTap: () {
            _navigateToDetailScreen(image);
          }, // Image tapped
          child: Image.file(File(image.path))
        ),
      ],
    );
  }

}
//Image.file(File(widget.images[index].path))
// Image.file(File(image.path)
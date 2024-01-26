import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DetailScreen extends StatefulWidget {
  final XFile image;
  final Function(String)? onDeleteImage;

  const DetailScreen({
    Key? key,
    required this.image,
    required this.onDeleteImage,
  }) : super(key: key);

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late File _imageFile;

  @override
  void initState() {
    super.initState();
    _imageFile = File(widget.image.path);
  }

  void _deleteImage() {
    widget.onDeleteImage!(widget.image.path);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context, false);
      },
      child: Scaffold(
        backgroundColor: Colors.brown.shade200,
        appBar: AppBar (
          backgroundColor: Colors.grey.shade800,
          actions: widget.onDeleteImage != null
              ? [
                IconButton(
                  onPressed: _deleteImage,
                  icon: const Icon(Icons.delete_outline, color: Colors.white),
                ),
          ] : [],
        ),
        body: Center(
          child: Image.file(_imageFile),
        ),
      ),
    );
  }
}
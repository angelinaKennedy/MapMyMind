import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_my_mind/alert_dialog_button.dart';


class AddImageAlert extends StatelessWidget {
  final Function(ImageSource) getImageFunc;

  const AddImageAlert({
    Key? key,
    required this.getImageFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: Colors.brown.shade200,
        content: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Align(
                  alignment: Alignment.center,
                  child: Text( "Add an image",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AlertDialogButtons(
                      buttonName: "From Gallery",
                      buttonIcon: Icons.image,
                      onPressed: () async {
                        getImageFunc(ImageSource.gallery);
                        Navigator.of(context).pop();
                      },
                    ),
                    AlertDialogButtons(
                        buttonName: "From Camera",
                        buttonIcon: Icons.camera_alt,
                        onPressed: () async {
                          getImageFunc(ImageSource.camera);
                          Navigator.of(context).pop();
                        }
                    ),
                  ],
                )
              ]
          ),
        )
    );
  }
}
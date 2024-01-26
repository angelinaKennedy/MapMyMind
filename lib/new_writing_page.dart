import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:map_my_mind/alert_dialog_button.dart';
import 'package:map_my_mind/display_images.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_my_mind/add_image_alert.dart';
import 'package:map_my_mind/add_location_page.dart';

class WritingPage extends StatefulWidget {
  final String titleOfTheEntry;
  final Function() onPressedYes;
  final Function() onPressedNo;
  final String? contentOfTheEntry;
  final String creationDate;
  final List<String> savedImagePaths;
  final String? location;
  final dynamic selectedPosition;

  const WritingPage({
    Key? key,
    required this.titleOfTheEntry,
    required this.onPressedYes,
    required this.onPressedNo,
    this.contentOfTheEntry,
    required this.creationDate,
    required this.savedImagePaths,
    this.location,
    required this.selectedPosition,
  }) : super(key: key);

  @override
  State<WritingPage> createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {

  final _diaryEntryController = TextEditingController();
  List<XFile> images = [];
  final ImagePicker picker = ImagePicker();
  late List<String> imagePath;
  LatLng? userPosition = LatLng(0, 0);

  Position? _currentPosition;
  final _currentAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _diaryEntryController.text = widget.contentOfTheEntry ?? '';
    imagePath = widget.savedImagePaths.isNotEmpty ? widget.savedImagePaths : [];
    previousOrNewImages();
    _currentAddressController.text = widget.location ?? '';
    if(widget.selectedPosition != '') {
      userPosition = widget.selectedPosition;
    }
  }

  void getImage(ImageSource source) async {
    XFile? img = await picker.pickImage(source: source);
    setState(() {
      if (img != null) {
        images.add(XFile(img.path));
        imagePath.add(img.path);
      }
    });
  }

  void _getInputtedLocation(String location) {
    setState(() {
      _currentAddressController.text = location;
    });
  }

  void previousOrNewImages() {
    if(imagePath.isNotEmpty) {
      for (String path in imagePath) {
        images.add(XFile(path));
      }
    }
  }
  

  Future<void> _getCurrentPosition() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
      .then((Position position) {
        setState(() {
          _currentPosition = position;
          userPosition = LatLng(position.latitude, position.longitude);
        });
        _getAddressFromLatLng(_currentPosition!);
      }).catchError((e) {
        debugPrint(e);
      });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(_currentPosition!.latitude, _currentPosition!.longitude)
      .then((List<Placemark> placemarks) {
        Placemark place = placemarks[0];
        setState(() {
          _currentAddressController.text = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
       });
      }).catchError((e) {
        debugPrint(e);
      });
  }
  
  void deleteImage(String imgPath) {
    setState(() {
      imagePath.remove(imgPath);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown.shade200,
      appBar: AppBar(
        title: Text(widget.titleOfTheEntry),
        backgroundColor: Colors.grey.shade800,
        elevation: 0,
        centerTitle: true,
        leading: IconButton (
          onPressed: () {
            if(_diaryEntryController.text.isEmpty && images.isEmpty && _currentAddressController.text.isEmpty) {
              showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context)
              {
                return AlertDialog(
                  backgroundColor: Colors.brown.shade200,
                  content: SingleChildScrollView(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              "Do you still want to exit without adding anything to your entry?",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              AlertDialogButtons(buttonName: "Yes",
                                  onPressed: widget.onPressedYes),
                              AlertDialogButtons(buttonName: "No",
                                  onPressed: widget.onPressedNo),
                            ],
                          )
                        ]
                    ),
                  ),
                );
              },
              );
            }
            else {
              Navigator.pop(context, {
                'entryText': _diaryEntryController.text,
                'images': imagePath,
                'location':_currentAddressController.text,
                'selectedPosition': userPosition,
              });
            }
          },
          icon: const Icon(
              Icons.arrow_back_ios_rounded,
              color: Colors.white
          ),
        ),
        actions: <Widget>[
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AddImageAlert(getImageFunc: getImage);
                      }
                    );
                },
                child: const Icon(Icons.camera_alt, size: 26.0,),
              )
          ),
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: InkWell(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return GetLocation(
                          getCurrentPosition: _getCurrentPosition,
                          getInputtedPosition: _getInputtedLocation,
                          onLocationSelected: (LatLng position) {
                            setState(() {
                              userPosition = position;
                            });
                          },
                        );
                      }
                  );
                },
                child: const Icon(Icons.pin_drop_rounded, size: 26.0,),
              )
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column (
          children: [
            Text(widget.creationDate),
            _currentAddressController.text.isNotEmpty
                ? Text('Location: ${_currentAddressController.text}', textAlign: TextAlign.center,)
                : const Text(""),
            TextField(
              controller: _diaryEntryController,
              maxLines: null,
              decoration: const InputDecoration(
                hintText: "Write your thoughts here",
                border: InputBorder.none,
              ),
            ),
            DisplayImages(
                images: images,
                onDeleteImage: deleteImage,
            )
          ],
        )
      ),
    );
  }
}

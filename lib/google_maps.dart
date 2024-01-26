import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapStyle extends StatefulWidget {
  final List<LatLng> locations;
  final Function(LatLng) onMarkerTapped;

  const GoogleMapStyle({
    Key? key,
    required this.locations,
    required this.onMarkerTapped,
  }) : super(key: key);

  @override
  State<GoogleMapStyle> createState() => _GoogleMapStyleState();
}

class _GoogleMapStyleState extends State<GoogleMapStyle> {
  int _currentIndex = 1;
  late GoogleMapController _controller;
  final CameraPosition position = const CameraPosition(
    target: LatLng(47.6097, -122.3331),
    zoom: 13,
  );

  Future<void> retroMap(GoogleMapController controller) async {
    _controller = controller;
    try {
      String value = await DefaultAssetBundle.of(context)
          .loadString('assets/map_style.json');
      _controller.setMapStyle(value);
    } catch (e) {
      print('Error loading map style: $e');
    }
  }

  void navigateToHomePage() async {
    await Future.delayed(const Duration(milliseconds: 300));
    Navigator.pop(context);
  }

  void resetMap() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  Set<Marker> _buildMarkers() {
    if (widget.locations.isEmpty) {
      return <Marker>{};
    }

    return Set<Marker>.from(widget.locations.map((LatLng location) {
      return Marker(
        markerId: MarkerId(location.toString()),
        position: location,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        onTap: () {
          widget.onMarkerTapped(location);
        }
      );
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children:[
          GoogleMap(
            initialCameraPosition: position,
            onMapCreated: retroMap,
            zoomControlsEnabled: false,
            markers: _buildMarkers(),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton(
                    heroTag: 'resetButton',
                    onPressed: resetMap,
                    backgroundColor: Colors.grey.shade800,
                    child: const Icon(
                      Icons.navigation_outlined,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                CurvedNavigationBar(
                  backgroundColor: Colors.transparent,
                  color: Colors.grey.shade800,
                  animationDuration: const Duration(milliseconds: 300),
                  onTap: (index) {
                    if (index == 0) {
                      navigateToHomePage();
                      setState(() {
                        _currentIndex = index;
                      });
                    }
                  },
                  items: const [
                    Icon(Icons.home_outlined, color: Colors.white),
                    Icon(Icons.map_outlined, color: Colors.white)
                  ],
                  index: _currentIndex,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
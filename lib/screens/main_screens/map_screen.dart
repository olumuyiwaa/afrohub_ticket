import 'package:afrohub/utilities/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:lottie/lottie.dart';

import '../../utilities/widget/upcoming_events.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LocationData? _currentLocation;
  final Location _locationService = Location();

  @override
  void initState() {
    super.initState();
    _fetchLiveLocation();
  }

  Future<void> _fetchLiveLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    // Check if location service is enabled
    serviceEnabled = await _locationService.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _locationService.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    // Check location permission
    permissionGranted = await _locationService.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _locationService.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Fetch current location
    _currentLocation = await _locationService.getLocation();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _currentLocation == null
              ? Center(
                  child: Lottie.asset('assets/lottie/map.json',
                      fit: BoxFit.cover, width: 160))
              : flutter_map.FlutterMap(
                  options: flutter_map.MapOptions(
                    initialCenter: LatLng(_currentLocation!.latitude!,
                        _currentLocation!.longitude!),
                    initialZoom: 15.0,
                  ),
                  children: [
                    flutter_map.TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      fallbackUrl:
                          "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c', 'd'],
                      errorImage:
                          const AssetImage('assets/images/error_tile.png'),
                    ),
                    if (_currentLocation != null)
                      flutter_map.MarkerLayer(
                        markers: [
                          flutter_map.Marker(
                            width: 80.0,
                            height: 80.0,
                            point: LatLng(_currentLocation!.latitude!,
                                _currentLocation!.longitude!),
                            child: Icon(
                              Icons.location_history_rounded,
                              color: accentColor,
                              size: 40.0,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: UpcomingEvents(),
          ),
          Positioned(
            left: 0,
            top: 12,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.location_history_rounded,
                      color: accentColor,
                      size: 40.0,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    const Text(
                      "Your Location",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    )
                  ],
                ),
                const Row(
                  children: [
                    Icon(
                      Icons.location_pin,
                      color: Colors.red,
                      size: 40.0,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Text("Events Near You",
                        style: TextStyle(fontWeight: FontWeight.w700))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

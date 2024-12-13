import 'dart:math';
import 'dart:convert';
import 'package:_12sale_app/core/styles/style.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:widget_to_marker/widget_to_marker.dart';

class PolylineWithLabels extends StatefulWidget {
  @override
  _PolylineWithLabelsState createState() => _PolylineWithLabelsState();
}

class _PolylineWithLabelsState extends State<PolylineWithLabels> {
  GoogleMapController? _mapController;
  Set<Polyline> _polylines = {};
  List<Widget> _distanceLabels = [];
  List<LatLng> routePoints = [];
  Set<Marker> _markers = {};
  static const LatLng origin = LatLng(37.7749, -122.4194); // San Francisco, CA
  static const LatLng waypoint1 = LatLng(36.7783, -119.4179); // Fresno, CA
  static const LatLng waypoint2 = LatLng(34.0522, -118.2437); // Los Angeles, CA
  static const LatLng destination = LatLng(32.7157, -117.1611); // San Diego, CA
  // PolylinePoints polylinePoints = PolylinePoints();
  @override
  void initState() {
    super.initState();
    _initializeMarkers();
    routePoints = [origin, waypoint1, waypoint2, destination];
    _addPolyline();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _generateDistanceLabels());
  }

  void _addPolyline() {
    setState(() {
      _polylines.add(
        Polyline(
          polylineId: PolylineId('route'),
          points: routePoints,
          color: Colors.blue,
          width: 5,
          zIndex: 2,
          // patterns: [
          //   PatternItem.dash(30),
          //   PatternItem.gap(20),
          // ],
          consumeTapEvents: true,
          onTap: () {
            print('Polyline tapped!');
          },
        ),
      );
    });
  }

  void _initializeMarkers() async {
    _markers = {};
    _markers.add(
      Marker(
        markerId: MarkerId('origin'),
        position: origin,
        infoWindow: InfoWindow(
          title: 'Origin',
          snippet: 'Label: WP1',
        ),
        // icon: BitmapDescriptor.fromBytes(encodedContent),
        icon: await const CountWidget(count: 1).toBitmapDescriptor(
          logicalSize: const Size(25, 25),
          imageSize: const Size(50, 50),
        ),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('waypoint1'),
        position: waypoint1,
        infoWindow: InfoWindow(title: 'Waypoint 1'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('waypoint2'),
        position: waypoint2,
        infoWindow: InfoWindow(title: 'Waypoint 2'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow),
      ),
    );

    _markers.add(
      Marker(
        markerId: MarkerId('destination'),
        position: destination,
        infoWindow: InfoWindow(title: 'Destination'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ),
    );
    setState(() {});
  }

  Future<void> _generateDistanceLabels() async {
    if (_mapController == null) return;

    List<Widget> labels = [];
    for (int i = 0; i < routePoints.length - 1; i++) {
      LatLng start = routePoints[i];
      LatLng end = routePoints[i + 1];
      LatLng midpoint = _calculateMidpoint(start, end);

      _markers.add(
        Marker(
          markerId: MarkerId('tooltip$i'),
          position: midpoint,
          icon: await TextOnImage(
            text: "Hello World",
          ).toBitmapDescriptor(
              logicalSize: const Size(100, 100),
              imageSize: const Size(100, 100)),
          infoWindow: InfoWindow(
            title: 'Distance$i',
            snippet: '500 miles, 6 hours',
          ),
        ),
      );
      setState(() {});

      // Get distance and duration for the segment
      // final result = await _getDistanceAndDuration(start, end);
      // if (result == null) continue;

      // final String distance = result['distance'].toString();
      // final String duration = result['duration'].toString();

      // Convert LatLng midpoint to screen position
      ScreenCoordinate screenPosition =
          await _mapController!.getScreenCoordinate(end);

      labels.add(Positioned(
        left: screenPosition.x.toDouble(),
        top: screenPosition.y.toDouble(),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Column(
            children: [
              Text(
                '10',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
              Text(
                '10',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ],
          ),
        ),
      ));
    }

    setState(() {
      _distanceLabels = labels;
    });
  }

  _addPolyLine() {
    PolylineId id = PolylineId("poly");
    Polyline polyline =
        Polyline(polylineId: id, color: Colors.red, points: routePoints);
    // polylines[id] = polyline;
    setState(() {});
  }

  LatLng _calculateMidpoint(LatLng start, LatLng end) {
    return LatLng(
      (start.latitude + end.latitude) / 2,
      (start.longitude + end.longitude) / 2,
    );
  }

  Future<Map<String, String>?> _getDistanceAndDuration(
      LatLng start, LatLng end) async {
    const String apiKey = 'YOUR_GOOGLE_MAPS_API_KEY';
    final String url =
        'https://maps.googleapis.com/maps/api/distancematrix/json?origins=${start.latitude},${start.longitude}&destinations=${end.latitude},${end.longitude}&key=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final distance = data['rows'][0]['elements'][0]['distance']['text'];
      final duration = data['rows'][0]['elements'][0]['duration']['text'];
      return {'distance': distance, 'duration': duration};
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Polyline with Labels')),
      body: Stack(
        children: [
          GoogleMap(
            markers: _markers,
            initialCameraPosition: CameraPosition(
              target: origin,
              zoom: 7,
            ),
            onMapCreated: (controller) {
              setState(() {
                _mapController = controller;
              });
              _generateDistanceLabels();
            },
            polylines: _polylines,
          ),
          ..._distanceLabels,
        ],
      ),
    );
  }
}

class CountWidget extends StatelessWidget {
  const CountWidget({super.key, required this.count});
  final int count;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Styles.primaryColor,
      child: Text(
        '$count',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class TextOnImage extends StatelessWidget {
  const TextOnImage({
    super.key,
    required this.text,
  });
  final String text;
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Text(
          text,
          style: TextStyle(color: Colors.black),
        ),
        Text(
          text,
          style: TextStyle(color: Colors.black),
        )
      ],
    );
  }
}

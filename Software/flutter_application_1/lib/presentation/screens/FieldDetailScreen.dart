import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_application_1/data/services/MapService.dart';

class FieldDetailScreen extends StatefulWidget {
  final String fieldName;
  final Map<String, dynamic> fieldData;
  final String fieldId;

  const FieldDetailScreen({
    required this.fieldName,
    required this.fieldData,
    required this.fieldId,
  });

  @override
  State<FieldDetailScreen> createState() => _FieldDetailScreenState();
}

class _FieldDetailScreenState extends State<FieldDetailScreen> {
  final Set<Polygon> _polygons = {};
  final Set<Marker> _markers = {};
  GoogleMapController? _controller;
  final MapService _mapService = MapService();

  Map<String, dynamic>? latestReading;

  @override
  void initState() {
    super.initState();
    _loadField();          // existing method for polygons/markers
    _loadLatestReading();  // new method to fetch sensor values
  }

  Future<void> _loadLatestReading() async {
    final doc = await FirebaseFirestore.instance
        .collection('fields')
        .doc(widget.fieldId)
        .collection('raw_readings')
        .doc('reading-1')
        .get();

    if (doc.exists) {
      setState(() {
        latestReading = doc.data()!;
      });
    }
  }

  Future<void> _loadField() async {
    final result = await _mapService.loadFieldPolygons(
      selectedFieldId: widget.fieldId,
    );

    setState(() {
      _polygons.clear();
      _polygons.addAll(result.polygons);
      _markers.clear();
      _markers.addAll(result.markers);
    });

    if (result.selectedFieldCoords.isNotEmpty) {
      _controller?.animateCamera(
        CameraUpdate.newLatLngBounds(
          _boundsFromLatLngList(result.selectedFieldCoords),
          50,
        ),
      );
    }
  }



  LatLngBounds _boundsFromLatLngList(List<LatLng> coords) {
    final southwestLat = coords.map((c) => c.latitude).reduce((a, b) => a < b ? a : b);
    final southwestLng = coords.map((c) => c.longitude).reduce((a, b) => a < b ? a : b);
    final northeastLat = coords.map((c) => c.latitude).reduce((a, b) => a > b ? a : b);
    final northeastLng = coords.map((c) => c.longitude).reduce((a, b) => a > b ? a : b);

    return LatLngBounds(
      southwest: LatLng(southwestLat, southwestLng),
      northeast: LatLng(northeastLat, northeastLng),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// ✅ Actual Google Map here
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(7.246488, 80.163439),
              zoom: 15.0,
            ),
            polygons: _polygons,
            markers: _markers,
            onMapCreated: (controller) {
              _controller = controller;
            },
          ),

          /// ✅ Existing Back Button
          Positioned(
            top: 40,
            left: 16,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                ),
                padding: const EdgeInsets.all(8),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
            ),
          ),

          /// ✅ Sensor Panel (unchanged)
          DraggableScrollableSheet(
            initialChildSize: 0.35,
            minChildSize: 0.25,
            maxChildSize: 0.85,
            builder: (context, scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, -2))],
                ),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        DateFormat('d MMM yyyy hh:mm a').format(DateTime.now()),
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                  latestReading == null
                      ? const Center(child: CircularProgressIndicator()) // or return a SizedBox()
                      : Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 24,
                    runSpacing: 20,
                    children: [
                      _sensorBadge("Soil Moisture", "${latestReading!['soilMoisture'] ?? '--'}", Colors.brown),
                      _sensorBadge("Nitrogen", "${latestReading!['nitrogen'] ?? '--'}", Colors.pinkAccent),
                      _sensorBadge("Phosphorus", "${latestReading!['phosphorus'] ?? '--'}", Colors.lightBlue),
                      _sensorBadge("Potassium", "${latestReading!['potassium'] ?? '--'}", Colors.green),
                    ],
                  )




                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _sensorBadge(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          alignment: Alignment.center,
          child: Text(
            value,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}

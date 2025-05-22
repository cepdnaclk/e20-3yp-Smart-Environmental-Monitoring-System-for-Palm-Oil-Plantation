import 'package:flutter/material.dart';
import 'package:flutter_application_1/data/services/MapService.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class MapScreen extends StatefulWidget {
  final String? stateId;
  final String? sectionId;
  final String? fieldId;

  const MapScreen({
    this.stateId,
    this.sectionId,
    this.fieldId,
    Key? key,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final Set<Polygon> _polygons = {};
  GoogleMapController? _controller;
  final MapService _mapService = MapService();

  @override
  void initState() {
    super.initState();
    _loadAllFields();
  }

  Future<void> _loadAllFields() async {
    final result = await _mapService.loadFieldPolygons(
      selectedStateId: widget.stateId,
      selectedSectionId: widget.sectionId,
      selectedFieldId: widget.fieldId,
    );

    setState(() {
      _polygons.clear();
      _polygons.addAll(result.polygons);
    });

    if (widget.fieldId != null && result.selectedFieldCoords.isNotEmpty) {
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
      appBar: AppBar(title: const Text('All Fields Map')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(7.246488, 80.163439),
          zoom: 15.0,
        ),
        polygons: _polygons,
        onMapCreated: (controller) {
          _controller = controller;
        },
      ),
    );
  }
}
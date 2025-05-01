import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class IncidentMap extends StatefulWidget {
  final LatLng? location;

  const IncidentMap({super.key, required this.location});

  @override
  State<IncidentMap> createState() => _IncidentMapState();
}

class _IncidentMapState extends State<IncidentMap> {
  GoogleMapController? _mapController;
  LatLng? _lastLocation;

  @override
  void didUpdateWidget(covariant IncidentMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.location != null &&
        widget.location != oldWidget.location &&
        widget.location != _lastLocation &&
        _mapController != null) {
      _lastLocation = widget.location;

      _mapController!.animateCamera(
        CameraUpdate.newLatLng(widget.location!),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Incident Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 200,
            child: widget.location == null
                ? const Center(child: Text("Submit location to view on map."))
                : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: widget.location!,
                zoom: 14.5,
              ),
              onMapCreated: (controller) {
                _mapController = controller;
                _lastLocation = widget.location;
              },
              markers: {
                Marker(
                  markerId: const MarkerId('incident'),
                  position: widget.location!,
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

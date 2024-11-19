import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationPicker extends StatefulWidget {
  final LatLng? initialLocation; // Ubicación inicial opcional
  final Function(LatLng)
      onLocationSelected; // Callback al seleccionar ubicación

  const LocationPicker({
    Key? key,
    this.initialLocation,
    required this.onLocationSelected,
  }) : super(key: key);

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  late GoogleMapController _mapController;
  LatLng? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  void _onMapTap(LatLng position) {
    setState(() {
      _selectedLocation = position;
    });
    widget.onLocationSelected(position); // Notifica al padre sobre la selección
  }

  void _moveToCurrentLocation(LatLng position) {
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: position,
          zoom: 15.0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: GoogleMap(
            onMapCreated: (controller) => _mapController = controller,
            initialCameraPosition: CameraPosition(
              target: widget.initialLocation ??
                  const LatLng(4.5709, -74.2973), // Default Colombia
              zoom: 10.0,
            ),
            onTap:
                _onMapTap, // Captura la ubicación seleccionada al tocar el mapa
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: MarkerId('selected_location'),
                      position: _selectedLocation!,
                    ),
                  }
                : {},
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                _selectedLocation != null
                    ? 'Ubicación seleccionada: \nLat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}'
                    : 'No se ha seleccionado ninguna ubicación',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  if (_selectedLocation != null) {
                    widget.onLocationSelected(_selectedLocation!);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Por favor selecciona una ubicación.'),
                      ),
                    );
                  }
                },
                child: const Text('Confirmar Ubicación'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

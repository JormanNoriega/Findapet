import '../services/location_service.dart';
import '../models/location.dart';

class LocationController {
  final LocationService _service = LocationService();

  List<Location> _locations = [];
  List<String> departments = [];
  List<String> municipalities = [];

  String? selectedDepartment;
  String? selectedMunicipality;

  Future<void> initLocations() async {
    _locations = await _service.fetchLocations();
    departments = _locations.map((loc) => loc.departamento).toSet().toList();
  }

  void updateMunicipalities(String department) {
    municipalities = _locations
        .where((loc) => loc.departamento == department)
        .map((loc) => loc.municipio)
        .toList();
    selectedMunicipality = null;
  }
}

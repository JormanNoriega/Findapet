import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/location.dart'; // Asegúrate de tener el modelo `Location`

class LocationService {
  Future<List<Location>> fetchLocations() async {
    final response = await http
        .get(Uri.parse("https://www.datos.gov.co/resource/xdk5-pm3f.json"));

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Location.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load locations");
    }
  }
}

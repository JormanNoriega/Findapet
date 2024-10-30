import 'package:flutter/material.dart';
import '../../controllers/location_controller.dart'; // Ruta donde tengas el controlador

class DepartmentsPage extends StatefulWidget {
  @override
  _DepartmentsPageState createState() => _DepartmentsPageState();
}

class _DepartmentsPageState extends State<DepartmentsPage> {
  final LocationController _controller = LocationController();

  @override
  void initState() {
    super.initState();
    _controller.initLocations().then((_) {
      setState(() {}); // Refresca la vista cuando los datos están listos
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Departamentos y Municipios"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dropdown para seleccionar el departamento
            SizedBox(
              width:
                  screenWidth * 0.9, // Ajusta el ancho a un 90% de la pantalla
              child: DropdownButton<String>(
                value: _controller.selectedDepartment,
                hint: Text("Selecciona un Departamento"),
                onChanged: (String? newValue) {
                  setState(() {
                    _controller.selectedDepartment = newValue;
                    _controller.updateMunicipalities(newValue!);
                  });
                },
                items: _controller.departments.map((department) {
                  return DropdownMenuItem<String>(
                    value: department,
                    child: Flexible(
                      child: Text(
                        department,
                        overflow: TextOverflow
                            .ellipsis, // Aplica puntos suspensivos en caso de desbordamiento
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 16), // Espacio entre dropdowns

            // Dropdown para seleccionar el municipio
            SizedBox(
              width:
                  screenWidth * 0.9, // Ajusta el ancho a un 90% de la pantalla
              child: DropdownButton<String>(
                value: _controller.selectedMunicipality,
                hint: Text("Selecciona un Municipio"),
                onChanged: (String? newValue) {
                  setState(() {
                    _controller.selectedMunicipality = newValue;
                  });
                },
                items: _controller.municipalities.map((municipality) {
                  return DropdownMenuItem<String>(
                    value: municipality,
                    child: Text(
                      municipality,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

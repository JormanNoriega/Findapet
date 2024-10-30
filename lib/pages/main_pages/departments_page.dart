import 'package:flutter/material.dart';
import '../../controllers/location_controller.dart';
import '../widgets/custom_dropdown_modal.dart'; // Ruta del nuevo widget

class DepartmentsPage extends StatefulWidget {
  @override
  _DepartmentsPageState createState() => _DepartmentsPageState();
}

class _DepartmentsPageState extends State<DepartmentsPage> {
  final LocationController _controller = LocationController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller.initLocations().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  void _showSelectionModal({
    required BuildContext context,
    required String title,
    required List<String> items,
    required ValueChanged<String> onItemSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        TextEditingController searchController = TextEditingController();
        List<String> filteredItems = List.from(items);

        return StatefulBuilder(
          builder: (context, setModalState) {
            void _filterItems(String query) {
              setModalState(() {
                filteredItems = items
                    .where((item) =>
                        item.toLowerCase().contains(query.toLowerCase()))
                    .toList();
              });
            }

            return SizedBox(
              height: MediaQuery.of(context).size.height *
                  0.9, // Ajusta la altura del modal
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Fila para el título y botón de cerrar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left:
                                  8.0), // Ajusta este valor según lo necesario
                          child: Text(
                            title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          iconSize:
                              24.0, // Cambia el tamaño aquí. Puedes probar con 20.0, 28.0, etc.
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar $title'.toLowerCase(),
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onChanged: _filterItems,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: filteredItems.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(filteredItems[index]),
                            onTap: () {
                              onItemSelected(filteredItems[index]);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _openDepartmentSelector(BuildContext context) {
    _showSelectionModal(
      context: context,
      title: 'Departamento',
      items: _controller.departments,
      onItemSelected: (selectedDepartment) {
        setState(() {
          _controller.selectedDepartment = selectedDepartment;
          _controller.updateMunicipalities(selectedDepartment);
        });
      },
    );
  }

  void _openMunicipalitySelector(BuildContext context) {
    _showSelectionModal(
      context: context,
      title: 'Municipio',
      items: _controller.municipalities,
      onItemSelected: (selectedMunicipality) {
        setState(() {
          _controller.selectedMunicipality = selectedMunicipality;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text("Agregar una nueva dirección"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Departamento *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => _openDepartmentSelector(context),
                    child: CustomModalDropdownButton(
                      hint: _controller.selectedDepartment ?? "Seleccionar",
                      value: _controller.selectedDepartment,
                      width: screenWidth,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    "Municipio *",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      if (_controller.selectedDepartment != null &&
                          _controller.municipalities.isNotEmpty) {
                        _openMunicipalitySelector(context);
                      }
                    },
                    child: CustomModalDropdownButton(
                      hint: _controller.selectedMunicipality ?? "Seleccionar",
                      value: _controller.selectedMunicipality,
                      width: screenWidth,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

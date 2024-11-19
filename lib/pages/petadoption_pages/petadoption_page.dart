// ignore_for_file: prefer_const_constructors

import 'package:findapet/pages/petadoption_pages/petadoption_details_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:findapet/controllers/petadoption_controller.dart';

class PetAdoptionPage extends StatelessWidget {
  final PetAdoptionController _petAdoptionController = Get.find();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _petAdoptionController
        .fetchPetAdoption(); // Cargar los ítems cuando se construye la página
    return Scaffold(
      appBar: AppBar(
        title: Text('Mascotas en Adopción'),
      ),
      body: Column(
        children: [
          // Campo de texto para la búsqueda
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por nombre',
                suffixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                _petAdoptionController.updateSearchQuery(
                    value); // Actualizar la búsqueda en el controlador
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_petAdoptionController.filteredPetAdoptionList.isEmpty) {
                return Center(child: Text('No se encontraron ítems.'));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75, // Ajustar el tamaño de las tarjetas
                ),
                itemCount:
                    _petAdoptionController.filteredPetAdoptionList.length,
                itemBuilder: (context, index) {
                  final petAdoption =
                      _petAdoptionController.filteredPetAdoptionList[index];
                  return GestureDetector(
                    onTap: () {
                      // Navegar a PetDetailPage y pasar el petAdoption
                      Get.to(() => PetAdoptionDetailPage(pet: petAdoption));
                    },
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Imagen del ítem
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                              child: Image.network(
                                petAdoption.imageUrls.isNotEmpty
                                    ? petAdoption.imageUrls.first
                                    : '',
                                height: 100,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value:
                                          loadingProgress.expectedTotalBytes !=
                                                  null
                                              ? loadingProgress
                                                      .cumulativeBytesLoaded /
                                                  (loadingProgress
                                                          .expectedTotalBytes ??
                                                      1)
                                              : null,
                                    ),
                                  );
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(Icons.error, size: 100);
                                },
                              ),
                            ),
                          ),

                          // Detalles petAdoption
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 4),
                            child: Text(
                              petAdoption.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('Raza: ${petAdoption.breed}'),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('Ciudad: ${petAdoption.municipality}'),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}

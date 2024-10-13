// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:findapet/controllers/petlost_controller.dart';

class PetlostPage extends StatelessWidget {
  final petlostController _petlostController = Get.put(petlostController());
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    _petlostController
        .fetchPetLost(); // Cargar los ítems cuando se construye la página
    return Scaffold(
      appBar: AppBar(
        title: Text('Mascotas Perdidas'),
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
                _petlostController.updateSearchQuery(
                    value); // Actualizar la búsqueda en el controlador
              },
            ),
          ),
          Expanded(
            child: Obx(() {
              if (_petlostController.filteredPetlostList.isEmpty) {
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
                itemCount: _petlostController.filteredPetlostList.length,
                itemBuilder: (context, index) {
                  final petlost = _petlostController.filteredPetlostList[index];

                  return Card(
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
                              petlost.imageUrl,
                              height: 100,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
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

                        // Detalles petlost
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            petlost.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Raza: ${petlost.breed}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text('Ciudad: ${petlost.city}'),
                        ),
                      ],
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

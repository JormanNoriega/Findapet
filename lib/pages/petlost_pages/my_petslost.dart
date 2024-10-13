// ignore_for_file: prefer_const_constructors

import 'package:findapet/pages/petlost_pages/add_petlost.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:findapet/controllers/petlost_controller.dart';
import 'package:findapet/models/pet_model.dart';

class MyPetsLostPage extends StatelessWidget {
  final petlostController _petLostController = Get.find();

  MyPetsLostPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Obtener el ID del dueño actual

    // Llamar al método para obtener las mascotas del usuario actual
    _petLostController.fetchPetLostByOwner();

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Mascotas Perdidas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Get.to(() =>
                  AddPetlost()); // Navegar a la página de creación de ítems
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_petLostController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (_petLostController.petlostListByOwner.isEmpty) {
          return Center(
              child: Text('No tienes mascotas perdidas registradas.'));
        }

        return ListView.builder(
          itemCount: _petLostController.petlostListByOwner.length,
          itemBuilder: (context, index) {
            final pet = _petLostController.petlostListByOwner[index];

            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  children: [
                    // Imagen de la mascota
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.0),
                      child: pet.imageUrl.isNotEmpty
                          ? Image.network(
                              pet.imageUrl,
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            )
                          : Image.asset(
                              'assets/images/no_image.png',
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                            ),
                    ),
                    SizedBox(width: 16),
                    // Información de la mascota
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pet.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 6),
                          Text(
                            pet.breed,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Botones de editar y eliminar
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Get.to(() => AddPetlost(), arguments: pet);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmation(context, pet);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  // Mostrar el cuadro de confirmación para eliminar
  void _showDeleteConfirmation(BuildContext context, PetLost pet) {
    Get.defaultDialog(
      title: "Eliminar Mascota",
      middleText: "¿Estás seguro de que deseas eliminar esta mascota?",
      textCancel: "Cancelar",
      textConfirm: "Eliminar",
      confirmTextColor: Colors.white,
      onConfirm: () {
        _petLostController.deletePetLost(pet);
        Get.back(); // Cerrar el diálogo después de confirmar
      },
    );
  }
}

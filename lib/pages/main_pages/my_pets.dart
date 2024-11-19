// ignore_for_file: prefer_const_constructors

import 'package:findapet/controllers/petadoption_controller.dart';
import 'package:findapet/controllers/petlost_controller.dart';
import 'package:findapet/pages/petadoption_pages/add_petadoption_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:findapet/models/pet_model.dart';
import 'package:findapet/pages/petlost_pages/add_petlost.dart';

import 'package:findapet/pages/widgets/custom_buttom.dart';

class MyPetsPage extends StatelessWidget {
  final petlostController _petLostController = Get.find();
  final PetAdoptionController _petAdoptionController =
      Get.put(PetAdoptionController());

  MyPetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Cargar datos de ambas colecciones
    _petLostController.fetchPetLostByOwner();
    _petAdoptionController.fetchPetAdoptionByOwner();

    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Mascotas'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              _showPetTypeDialog(context);
            },
          ),
        ],
      ),
      body: Obx(() {
        if (_petLostController.isLoading.value ||
            _petAdoptionController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        final allPets = [
          ..._petLostController.petlostListByOwner,
          ..._petAdoptionController.petAdoptionListByOwner
        ];

        if (allPets.isEmpty) {
          return Center(child: Text('No tienes mascotas registradas.'));
        }

        return ListView.builder(
          itemCount: allPets.length,
          itemBuilder: (context, index) {
            final pet = allPets[index];
            return _buildPetCard(context, pet);
          },
        );
      }),
    );
  }

  // Mostrar el cuadro de diálogo para elegir el tipo de mascota
  void _showPetTypeDialog(BuildContext context) {
    Get.defaultDialog(
      title: "Seleccionar tipo de mascota",
      middleText: "¿Qué tipo de mascota quieres registrar?",
      cancel: CustomButton(
        buttonText: "Mascota Perdida",
        onPressed: () {
          Get.back();
          Get.to(() => AddPetlost());
        },
      ),
      confirm: CustomButton(
        buttonText: "Mascota en Adopción",
        onPressed: () {
          Get.back();
          Get.to(() => AddPetAdoption());
        },
      ),
    );
  }

  // Construir la tarjeta de mascota
  Widget _buildPetCard(BuildContext context, dynamic pet) {
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
              child:
                  (pet.imageUrls.isNotEmpty && pet.imageUrls.first.isNotEmpty)
                      ? Image.network(
                          pet.imageUrls.first,
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
                  Text(
                    pet is PetAdoption
                        ? 'Tipo: Adopción'
                        : 'Tipo: Mascota Perdida',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
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
                    if (pet is PetLost) {
                      Get.to(() => AddPetlost(), arguments: pet);
                    } else if (pet is PetAdoption) {
                      Get.to(() => AddPetAdoption(), arguments: pet);
                    }
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
  }

  // Mostrar el cuadro de confirmación para eliminar
  void _showDeleteConfirmation(BuildContext context, dynamic pet) {
    Get.defaultDialog(
      title: "Eliminar Mascota",
      middleText: "¿Estás seguro de que deseas eliminar esta mascota?",
      cancel: CustomButton(
        buttonText: "Cancelar",
        onPressed: () {
          Get.back();
        },
      ),
      confirm: CustomButton(
        buttonText: "Eliminar",
        onPressed: () {
          if (pet is PetLost) {
            _petLostController.deletePetLost(pet);
          } else if (pet is PetAdoption) {
            _petAdoptionController.deletePetAdoption(pet);
          }
          Get.back();
        },
      ),
    );
  }
}

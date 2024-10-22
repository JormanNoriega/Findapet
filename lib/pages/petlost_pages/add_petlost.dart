// ignore_for_file: prefer_const_constructors

import 'package:findapet/controllers/auth_controller.dart';
import 'package:findapet/models/pet_model.dart';
import 'package:findapet/pages/widgets/custom_buttom.dart';
import 'package:findapet/pages/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:findapet/controllers/petlost_controller.dart';
import 'package:intl/intl.dart';

class AddPetlost extends StatefulWidget {
  const AddPetlost({super.key});

  @override
  State<AddPetlost> createState() => _AddPetlostState();
}

class _AddPetlostState extends State<AddPetlost> {
  final petlostController _petlostController = Get.find();
  final AuthController _authController = Get.find();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _typeController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  DateTime? selectedDate;

  PetLost? currentPetlost; // petLost actual

  @override
  void initState() {
    super.initState();
    // Verificar si estamos editando un ítem
    if (Get.arguments != null) {
      currentPetlost = Get.arguments
          as PetLost; // Obtener el ítem pasado a través de Get.arguments
      _loadPetData();
    }
  }

  void _loadPetData() {
    _nameController.text = currentPetlost!.name;
    _typeController.text = currentPetlost!.type;
    _breedController.text = currentPetlost!.breed;
    _descriptionController.text = currentPetlost!.description;
    _locationController.text = currentPetlost!.location;
    _cityController.text = currentPetlost!.city;
    selectedDate = currentPetlost!.lostDate;

    if (currentPetlost!.imageUrls.isNotEmpty) {
      _petlostController.imageFiles.value = [];
    }
  }

  // Método para mostrar el diálogo de selección de imagen
  void _showImagePicker(BuildContext context) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Cámara'),
              onTap: () {
                _petlostController.pickPetLostImages(true);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Galería'),
              onTap: () {
                _petlostController.pickPetLostImages(false);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  // Método para seleccionar la fecha de pérdida
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(currentPetlost == null ? 'Agregar Mascota' : 'Editar Mascota'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Añadir SingleChildScrollView
          child: Column(
            children: [
              // Sección para seleccionar la imagen
              GestureDetector(
                onTap: () => _showImagePicker(context),
                child: Obx(() {
                  // Verificar si hay imágenes seleccionadas
                  if (_petlostController.imageFiles.isNotEmpty) {
                    // Mostrar múltiples imágenes seleccionadas en móviles (File)
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _petlostController.imageFiles.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              _petlostController.imageFiles[index],
                              height: 200,
                              width: 200,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    );
                  } else if (_petlostController.imageWebFiles.isNotEmpty) {
                    // Mostrar múltiples imágenes seleccionadas en web (Uint8List)
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _petlostController.imageWebFiles.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.memory(
                              _petlostController.imageWebFiles[index],
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    );
                  } else if (currentPetlost != null &&
                      currentPetlost!.imageUrls.isNotEmpty) {
                    // Mostrar imágenes existentes si estamos editando
                    return SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: currentPetlost!.imageUrls.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              currentPetlost!.imageUrls[index],
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    // Mostrar el contenedor para seleccionar una imagen
                    return Container(
                      height: 150,
                      color: Colors.grey[200],
                      child: Center(child: Text('Seleccionar Imagen')),
                    );
                  }
                }),
              ),
              SizedBox(height: 20),
              CustomTextField(hintText: "Nombre", controller: _nameController),
              SizedBox(height: 10),
              CustomTextField(hintText: "Raza", controller: _breedController),
              SizedBox(height: 10),
              CustomTextField(
                  hintText: "Descripción", controller: _descriptionController),
              SizedBox(height: 10),
              CustomTextField(
                  hintText: "Ubicación", controller: _locationController),
              SizedBox(height: 10),
              CustomTextField(hintText: "Ciudad", controller: _cityController),
              SizedBox(height: 10),
              // Campo de selección de fecha de pérdida
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate != null
                          ? 'Fecha de Perdida: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}'
                          : 'Seleccione la Perdida',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Obx(() {
                return _petlostController.isLoading.value
                    ? CircularProgressIndicator()
                    : CustomButton(
                        onPressed: () {
                          final name = _nameController.text;
                          final breed = _breedController.text;
                          final description = _descriptionController.text;
                          final location = _locationController.text;
                          final city = _cityController.text;
                          final type = _typeController.text;

                          if (selectedDate == null) {
                            Get.snackbar('Error',
                                'Debe seleccionar una fecha de pérdida');
                            return;
                          }

                          final ownerId = _authController.userModel.value!.uid;

                          if (currentPetlost == null) {
                            _petlostController.saveNewPetlost(
                              name,
                              type,
                              breed,
                              ownerId,
                              description,
                              city,
                              selectedDate.toString(),
                              location,
                            );
                          } else {
                            currentPetlost!.name = name;
                            currentPetlost!.breed = breed;
                            currentPetlost!.description = description;
                            currentPetlost!.location = location;
                            currentPetlost!.ownerId = ownerId;
                            currentPetlost!.city = city;
                            currentPetlost!.lostDate = selectedDate;
                            _petlostController.updatePetLost(currentPetlost!);
                          }
                        },
                        buttonText:
                            currentPetlost == null ? 'Agregar' : 'Actualizar',
                      );
              })
            ],
          ),
        ),
      ),
    );
  }
}

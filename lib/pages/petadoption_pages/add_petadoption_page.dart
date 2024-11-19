// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:findapet/controllers/auth_controller.dart';
import 'package:findapet/models/pet_model.dart';
import 'package:findapet/pages/widgets/custom_buttom.dart';
import 'package:findapet/pages/widgets/custom_dropdown.dart';
import 'package:findapet/pages/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:findapet/controllers/petadoption_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AddPetAdoption extends StatefulWidget {
  const AddPetAdoption({super.key});

  @override
  State<AddPetAdoption> createState() => _AddPetAdoptionState();
}

class _AddPetAdoptionState extends State<AddPetAdoption> {
  final PetAdoptionController _petAdoptionController = Get.find();
  final AuthController _authController = Get.find();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  PetAdoption? currentPetAdoption;
  List<String> petTypes = ['Perro', 'Gato', 'Ave', 'Conejo', 'Reptil', 'Otro'];
  String? selectedPetType;

  // Estados para los botones de alternancia
  bool isVaccinated = false;
  bool isSterilized = false;

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null) {
      currentPetAdoption = Get.arguments as PetAdoption;
      _loadPetData();
    }
  }

  void _loadPetData() {
    _nameController.text = currentPetAdoption!.name;
    _breedController.text = currentPetAdoption!.breed;
    _descriptionController.text = currentPetAdoption!.description;
    selectedPetType = currentPetAdoption!.type;
    isVaccinated = currentPetAdoption!.isVaccinated;
    isSterilized = currentPetAdoption!.isSterilized;

    if (currentPetAdoption!.imageUrls.isNotEmpty) {
      _petAdoptionController.imageFiles.value = [];
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
                _petAdoptionController.pickPetAdoptionImages(true);
                Get.back();
              },
            ),
            ListTile(
              leading: Icon(Icons.photo_library),
              title: Text('Galería'),
              onTap: () {
                _petAdoptionController.pickPetAdoptionImages(false);
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currentPetAdoption == null
            ? 'Agregar Mascota en Adopción'
            : 'Editar Mascota en Adopción'),
        backgroundColor: const Color(0xFFF0F440),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Sección para seleccionar la imagen
              GestureDetector(
                onTap: () => _showImagePicker(context),
                child: Obx(() {
                  if (_petAdoptionController.imageFiles.isNotEmpty) {
                    return SizedBox(
                      height: 150,
                      child: CarouselSlider.builder(
                        itemCount: _petAdoptionController.imageFiles.length,
                        itemBuilder: (context, index, realIndex) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              _petAdoptionController.imageFiles[index],
                              height: 250,
                              width: 250,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                        ),
                      ),
                    );
                  } else if (_petAdoptionController.imageWebFiles.isNotEmpty) {
                    return SizedBox(
                      height: 150,
                      child: CarouselSlider.builder(
                        itemCount: _petAdoptionController.imageWebFiles.length,
                        itemBuilder: (context, index, realIndex) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.memory(
                              _petAdoptionController.imageWebFiles[index],
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                        ),
                      ),
                    );
                  } else if (currentPetAdoption != null &&
                      currentPetAdoption!.imageUrls.isNotEmpty) {
                    return SizedBox(
                      height: 150,
                      child: CarouselSlider.builder(
                        itemCount: currentPetAdoption!.imageUrls.length,
                        itemBuilder: (context, index, realIndex) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(
                              currentPetAdoption!.imageUrls[index],
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                        ),
                      ),
                    );
                  } else {
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
              CustomDropdownButton(
                value: selectedPetType,
                hint: 'Seleccione una categoría',
                items: petTypes,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedPetType = newValue;
                  });
                },
              ),
              SizedBox(height: 10),
              CustomTextField(hintText: "Raza", controller: _breedController),
              SizedBox(height: 10),
              CustomTextField(
                hintText: "Añade una Descripcion....",
                controller: _descriptionController,
                minLines: 5,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: 10),
              // Botones Toggle para "Vacunado" y "Esterilizado"
              SwitchListTile(
                title: Text('Vacunado'),
                value: isVaccinated,
                onChanged: (value) {
                  setState(() {
                    isVaccinated = value;
                  });
                },
                activeColor: Colors.blue,
                inactiveThumbColor: Colors.grey,
              ),
              SwitchListTile(
                title: Text('Esterilizado'),
                value: isSterilized,
                onChanged: (value) {
                  setState(() {
                    isSterilized = value;
                  });
                },
                activeColor: Colors.blue,
                inactiveThumbColor: Colors.grey,
              ),
              SizedBox(height: 25),
              Obx(() {
                return _petAdoptionController.isLoading.value
                    ? CircularProgressIndicator()
                    : CustomButton(
                        onPressed: _handleSaveOrUpdate,
                        buttonText: currentPetAdoption == null
                            ? "Agregar"
                            : "Actualizar",
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSaveOrUpdate() {
    final name = _nameController.text;
    final breed = _breedController.text;
    final description = _descriptionController.text;
    final department = _authController.userModel.value!.department;
    final municipality = _authController.userModel.value!.municipality;
    final ownerId = _authController.userModel.value!.uid;

    if (selectedPetType == null) {
      Get.snackbar('Error', 'Debe seleccionar un tipo de mascota');
      return;
    }

    if (_petAdoptionController.imageFiles.isEmpty &&
        (currentPetAdoption == null || currentPetAdoption!.imageUrls.isEmpty)) {
      Get.snackbar('Error', 'Debe seleccionar al menos una imagen');
      return;
    }

    if (currentPetAdoption == null) {
      _petAdoptionController.saveNewPetAdoption(
        name,
        selectedPetType!,
        breed,
        ownerId,
        description,
        department,
        municipality,
        isVaccinated,
        isSterilized,
      );
    } else {
      currentPetAdoption!.name = name;
      currentPetAdoption!.type = selectedPetType!;
      currentPetAdoption!.breed = breed;
      currentPetAdoption!.description = description;
      currentPetAdoption!.department = department;
      currentPetAdoption!.municipality = municipality;
      currentPetAdoption!.isVaccinated = isVaccinated;
      currentPetAdoption!.isSterilized = isSterilized;
      _petAdoptionController.updatePetAdoption(currentPetAdoption!);
    }
  }

}

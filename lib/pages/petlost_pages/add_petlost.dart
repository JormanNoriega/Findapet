// ignore_for_file: prefer_const_constructors
import 'package:findapet/controllers/auth_controller.dart';
import 'package:findapet/models/pet_model.dart';
import 'package:findapet/pages/widgets/custom_buttom.dart';
import 'package:findapet/pages/widgets/custom_dropdown.dart';
import 'package:findapet/pages/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:findapet/controllers/petlost_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AddPetlost extends StatefulWidget {
  const AddPetlost({super.key});

  @override
  State<AddPetlost> createState() => _AddPetlostState();
}

class _AddPetlostState extends State<AddPetlost> {
  final petlostController _petlostController = Get.find();
  final AuthController _authController = Get.find();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _breedController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  //late GoogleMapController mapController;
  DateTime? selectedDate;
  LatLng? _selectedLocation;
  LatLng _initialPosition = const LatLng(4.5709, -74.2973);
  PetLost? currentPetlost;
  // Lista de tipos de mascotas más comunes
  List<String> petTypes = ['Perro', 'Gato', 'Ave', 'Conejo', 'Reptil', 'Otro'];

  // Variable para almacenar el tipo de mascota seleccionado
  String? selectedPetType;

  @override
  void initState() {
    super.initState();
    // Verificar si estamos editando una mascota perdida
    if (Get.arguments != null) {
      currentPetlost = Get.arguments
          as PetLost; // Obtener la mascota pasado a través de Get.arguments
      _loadPetData();
    } else {
      _getCurrentLocation();
    }
  }

  void _loadPetData() {
    _nameController.text = currentPetlost!.name;
    _breedController.text = currentPetlost!.breed;
    _descriptionController.text = currentPetlost!.description;
    _locationController.text = currentPetlost!.location;
    selectedDate = currentPetlost!.lostDate;
    _selectedLocation =
        LatLng(currentPetlost!.latitude!, currentPetlost!.longitude!);
    _initialPosition = _selectedLocation!;
    // Si estamos editando una mascota perdida, llenamos el tipo de mascota
    selectedPetType = currentPetlost!.type;
    _selectedLocation =
        LatLng(currentPetlost!.latitude!, currentPetlost!.longitude!);

    if (currentPetlost!.imageUrls.isNotEmpty) {
      _petlostController.imageFiles.value = [];
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verificar que los servicios de ubicación están habilitados
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Los servicios de ubicación están deshabilitados.');
    }

    // Verificar y solicitar permisos
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Permiso de ubicación denegado.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Permiso de ubicación permanentemente denegado.');
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
    });
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
                  // Verificar si hay imágenes seleccionadas
                  if (_petlostController.imageFiles.isNotEmpty) {
                    return SizedBox(
                      height: 150,
                      child: CarouselSlider.builder(
                        itemCount: _petlostController.imageFiles.length,
                        itemBuilder: (context, index, realIndex) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              _petlostController.imageFiles[index],
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
                          onPageChanged: (index, reason) {
                            // Puedes manejar el cambio de página aquí si es necesario
                          },
                        ),
                      ),
                    );
                  } else if (_petlostController.imageWebFiles.isNotEmpty) {
                    return SizedBox(
                      height: 150,
                      child: CarouselSlider.builder(
                        itemCount: _petlostController.imageWebFiles.length,
                        itemBuilder: (context, index, realIndex) {
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
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                          onPageChanged: (index, reason) {
                            // Puedes manejar el cambio de página aquí si es necesario
                          },
                        ),
                      ),
                    );
                  } else if (currentPetlost != null &&
                      currentPetlost!.imageUrls.isNotEmpty) {
                    // Mostrar imágenes existentes si estamos editando
                    return SizedBox(
                      height: 150,
                      child: CarouselSlider.builder(
                        itemCount: currentPetlost!.imageUrls.length,
                        itemBuilder: (context, index, realIndex) {
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
                        options: CarouselOptions(
                          autoPlay: true,
                          enlargeCenterPage: true,
                          aspectRatio: 16 / 9,
                          onPageChanged: (index, reason) {
                            // Puedes manejar el cambio de página aquí si es necesario
                          },
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

              // Campo de selección de tipo de mascota
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
                  hintText: "Ubicación", controller: _locationController),
              SizedBox(height: 10),
              CustomTextField(
                hintText: "Añade una Descripcion....",
                controller: _descriptionController,
                minLines: 5,
                maxLines: null,
                keyboardType: TextInputType.multiline,
              ),
              SizedBox(height: 10),
              // Campo de selección de fecha de pérdida
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDate != null
                          ? 'Fecha de Perdida: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}'
                          : 'Seleccione la Fecha de Perdida',
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context),
                  ),
                ],
              ),
              SizedBox(height: 20),
              _buildMapWidget(),
              SizedBox(height: 25),
              Obx(() {
                return _petlostController.isLoading.value
                    ? CircularProgressIndicator()
                    : CustomButton(
                        onPressed: () {
                          _handleSaveOrUpdate();
                        },
                        buttonText:
                            currentPetlost == null ? "Agregar" : "Actualizar",
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
    final location = _locationController.text;
    final department = _authController.userModel.value!.department;
    final municipality = _authController.userModel.value!.municipality;

    if (selectedDate == null) {
      Get.snackbar('Error', 'Debe seleccionar una fecha de pérdida');
      return;
    }

    if (selectedPetType == null) {
      Get.snackbar('Error', 'Debe seleccionar un tipo de mascota');
      return;
    }

    if (_petlostController.imageFiles.isEmpty &&
        (currentPetlost == null || currentPetlost!.imageUrls.isEmpty)) {
      Get.snackbar('Error', 'Debe seleccionar al menos una imagen');
      return;
    }

    if (_selectedLocation == null) {
      Get.snackbar('Error', 'Debe seleccionar una ubicación en el mapa');
      return;
    }

    final ownerId = _authController.userModel.value!.uid;

    if (currentPetlost == null) {
      _petlostController.saveNewPetlost(
        name,
        selectedPetType!,
        breed,
        ownerId,
        description,
        department,
        municipality,
        selectedDate.toString(),
        location,
        _selectedLocation!.latitude, // Latitud
        _selectedLocation!.longitude, // Longitud
      );
    } else {
      currentPetlost!.name = name;
      currentPetlost!.type = selectedPetType!;
      currentPetlost!.breed = breed;
      currentPetlost!.description = description;
      currentPetlost!.location = location;
      currentPetlost!.ownerId = ownerId;
      currentPetlost!.department = _authController.userModel.value!.department;
      currentPetlost!.municipality =
          _authController.userModel.value!.municipality;
      currentPetlost!.lostDate = selectedDate;
      currentPetlost!.latitude = _selectedLocation!.latitude;
      currentPetlost!.longitude = _selectedLocation!.longitude;
      _petlostController.updatePetLost(currentPetlost!);
    }
  }

  Widget _buildMapWidget() {
    return SizedBox(
      height: 300,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue, // Color del borde
            width: 1, // Grosor del borde
          ),
          borderRadius: BorderRadius.circular(15), // Bordes redondeados
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(
              15), // Asegura el redondeado dentro del borde
          child: GoogleMap(
            myLocationEnabled: true,
            scrollGesturesEnabled: true, // Permite mover el mapa
            zoomGesturesEnabled: true,
            onMapCreated: (controller) {
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: _initialPosition,
                    zoom: 15,
                  ),
                ),
              );
            },
            onTap: (position) {
              setState(() {
                _selectedLocation = position;
              });
            },
            initialCameraPosition: CameraPosition(
              target: _initialPosition,
              zoom: 12,
            ),
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: const MarkerId('selected_location'),
                      position: _selectedLocation!,
                    ),
                  }
                : {},
          ),
        ),
      ),
    );
  }
}

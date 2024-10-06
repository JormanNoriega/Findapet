import 'package:image_picker/image_picker.dart';
import '../../controllers/auth_controller.dart';
import '../widgets/custom_text_field.dart'; // Importa el widget de campo de texto personalizado
import '../widgets/country_selector.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_buttom.dart'; // Importa el widget de botón personalizado
import '../../models/user_model.dart';
import 'package:get/get.dart';
import 'dart:io';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final AuthController _authController = Get.find<AuthController>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  String? _selectedCountry; // Almacena el país seleccionado
  File? _selectedImage; // Imagen seleccionada por el usuario

  @override
  void initState() {
    super.initState();
    // Inicializa los campos con los datos del usuario
    _nameController.text = _authController.userModel.value?.name ?? '';
    _lastNameController.text = _authController.userModel.value?.lastName ?? '';
    _phoneController.text = _authController.userModel.value?.phone ?? '';
    _selectedCountry = _authController.userModel.value?.country;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    String name = _nameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String phone = _phoneController.text.trim();
    String country = _selectedCountry ?? '';

    if (name.isEmpty || lastName.isEmpty || phone.isEmpty || country.isEmpty) {
      Get.snackbar("Error", "Los campos no pueden estar vacíos");
      return;
    }

    try {
      // Actualizar los datos del usuario
      await _authController.updateUserProfile(lastName, phone, country);

      // Si se ha seleccionado una imagen, subirla y actualizar la URL
      if (_selectedImage != null) {
        await _authController.updateProfileImage(_selectedImage!);
      }

      Get.snackbar("Éxito", "Perfil actualizado correctamente");
    } catch (e) {
      Get.snackbar("Error", "No se pudo actualizar el perfil");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Editar Perfil',
          style: const TextStyle(
            fontSize: 20, // Cambia el tamaño de fuente aquí
            fontWeight: FontWeight.bold, // Si deseas ajustar el grosor
          ),
        ),
      ),
      body: SingleChildScrollView(
        // Agregar SingleChildScrollView para permitir desplazamiento
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          UserModel? user = _authController.userModel.value;

          if (user == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // Imagen de perfil
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 80,
                  backgroundImage: _selectedImage != null
                      ? FileImage(_selectedImage!)
                      : (user.profileImageUrl != null
                          ? NetworkImage(user.profileImageUrl!)
                          : null), // Si no hay imagen, dejar el fondo vacío
                  child: _selectedImage == null && user.profileImageUrl == null
                      ? const Icon(Icons.person,
                          size:
                              80) // Mostrar un ícono de persona si no hay imagen
                      : null,
                ),
              ),

              const SizedBox(height: 16),
              // Campo para mostrar el correo electrónico (no editable)
              CustomTextField(
                hintText: 'Correo Electrónico',
                controller: TextEditingController(text: user.email),
                obscureText: false,
                readOnly: true,
              ),
              const SizedBox(height: 16),
              // Campo de texto para el nombre
              CustomTextField(
                hintText: 'Nombre',
                controller: _nameController,
                obscureText: false,
              ),
              const SizedBox(height: 16),
              // Campo de texto para el apellido
              CustomTextField(
                hintText: 'Apellido',
                controller: _lastNameController,
                obscureText: false,
              ),
              const SizedBox(height: 16),
              // Campo de texto para el teléfono
              CustomTextField(
                hintText: 'Teléfono',
                controller: _phoneController,
                obscureText: false,
              ),
              const SizedBox(height: 16),
              // Selector de país
              CountrySelector(
                selectedCountry: _selectedCountry,
                onCountrySelected: (country) {
                  setState(() {
                    _selectedCountry = country; // Guarda el país seleccionado
                  });
                },
              ),

              const SizedBox(height: 16),
              CustomButton(
                onPressed: _updateProfile,
                buttonText: 'Guardar cambios',
              ),
            ],
          );
        }),
      ),
    );
  }
}

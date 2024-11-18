import '../../controllers/auth_controller.dart';
import '../../controllers/location_controller.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dropdown_modal.dart'; // Ruta del widget
import '../widgets/social_buttons.dart';
import 'package:flutter/material.dart';
import '../auth_pages/login_page.dart';
import '../widgets/custom_buttom.dart';
import 'package:get/get.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthController _authController = Get.put(AuthController());
  final LocationController _locationController = LocationController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    _locationController.initLocations().then((_) {
      setState(() {});
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
              height: MediaQuery.of(context).size.height * 0.9,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            title,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Buscar $title',
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                const Text(
                  'Findapet',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  'Crear una cuenta',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Nombre',
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: _confirmPasswordController,
                  hintText: 'Confirmar Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () => _showSelectionModal(
                    context: context,
                    title: 'Departamento',
                    items: _locationController.departments,
                    onItemSelected: (selectedDepartment) {
                      setState(() {
                        _locationController.selectedDepartment =
                            selectedDepartment;
                        _locationController
                            .updateMunicipalities(selectedDepartment);
                      });
                    },
                  ),
                  child: CustomModalDropdownButton(
                    hint: _locationController.selectedDepartment ??
                        "Departamento",
                    value: _locationController.selectedDepartment,
                    width: screenWidth,
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: () {
                    if (_locationController.selectedDepartment != null &&
                        _locationController.municipalities.isNotEmpty) {
                      _showSelectionModal(
                        context: context,
                        title: 'Municipio',
                        items: _locationController.municipalities,
                        onItemSelected: (selectedMunicipality) {
                          setState(() {
                            _locationController.selectedMunicipality =
                                selectedMunicipality;
                          });
                        },
                      );
                    }
                  },
                  child: CustomModalDropdownButton(
                    hint:
                        _locationController.selectedMunicipality ?? "Municipio",
                    value: _locationController.selectedMunicipality,
                    width: screenWidth,
                  ),
                ),
                const SizedBox(height: 40),
                Obx(() => _authController.isLoading.value
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        onPressed: () {
                          String name = _nameController.text.trim();
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();
                          String confirmPassword =
                              _confirmPasswordController.text.trim();
                          if (password != confirmPassword) {
                            Get.snackbar(
                              'Error',
                              'Las contraseñas no coinciden',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            return;
                          }
                          _authController.register(
                            email,
                            password,
                            name,
                            _locationController.selectedDepartment ?? '',
                            _locationController.selectedMunicipality ?? '',
                          );
                        },
                        buttonText: 'Registrarse',
                      )),
                const SizedBox(height: 20),
                const Text(
                  'o inicie sesión con',
                  style: TextStyle(
                    color: Color(0xFFA7A7A7),
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                SocialButtons(
                  onGoogleTap: () {},
                  onFacebookTap: () {},
                ),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => Get.to(LoginPage()),
                  child: const Text(
                    '¿Ya tienes cuenta? Inicia sesión',
                    style: TextStyle(
                      color: Color(0xFFA7A7A7),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

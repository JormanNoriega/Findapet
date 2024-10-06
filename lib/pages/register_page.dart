import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../pages/login_page.dart';
import './widgets/custom_buttom.dart'; // Botón personalizado
import './widgets/custom_text_field.dart'; // Campo de texto personalizado
import './widgets/social_buttons.dart';

class RegisterPage extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                // Título de la app centrado
                const Text(
                  'Findapet',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 40),

                // Texto de "Crear una cuenta"
                const Text(
                  'Crear una cuenta',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center, // Centra el texto
                ),
                const SizedBox(height: 20),

                // Campo de texto personalizado para nombre
                CustomTextField(
                  controller: _nameController,
                  hintText: 'Nombre',
                ),
                const SizedBox(height: 20),

                // Campo de texto personalizado para email
                CustomTextField(
                  controller: _emailController,
                  hintText: 'Email',
                ),
                const SizedBox(height: 20),

                // Campo de texto personalizado para contraseña
                CustomTextField(
                  controller: _passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 40),

                // Botón de registro personalizado
                Obx(() => _authController.isLoading.value
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        onPressed: () {
                          String name = _nameController.text.trim();
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();
                          _authController.register(email, password, name);
                        },
                        buttonText: 'Registrarse',
                      )),
                const SizedBox(height: 20),

                // Texto "o inicie sesión con"
                const Text(
                  'o inicie sesión con',
                  style: TextStyle(
                    color: Color(0xFFA7A7A7),
                    fontSize: 16.0,
                  ),
                  textAlign: TextAlign.center, // Centra el texto
                ),

                const SizedBox(height: 20),

                // Botones de redes sociales
                SocialButtons(
                  onGoogleTap: () {
                    // aquí agregar la logica de inicio con Google
                  },
                  onFacebookTap: () {
                    // aquí agregar la logica de inicio con Facebook
                  },
                ),

                const SizedBox(height: 30),

                // Enlace para iniciar sesión
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

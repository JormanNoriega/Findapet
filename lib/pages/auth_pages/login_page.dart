import '../../controllers/auth_controller.dart';
import '../auth_pages/register_page.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/social_buttons.dart';
import 'package:flutter/material.dart';
import '../widgets/custom_buttom.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key});

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

                // Texto de "Acceder a su cuenta"
                const Text(
                  'Acceder a su cuenta',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center, // Centra el texto
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

                // Botón de inicio de sesión personalizado
                Obx(() => _authController.isLoading.value
                    ? const CircularProgressIndicator()
                    : CustomButton(
                        onPressed: () {
                          String email = _emailController.text.trim();
                          String password = _passwordController.text.trim();
                          _authController.login(email, password);
                        },
                        buttonText: 'Iniciar Sesión',
                      )),
                const SizedBox(height: 20),

                const Text(
                  'o inicie sesión con',
                  style: TextStyle(
                    color: const Color(0xFFA7A7A7),
                    fontSize: 16.0,
                  ),
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

                const SizedBox(height: 40),

                // Enlace para registro
                GestureDetector(
                  onTap: () => Get.to(RegisterPage()),
                  child: const Text(
                    '¿No tiene una cuenta? Regístrese',
                    style: TextStyle(
                      color: const Color(0xFFA7A7A7),
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

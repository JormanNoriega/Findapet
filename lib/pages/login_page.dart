import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../pages/register_page.dart';
import './widgets/custom_buttom.dart'; // Importa el widget de campo de texto
import './widgets/custom_text_field.dart'; // Importa el widget de botón

class LoginPage extends StatelessWidget {
  final AuthController _authController =
      Get.put(AuthController()); // Obtener el controlador
  final TextEditingController _emailController =
      TextEditingController(); // Controlador para el email
  final TextEditingController _passwordController = TextEditingController();

  LoginPage({super.key}); // Controlador para la contraseña

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text(
                'Login',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 40),

              // Utiliza el widget personalizado CustomTextField
              CustomTextField(
                controller: _emailController,
                hintText: 'Email',
              ),

              const SizedBox(height: 20),

              // Utiliza el widget personalizado CustomTextField para la contraseña
              CustomTextField(
                controller: _passwordController,
                hintText: 'Contraseña',
                obscureText: true,
              ),

              const SizedBox(height: 40),

              // Utiliza el widget personalizado CustomLoginButton
              Obx(() => _authController.isLoading.value
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Mostrar el indicador de carga
                  : CustomButton(
                      onPressed: () {
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();
                        _authController.login(email,
                            password); // Llamar al método de login en el controlador
                      },
                      buttonText: 'Iniciar Sesión',
                    )),

              const Spacer(),

              Center(
                child: GestureDetector(
                  onTap: () =>
                      Get.to(RegisterPage()), // Navegar a la vista de registro
                  child: Text(
                    '¿No tienes cuenta? Regístrate',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

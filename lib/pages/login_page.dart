import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../pages/register_page.dart';

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
              _buildTextField(context, 'Email', _emailController),
              const SizedBox(height: 20),
              _buildTextField(context, 'Contraseña', _passwordController,
                  obscureText: true),
              const SizedBox(height: 40),
              Obx(() => _authController.isLoading.value
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Mostrar el indicador de carga
                  : _buildLoginButton(context)),
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

  // Método para construir los campos de texto
  Widget _buildTextField(
      BuildContext context, String hintText, TextEditingController controller,
      {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: hintText,
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
    );
  }

  // Método para el botón de inicio de sesión
  Widget _buildLoginButton(BuildContext context) {
    return Center(
      child: FilledButton(
        onPressed: () {
          String email = _emailController.text.trim();
          String password = _passwordController.text.trim();
          _authController.login(
              email, password); // Llamar al método de login en el controlador
        },
        child: const Text(
          'Iniciar Sesión',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

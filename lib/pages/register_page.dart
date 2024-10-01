import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import './widgets/custom_text_field.dart'; // Importa el widget de campo de texto
import './widgets/custom_buttom.dart'; // Importa el widget de botón

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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Text(
                'Registro',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 40),

              // Utiliza el widget personalizado CustomTextField
              CustomTextField(
                controller: _nameController,
                hintText: 'Nombre',
              ),

              const SizedBox(height: 20),

              // Utiliza el widget personalizado CustomTextField para el email
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
                  ? const Center(child: CircularProgressIndicator())
                  : CustomButton(
                      onPressed: () {
                        String name = _nameController.text.trim();
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();
                        _authController.register(email, password, name);
                      },
                      buttonText: 'Registrarse',
                    )),

              const Spacer(),

              Center(
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Text(
                    '¿Ya tienes cuenta? Inicia sesión',
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

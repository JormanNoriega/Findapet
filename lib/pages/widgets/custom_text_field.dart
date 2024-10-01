import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color:
                Colors.grey.withOpacity(0.3), // Color de la sombra con opacidad
            spreadRadius: 2, // Radio de la sombra
            blurRadius: 2, // Desenfoque de la sombra
            offset: const Offset(0, 2), // Desplazamiento de la sombra
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: const TextStyle(
            color: Color(0xFFA7A7A7), // Color #A7A7A7
          ),
          filled: true,
          fillColor:
              Colors.transparent, // Cambiar a transparente para ver la sombra
          border: InputBorder.none, // Quitar el borde para usar el contenedor
        ),
      ),
    );
  }
}

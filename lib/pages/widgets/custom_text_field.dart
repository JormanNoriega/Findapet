import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final bool readOnly;
  final bool enabled;
  final Widget? suffixIcon; // Agregamos el parámetro suffixIcon
  final Function(String)? onChanged; // Agregamos el parámetro onChanged
  final FocusNode? focusNode; // Agregamos el parámetro focusNode

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.readOnly = false,
    this.enabled = true,
    this.suffixIcon, // Constructor para suffixIcon
    this.onChanged, // Constructor para onChanged
    this.focusNode, // Constructor para focusNode
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), // Sombra con opacidad
            spreadRadius: 2,
            blurRadius: 2,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        readOnly: readOnly,
        enabled: enabled,
        onChanged: onChanged, // Pasamos el onChanged al TextField
        focusNode: focusNode, // Asignamos el focusNode al TextField
        decoration: InputDecoration(
          labelText: hintText,
          labelStyle: const TextStyle(
            color: Color(0xFFA7A7A7), // Color del hint
          ),
          filled: true,
          fillColor: Colors.transparent,
          border: InputBorder.none,
          suffixIcon: suffixIcon, // Usamos suffixIcon como parámetro opcional
        ),
      ),
    );
  }
}

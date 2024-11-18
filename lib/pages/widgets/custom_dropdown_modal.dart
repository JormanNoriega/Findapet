import 'package:flutter/material.dart';

class CustomModalDropdownButton extends StatelessWidget {
  final String? value;
  final String hint;
  final double width;
  final double height;

  const CustomModalDropdownButton({
    Key? key,
    required this.value,
    required this.hint,
    this.width = 350.0, // Ancho predeterminado
    this.height = 50.0, // Alto predeterminado
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 2,
              blurRadius: 2,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              value ?? hint,
              style: TextStyle(
                color: value == null ? Colors.grey : Colors.black,
                fontSize: 16,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
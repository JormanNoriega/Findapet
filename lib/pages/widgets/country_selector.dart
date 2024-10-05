import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';

class CountrySelector extends StatelessWidget {
  final String? selectedCountry;
  final Function(String) onCountrySelected;

  const CountrySelector({
    super.key,
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _showCountryPicker(context),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Color de la sombra
              spreadRadius: 2, // Radio de la sombra
              blurRadius: 2, // Desenfoque de la sombra
              offset: const Offset(0, 2), // Desplazamiento de la sombra
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              selectedCountry?.isNotEmpty == true
                  ? selectedCountry!
                  : 'Selecciona un país',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFFA7A7A7), // Color #A7A7A7 para el texto
              ),
            ),
            const Icon(Icons.arrow_drop_down, color: Color(0xFFA7A7A7)),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      onSelect: (country) {
        onCountrySelected(country.name);
      },
    );
  }
}

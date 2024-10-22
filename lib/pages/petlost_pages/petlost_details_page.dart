import 'package:flutter/material.dart';
import 'package:findapet/models/pet_model.dart';

class PetDetailPage extends StatelessWidget {
  final Pet pet; // Recibimos el modelo de mascota

  PetDetailPage({required this.pet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pet.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen de la mascota
            Image.network(
              pet.imageUrls.first,
              fit: BoxFit.cover,
              height: 250,
              width: double.infinity,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes != null
                        ? loadingProgress.cumulativeBytesLoaded /
                            (loadingProgress.expectedTotalBytes ?? 1)
                        : null,
                  ),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Icon(Icons.error, size: 250);
              },
            ),

            SizedBox(height: 16),
            // Nombre de la mascota
            Text(
              pet.name,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Raza: ${pet.breed}'),
            Text('Ciudad: ${pet.city}'),
            //Text('Estado: ${pet.status}'), // Si implementaste el campo estado
            Text('Descripción: ${pet.description}'), // Si tienes un campo descripción

            Spacer(), // Para empujar el botón hacia el final
            ElevatedButton(
              onPressed: () {
                // Funcionalidad del botón (por ahora no tendrá nada)
              },
              child: Text('Contactar'),
            ),
          ],
        ),
      ),
    );
  }
}

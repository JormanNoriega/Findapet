import 'package:flutter/material.dart';

class PetCard extends StatelessWidget {
  final String name;
  final String reward;
  final String imageUrl;

  PetCard({required this.name, required this.reward, required this.imageUrl});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Nombre: $name",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("Recompensa: $reward"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

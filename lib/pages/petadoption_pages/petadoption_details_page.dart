// ignore_for_file: prefer_const_constructors

import 'package:findapet/pages/chat_pages/chat_page.dart';
import 'package:findapet/pages/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:findapet/models/pet_model.dart';
import 'package:get/get.dart';

class PetAdoptionDetailPage extends StatefulWidget {
  final PetAdoption pet;

  PetAdoptionDetailPage({required this.pet});

  @override
  _PetAdoptionDetailPageState createState() => _PetAdoptionDetailPageState();
}

class _PetAdoptionDetailPageState extends State<PetAdoptionDetailPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.pet.name),
        backgroundColor: const Color(0xFFF0F440),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Carousel de imágenes de la mascota
              CarouselSlider(
                options: CarouselOptions(
                  height: 250,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
                items: widget.pet.imageUrls.map((url) {
                  return Builder(
                    builder: (BuildContext context) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.error, size: 250);
                          },
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 10),
              // Indicador personalizado
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: widget.pet.imageUrls.asMap().entries.map((entry) {
                  return GestureDetector(
                    onTap: () => _onDotTap(entry.key),
                    child: Container(
                      width: 12.0,
                      height: 12.0,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: (Theme.of(context).brightness == Brightness.dark
                                ? Colors.white
                                : Colors.black)
                            .withOpacity(
                                _currentIndex == entry.key ? 0.9 : 0.4),
                      ),
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 16),
              // Detalles de la mascota
              _buildPetDetails(),
              SizedBox(height: 16),
              CustomButton(
                onPressed: () {
                  Get.to(() => ChatPage(
                        receiverID: widget.pet.ownerId,
                      ));
                },
                buttonText: "Contacto",
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPetDetails() {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Detalles de la Mascota",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildDetailRow(Icons.pets, "Tipo de mascota: ${widget.pet.type}"),
            _buildDetailRow(Icons.pets_outlined, 'Raza: ${widget.pet.breed}'),
            _buildDetailRow(
                Icons.location_city, 'Municipio: ${widget.pet.municipality}'),
            _buildDetailRow(Icons.health_and_safety,
                'Vacunado: ${widget.pet.isVaccinated ? "Sí" : "No"}'),
            _buildDetailRow(Icons.medical_services,
                'Esterilizado: ${widget.pet.isSterilized ? "Sí" : "No"}'),
            _buildDetailRow(
                Icons.description, 'Descripción: ${widget.pet.description}'),
          ],
        ),
      ),
    );
  }

  // Método para construir una fila de detalle con icono y texto
  Widget _buildDetailRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue, size: 20), // Icono para el detalle
          const SizedBox(width: 8), // Espaciado entre icono y texto
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54, // Color gris para el texto
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _onDotTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

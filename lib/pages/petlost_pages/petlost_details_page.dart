import 'package:findapet/pages/chat_pages/chat_page.dart';
import 'package:findapet/pages/widgets/custom_buttom.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:findapet/models/pet_model.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class PetDetailPage extends StatefulWidget {
  final PetLost pet;

  PetDetailPage({required this.pet});

  @override
  _PetDetailPageState createState() => _PetDetailPageState();
}

class _PetDetailPageState extends State<PetDetailPage> {
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
          // Agregado aquí
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
              // Mostrar la ubicación seleccionada en un mapa
              _buildLocationMap(),
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
                Icons.location_city, 'Munucipio: ${widget.pet.municipality}'),
            _buildDetailRow(Icons.date_range,
                'Fecha de pérdida: ${_formatDate(widget.pet.lostDate)}'),
            _buildDetailRow(
                Icons.pin_drop, "Ubicación: ${widget.pet.location}"),
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

  Widget _buildLocationMap() {
    if (widget.pet.latitude == null || widget.pet.longitude == null) {
      return const Text(
        'No hay ubicación disponible',
        style: TextStyle(color: Colors.red, fontSize: 16),
      );
    }

    final LatLng petLocation =
        LatLng(widget.pet.latitude!, widget.pet.longitude!);

    return SizedBox(
      height: 250,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.blue, // Color del borde
            width: 1, // Grosor del borde
          ),
          borderRadius: BorderRadius.circular(15), // Bordes redondeados
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15), // Redondea esquinas del mapa
          child: GoogleMap(
            myLocationEnabled: true,
            scrollGesturesEnabled: true, // Permite mover el mapa
            zoomGesturesEnabled: true, // Permite hacer zoom
            initialCameraPosition: CameraPosition(
              target: petLocation,
              zoom: 15,
            ),
            onMapCreated: (controller) {
              controller.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: petLocation,
                    zoom: 15,
                  ),
                ),
              );
            },
            markers: {
              Marker(
                markerId: const MarkerId('pet_location'),
                position: petLocation,
              ),
            },
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Fecha no disponible'; // Manejo de nulos
    return DateFormat('dd/MM/yyyy').format(date); // Convierte DateTime a String
  }

  void _onDotTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

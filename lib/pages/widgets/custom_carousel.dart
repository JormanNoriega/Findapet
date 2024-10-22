import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CustomCarousel extends StatelessWidget {
  final List<String> imageUrls; // Lista de URLs de imágenes
  final double height; // Altura del carrusel
  final double viewportFraction; // Fracción del viewport ocupada por cada elemento
  final bool autoPlay; // Reproducción automática

  CustomCarousel({
    required this.imageUrls,
    this.height = 200.0,
    this.viewportFraction = 0.8,
    this.autoPlay = true,
  });

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: height,
        autoPlay: autoPlay,
        viewportFraction: viewportFraction,
        enlargeCenterPage: true, // Para hacer que la imagen central sea más grande
      ),
      items: imageUrls.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(horizontal: 5.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

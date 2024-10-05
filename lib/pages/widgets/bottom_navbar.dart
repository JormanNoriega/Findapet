import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.only(bottom: 10.0), // Aquí ajustas la separación
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        backgroundColor: const Color(0xFFF0F440), // Color del fondo de la barra
        selectedItemColor: Colors.black, // Color del ítem seleccionado
        unselectedItemColor: const Color.fromARGB(
            255, 97, 96, 96), // Color de los ítems no seleccionados
        showUnselectedLabels:
            true, // Mostrar etiquetas de ítems no seleccionados
        type: BottomNavigationBarType
            .fixed, // Asegura que los íconos no cambien de tamaño
        onTap: onTap,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Buscar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notificaciones',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

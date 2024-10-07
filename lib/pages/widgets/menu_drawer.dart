import 'package:findapet/controllers/auth_controller.dart';
import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  final AuthController authController;
  final Function(int) onPageSelected; // Función para navegar entre páginas

  MenuDrawer({required this.authController, required this.onPageSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250, // Ancho del menú
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.arrow_back),
              title: Text('Cerrar'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(), // Línea separadora
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                onPageSelected(3); // Navegar a la página de perfil
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('Notificaciones'),
              onTap: () {
                Navigator.pop(context);
                onPageSelected(2); // Navegar a la página de notificaciones
              },
            ),
            ListTile(
              leading: Icon(Icons.map),
              title: Text('Direcciones'),
              onTap: () {
                Navigator.pop(context);
                onPageSelected(4); // Navegar a la página 4 (Direcciones)
                //logica para moverte a la page de direcciones
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Salir'),
              onTap: () {
                Navigator.pop(context);
                authController.signOut(); // Llamar al método de cerrar sesión
              },
            ),
          ],
        ),
      ),
    );
  }
}

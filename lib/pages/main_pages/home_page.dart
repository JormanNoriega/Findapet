import '../../pages/main_pages/profile_page.dart';
import '../../controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import '../widgets/menu_drawer.dart';
import 'package:get/get.dart';
import '../main_pages/page1.dart';
import '../main_pages/page2.dart';
import '../main_pages/page3.dart';
import '../main_pages/page4.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController _authController = Get.find();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  // Lista de las páginas
  final List<Widget> _pages = [
    Page1(),
    Page2(),
    Page3(),
    EditProfilePage(),
    Page4(),
  ];

  void changePage(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F440),
        leading: _selectedIndex != 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    if (_selectedIndex > 0) {
                      _selectedIndex--;
                    }
                  });
                },
              )
            : null,
        title: const Text(
          'Findapet',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              _scaffoldKey.currentState?.openEndDrawer();
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(bottom: 10.0), // Ajuste de separación
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: const Color(0xFFF0F440), // Fondo de la barra
          selectedItemColor: Colors.black, // Color del ítem seleccionado
          unselectedItemColor:
              const Color.fromARGB(255, 97, 96, 96), // No seleccionados
          showUnselectedLabels:
              true, // Mostrar etiquetas de ítems no seleccionados
          type: BottomNavigationBarType.fixed, // Íconos no cambian de tamaño
          onTap: changePage,
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
      ),
      endDrawer: MenuDrawer(
        authController: _authController,
        onPageSelected: changePage,
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors
import 'package:findapet/pages/main_pages/adoption_page.dart';
import 'package:findapet/pages/petlost_pages/my_petslost_page.dart';
import 'package:findapet/pages/petlost_pages/petlost_page.dart';
import '../../pages/main_pages/profile_page.dart';
import '../../controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import '../widgets/menu_drawer.dart';
import 'package:get/get.dart';
import 'package:findapet/pages/main_pages/departments_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController _authController = Get.find();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  // Pila para almacenar el historial de las páginas visitadas
  final List<int> _pageHistory = [];

  // Lista de las páginas
  final List<Widget> _pages = [
    PetlostPage(),
    MyPetsLostPage(),
    AdoptionPage(),
    EditProfilePage(),
    DepartmentsPage(),
  ];

  // Cambiar página y almacenar el índice anterior en el historial
  void changePage(int index) {
    setState(() {
      if (_selectedIndex != index) {
        _pageHistory.add(_selectedIndex); // Agrega el índice actual a la pila
      }
      _selectedIndex = index;
    });
  }

  // Regresar a la última página visitada (saca el último valor de la pila)
  void _goBack() {
    setState(() {
      if (_pageHistory.isNotEmpty) {
        _selectedIndex =
            _pageHistory.removeLast(); // Regresa a la última página en la pila
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F440),
        leading: null,
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
      body: IndexedStack(
        // Cambiado a IndexedStack para mantener el estado de las páginas
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex:
            _selectedIndex < 4 ? _selectedIndex : 0, // Previene errores
        backgroundColor: const Color(0xFFF0F440),
        selectedItemColor: Colors.black,
        unselectedItemColor: const Color.fromARGB(255, 97, 96, 96),
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        onTap: changePage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Mis Mascotas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Adoptar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
      endDrawer: MenuDrawer(
        authController: _authController,
        onPageSelected: changePage,
      ),
    );
  }
}

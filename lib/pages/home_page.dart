// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import './widgets/pet_card.dart';
import './widgets/bottom_navbar.dart';
import './widgets/menu_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthController _authController = Get.find();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedIndex = 0;

  // Lista de las cuatro páginas
  final List<Widget> _pages = [
    Page1(),
    Page2(),
    Page3(),
    Page4(),
    Page5(),
  ];

  void changePage(int index) {
    setState(() {
      _selectedIndex = index; // Cambia la página seleccionada
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
                      _selectedIndex--; // Regresar a la página anterior
                    }
                  });
                },
              )
            : null, // Si estamos en la primera página, no mostrar botón de regreso
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
      body: _pages[_selectedIndex], // Mostrar la página seleccionada
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: changePage,
      ),
      endDrawer: MenuDrawer(
        authController: _authController,
        onPageSelected: changePage,
      ),
    );
  }
}

// Ejemplo de las páginas
//Pagina 1, principal al abrir la app
class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              'Mascotas que buscan un hogar',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 8), // Espacio entre el título y las tarjetas
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 elementos por fila
                childAspectRatio: 0.8, // Ajusta el tamaño de la tarjeta
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: pets.length, // La cantidad de mascotas
              itemBuilder: (context, index) {
                return PetCard(
                  name: pets[index]['name']!,
                  reward: pets[index]['reward']!,
                  imageUrl: pets[index]['image']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Página 2'),
    );
  }
}

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Página 3'),
    );
  }
}

class Page4 extends StatelessWidget {
  const Page4({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Página 4'),
    );
  }
}

class Page5 extends StatelessWidget {
  const Page5({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Página 5'),
    );
  }
}

// datos d eprueba para visualizar cómo quedan las cards con info
List<Map<String, String>> pets = [
  {'name': 'Clara', 'reward': '25000', 'image': 'https://example.com/dog1.jpg'},
  {'name': 'Tonny', 'reward': '20000', 'image': 'https://example.com/dog2.jpg'},
  {'name': 'Max', 'reward': '10000', 'image': 'https://example.com/dog3.jpg'},
  {'name': 'Sammi', 'reward': '20000', 'image': 'https://example.com/cat1.jpg'},
  {'name': 'Nina', 'reward': '15000', 'image': 'https://example.com/cat2.jpg'},
  {'name': 'Coco', 'reward': '20000', 'image': 'https://example.com/dog4.jpg'},
];

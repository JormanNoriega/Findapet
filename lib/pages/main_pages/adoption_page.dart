import 'package:flutter/material.dart';
import '../widgets/pet_card.dart';

class AdoptionPage extends StatefulWidget {
  const AdoptionPage({super.key});

  @override
  _AdoptionPage createState() => _AdoptionPage();
}

class _AdoptionPage extends State<AdoptionPage> {
  bool _isSearching = false; // para controlar el modo de búsqueda
  TextEditingController _searchController =
      TextEditingController(); // controller para el input de búsqueda
  FocusNode _searchFocusNode = FocusNode(); // Nodo para manejar el foco
  List<Map<String, String>> _filteredPets = pets; // Lista filtrada de mascotas

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose(); // Liberar el FocusNode
    super.dispose();
  }

  // Método para filtrar las mascotas según el texto ingresado
  void _filterPets(String query) {
    setState(() {
      _filteredPets = pets.where((pet) {
        return pet['name']!.toLowerCase().contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _isSearching
                    ? TextField(
                        controller: _searchController,
                        focusNode: _searchFocusNode, // Asignar el FocusNode
                        decoration: InputDecoration(
                          hintText: 'Buscar mascota...',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _isSearching = false;
                                _filteredPets =
                                    pets; // Restaurar la lista completa
                              });
                            },
                          ),
                        ),
                        onChanged: (query) {
                          _filterPets(query);
                        },
                      )
                    : Text(
                        'Mascotas que buscan un hogar',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                ),
                      ),
              ),
              if (!_isSearching)
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _isSearching = true;
                      // Enfocar el campo de texto cuando se active la búsqueda
                      _searchFocusNode.requestFocus();
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 8),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _filteredPets.length,
              itemBuilder: (context, index) {
                return PetCard(
                  name: _filteredPets[index]['name']!,
                  reward: _filteredPets[index]['reward']!,
                  imageUrl: _filteredPets[index]['image']!,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Lista de mascotas
const List<Map<String, String>> pets = [
  {'name': 'Clara', 'reward': '25000', 'image': 'https://example.com/dog1.jpg'},
  {'name': 'Tonny', 'reward': '20000', 'image': 'https://example.com/dog2.jpg'},
  {'name': 'Max', 'reward': '10000', 'image': 'https://example.com/dog3.jpg'},
  {'name': 'Sammi', 'reward': '20000', 'image': 'https://example.com/cat1.jpg'},
  {'name': 'Nina', 'reward': '15000', 'image': 'https://example.com/cat2.jpg'},
  {'name': 'Coco', 'reward': '20000', 'image': 'https://example.com/dog4.jpg'},
];

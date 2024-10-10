import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Pet {
  String id;
  String name;
  String breed;
  String ownerId;
  String description;
  String imageUrl;
  String city;

  Pet({
    required this.id,
    required this.name,
    required this.breed,
    required this.ownerId,
    required this.description,
    required this.imageUrl,
    required this.city,
  });

  Map<String, dynamic> toMap();
}

//CLASE PARA MASCOTAS PERDIDAS
class PetLost extends Pet {
  DateTime? lostDate;
  String location;

  PetLost({
    required super.id,
    required super.name,
    required super.breed,
    required super.ownerId,
    required super.description,
    required super.imageUrl,
    required super.city,
    this.lostDate,
    required this.location,
  });

  factory PetLost.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PetLost(
      id: doc.id,
      name: data['name'] ?? '',
      breed: data['breed'] ?? '',
      ownerId: data['ownerId'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      city: data['city'] ?? '',
      lostDate: data['lostDate'] != null
          ? (data['lostDate'] as Timestamp).toDate()
          : null,
      location: data['location'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'ownerId': ownerId,
      'description': description,
      'imageUrl': imageUrl,
      'city': city,
      'lostDate': lostDate != null ? Timestamp.fromDate(lostDate!) : null,
      'location': location,
    };
  }
}

//CLASE PARA ADOPCION DE MASCOTAS
class PetAdoption extends Pet {
  bool isVaccinated;
  bool isSterilized;

  PetAdoption({
    required super.id,
    required super.name,
    required super.breed,
    required super.ownerId,
    required super.description,
    required super.imageUrl,
    required super.city,
    required this.isVaccinated,
    required this.isSterilized,
  });

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'breed': breed,
      'ownerId': ownerId,
      'description': description,
      'imageUrl': imageUrl,
      'city': city,
      'isVaccinated': isVaccinated,
      'isSterilized': isSterilized,
    };
  }

  factory PetAdoption.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PetAdoption(
      id: data['id'],
      name: data['name'],
      breed: data['breed'],
      ownerId: data['ownerId'],
      description: data['description'],
      imageUrl: data['imageUrl'],
      city: data['city'],
      isVaccinated: data['isVaccinated'],
      isSterilized: data['isSterilized'],
    );
  }
}

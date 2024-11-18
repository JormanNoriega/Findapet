import 'package:cloud_firestore/cloud_firestore.dart';

abstract class Pet {
  String id;
  String name;
  String type;
  String breed;
  String ownerId;
  String description;
  List<String> imageUrls;
  String? department;
  String? municipality;

  Pet({
    required this.id,
    required this.name,
    required this.type,
    required this.breed,
    required this.ownerId,
    required this.description,
    required this.imageUrls,
    this.department,
    this.municipality,
  });

  Map<String, dynamic> toMap();
}

//CLASE PARA MASCOTAS PERDIDAS/////////////////////////////////////////////////////////////////////////
class PetLost extends Pet {
  DateTime? lostDate;
  String location;
  String? latitude;
  String? longitude;

  PetLost({
    required super.id,
    required super.name,
    required super.type,
    required super.breed,
    required super.ownerId,
    required super.description,
    required super.imageUrls,
    required super.department,
    required super.municipality,
    this.lostDate,
    required this.location,
    this.latitude,
    this.longitude,
  });

  factory PetLost.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PetLost(
      id: doc.id,
      name: data['name'] ?? '',
      type: data['type'] ?? '',
      breed: data['breed'] ?? '',
      ownerId: data['ownerId'] ?? '',
      description: data['description'] ?? '',
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      municipality: data['city'] ?? '',
      department: data['department'] ?? '',
      lostDate: data['lostDate'] != null
          ? (data['lostDate'] as Timestamp).toDate()
          : null,
      location: data['location'] ?? '',
      latitude: data['latitude'] ?? '',
      longitude: data['longitude'] ?? '',
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'ownerId': ownerId,
      'description': description,
      'imageUrls': imageUrls,
      'department': department,
      'municipality': municipality,
      'lostDate': lostDate != null ? Timestamp.fromDate(lostDate!) : null,
      'location': location,
    };
  }
}

//CLASE PARA ADOPCION DE MASCOTAS /////////////////////////////////////////////////////////////////////////
class PetAdoption extends Pet {
  bool isVaccinated;
  bool isSterilized;

  PetAdoption({
    required super.id,
    required super.name,
    required super.type,
    required super.breed,
    required super.ownerId,
    required super.description,
    required super.imageUrls,
    required super.department,
    required super.municipality,
    required this.isVaccinated,
    required this.isSterilized,
  });

  factory PetAdoption.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return PetAdoption(
      id: data['id'],
      name: data['name'],
      type: data['type'],
      breed: data['breed'],
      ownerId: data['ownerId'],
      description: data['description'],
      imageUrls: List<String>.from(data['imageUrls'] ?? []),
      department: data['department'],
      municipality: data['city'],
      isVaccinated: data['isVaccinated'],
      isSterilized: data['isSterilized'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'breed': breed,
      'ownerId': ownerId,
      'description': description,
      'imageUrls': imageUrls,
      'department': department,
      'municipality': municipality,
      'isVaccinated': isVaccinated,
      'isSterilized': isSterilized,
    };
  }
}

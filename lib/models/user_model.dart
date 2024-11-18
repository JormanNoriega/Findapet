class UserModel {
  final String uid;
  final String name;
  final String lastName;
  final String phone;
  final String country;
  final String department;
  final String municipality;  
  final String email;
  String? profileImageUrl; // Imagen de perfil opcional

  UserModel({
    required this.uid,
    required this.name,
    required this.lastName,
    required this.phone,
    required this.country,
    required this.department,
    required this.municipality,
    required this.email,
    this.profileImageUrl,
  });

  // Convertir el UserModel a un Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'lastName': lastName,
      'phone': phone,
      'county': country,
      'department': department,
      'municipality': municipality,
      'email': email,
      'profileImageUrl': profileImageUrl,
    };
  }

  // Crear una instancia de UserModel a partir de Firestore
  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      lastName: data['lastName'] ?? '',
      phone: data['phone'] ?? '',
      country: data['country'] ?? '',
      department: data['department'] ?? '',
      municipality: data['municipality'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'],
    );
  }
}

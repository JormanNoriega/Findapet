import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:findapet/models/pet_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class PetlostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Obtener datos de las mascota perdida
  Stream<List<PetLost>> getPetlostData() {
    return _firestore.collection('petlost').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => PetLost.fromMap(doc)).toList();
    });
  }

  // obtener datos de la mascota perdida por ID
  Future<PetLost?> getPetLostById(String id) async {
    try {
      DocumentSnapshot petDoc =
          await _firestore.collection('petlost').doc(id).get();
      if (petDoc.exists) {
        return PetLost.fromMap(petDoc);
      }
    } catch (e) {
      print("Error al obtener datos de la mascota perdida: $e");
    }
    return null;
  }

  // Guardar datos de la mascota perdida
  Future<void> savePetlostData(PetLost petlost) async {
    try {
      await _firestore
          .collection('petlost')
          .doc(petlost.id)
          .set(petlost.toMap());
    } catch (e) {
      print("Error al guardar datos de la mascota perdida: $e");
    }
  }

  // Actualizar datos de la mascota perdida
  Future<void> updatePetlostData(PetLost petlost) async {
    try {
      await _firestore
          .collection('petlost')
          .doc(petlost.id)
          .update(petlost.toMap());
    } catch (e) {
      print("Error al actualizar datos de la mascota perdida: $e");
    }
  }

  // Eliminar datos de la mascota perdida
  Future<void> deletePetlostData(String id) async {
    try {
      await _firestore.collection('petlost').doc(id).delete();
    } catch (e) {
      print("Error al eliminar datos de la mascota perdida: $e");
    }
  }

  // Subir imagen de la mascota perdida desde Movil
  Future<String?> uploadPetLostImage(File imageFile, String petId) async {
    try {
      Reference storageReference = _storage.ref('petlost/$petId');
      UploadTask uploadTask = storageReference.putFile(imageFile);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error al subir la imagen de la mascota perdida: $e");
    }
    return null;
  }

  // subir imagen de la mascota perdida desde la web
  Future<String?> uploadPetLostImageWeb(
      Uint8List imageBytes, String petId) async {
    try {
      Reference storageReference = _storage.ref('petlost/$petId');
      UploadTask uploadTask = storageReference.putData(imageBytes);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error al subir la imagen de la mascota perdida: $e");
    }
    return null;
  }

  // Metodo para seleccionar imagen dependiendo de la plataforma
  Future<String?> pickPetLostImage(bool fromCamera) async {
    if (kIsWeb) {
      //si es web usamos filepicker
      FilePickerResult? result =
          await FilePicker.platform.pickFiles(type: FileType.image);
      if (result != null && result.files.first.bytes != null) {
        return result.files.first.name;
      } else {
        return null;
      }
    } else {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
          source: fromCamera ? ImageSource.camera : ImageSource.gallery);
      if (pickedFile != null) {
        return pickedFile.path;
      } else {
        return null;
      }
    }
  }

  // Metod para subir imagen segun la plataforma
  Future<String?> uploadImageForPlatform(
      dynamic imageFile, String petId) async {
    if (kIsWeb && imageFile is Uint8List) {
      return await uploadPetLostImageWeb(imageFile, petId);
    } else if (imageFile is File) {
      return await uploadPetLostImage(imageFile, petId);
    } else {
      print("Error: tipo de archivo no soportado");
      return null;
    }
  }
}

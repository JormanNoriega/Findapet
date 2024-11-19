import 'dart:io';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:findapet/models/pet_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class PetAdoptionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Obtener datos de las mascotas en adopción
  Stream<List<PetAdoption>> getPetAdoptionData() {
    return _firestore.collection('petadoption').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => PetAdoption.fromMap(doc)).toList();
    });
  }

  // Obtener datos de una mascota en adopción por ID
  Future<PetAdoption?> getPetAdoptionById(String id) async {
    try {
      DocumentSnapshot petDoc =
          await _firestore.collection('petadoption').doc(id).get();
      if (petDoc.exists) {
        return PetAdoption.fromMap(petDoc);
      }
    } catch (e) {
      print("Error al obtener datos de la mascota en adopción: $e");
    }
    return null;
  }

  // Obtener mascotas en adopción por propietario
  Future<List<PetAdoption>> getPetAdoptionDataByOwner(String ownerId) async {
    try {
      QuerySnapshot petDocs = await _firestore
          .collection('petadoption')
          .where('ownerId', isEqualTo: ownerId)
          .get();
      return petDocs.docs.map((doc) => PetAdoption.fromMap(doc)).toList();
    } catch (e) {
      print("Error al obtener datos de las mascotas en adopción: $e");
    }
    return [];
  }

  // Guardar datos de una mascota en adopción
  Future<void> savePetAdoptionData(PetAdoption petAdoption) async {
    try {
      await _firestore
          .collection('petadoption')
          .doc(petAdoption.id)
          .set(petAdoption.toMap());
    } catch (e) {
      print("Error al guardar datos de la mascota en adopción: $e");
    }
  }

  // Actualizar datos de una mascota en adopción
  Future<void> updatePetAdoptionData(PetAdoption petAdoption) async {
    try {
      await _firestore
          .collection('petadoption')
          .doc(petAdoption.id)
          .update(petAdoption.toMap());
    } catch (e) {
      print("Error al actualizar datos de la mascota en adopción: $e");
    }
  }

  // Eliminar datos de una mascota en adopción
  Future<void> deletePetAdoptionData(String id) async {
    try {
      await _firestore.collection('petadoption').doc(id).delete();
    } catch (e) {
      print("Error al eliminar datos de la mascota en adopción: $e");
    }
  }

  // Método para seleccionar múltiples imágenes dependiendo de la plataforma
  Future<List<String?>> pickPetAdoptionImages(bool fromCamera) async {
    if (kIsWeb) {
      // Si es web usamos FilePicker
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: true);
      if (result != null && result.files.first.bytes != null) {
        return result.files.map((file) => file.name).toList();
      } else {
        return [];
      }
    } else {
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage();
      if (pickedFiles != []) {
        return pickedFiles.map((file) => file.path).toList();
      } else {
        return [];
      }
    }
  }

  // Subir imágenes de la mascota en adopción desde móvil
  Future<List<String?>> uploadPetAdoptionImages(
      List<File> imageFile, String petId) async {
    List<String?> imageUrls = [];
    for (File file in imageFile) {
      try {
        Reference storageReference =
            _storage.ref('petadoption/$petId/${file.path.split('/').last}');
        UploadTask uploadTask = storageReference.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        imageUrls.add(await snapshot.ref.getDownloadURL());
      } catch (e) {
        print("Error al subir la imagen de la mascota en adopción: $e");
        imageUrls.add(null);
      }
    }
    return imageUrls;
  }

  // Subir imágenes de la mascota en adopción desde la web
  Future<List<String?>> uploadPetAdoptionImagesWeb(
      List<Uint8List> imageBytesList, String petId) async {
    List<String?> imageUrls = [];
    for (Uint8List imageBytes in imageBytesList) {
      try {
        Reference storageReference = _storage.ref('petadoption/$petId');
        UploadTask uploadTask = storageReference.putData(imageBytes);
        TaskSnapshot snapshot = await uploadTask;
        imageUrls.add(await snapshot.ref.getDownloadURL());
      } catch (e) {
        print("Error al subir la imagen de la mascota en adopción: $e");
        imageUrls.add(null);
      }
    }
    return imageUrls;
  }

  // Método para subir imágenes según la plataforma
  Future<List<String?>> uploadImagesForPlatform(
      dynamic imageFiles, String petId) async {
    if (kIsWeb && imageFiles is List<Uint8List>) {
      return await uploadPetAdoptionImagesWeb(imageFiles, petId);
    } else if (imageFiles is List<File>) {
      return await uploadPetAdoptionImages(imageFiles, petId);
    } else {
      print("Error: tipo de archivo no soportado");
      return [];
    }
  }
}

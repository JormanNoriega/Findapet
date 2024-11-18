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

  Future<List<PetLost>> getPetlostDataByOwner(String ownerId) async {
    try {
      QuerySnapshot petDocs = await _firestore
          .collection('petlost')
          .where('ownerId', isEqualTo: ownerId)
          .get();
      return petDocs.docs.map((doc) => PetLost.fromMap(doc)).toList();
    } catch (e) {
      print("Error al obtener datos de la mascota perdida: $e");
    }
    return [];
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

  // Metodo para seleccionar Multiples imagenes dependiendo de la plataforma
  Future<List<String?>> pickPetLostImages(bool fromCamera) async {
    if (kIsWeb) {
      //si es web usamos filepicker
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

  // Subir imagenes de la mascota perdida desde Movil
  Future<List<String?>> uploadPetLostImages(
      List<File> imageFile, String petId) async {
    List<String?> imageUrls = [];
    for (File file in imageFile) {
      try {
        Reference storageReference = _storage.ref('petlost/$petId/${file.path.split('/').last}');
        UploadTask uploadTask = storageReference.putFile(file);
        TaskSnapshot snapshot = await uploadTask;
        imageUrls.add(await snapshot.ref.getDownloadURL());
      } catch (e) {
        print("Error al subir la imagen de la mascota perdida: $e");
        imageUrls.add(null);
      }
    }
    return imageUrls;
  }

  // subir imagenes de la mascota perdida desde la web
  Future<List<String?>> uploadPetLostImagesWeb(
      List<Uint8List> imageBytesList, String petId) async {
    List<String?> imageUrls = [];
    for (Uint8List imageBytes in imageBytesList) {
      try {
        Reference storageReference = _storage.ref('petlost/$petId');
        UploadTask uploadTask = storageReference.putData(imageBytes);
        TaskSnapshot snapshot = await uploadTask;
        imageUrls.add(await snapshot.ref.getDownloadURL());
      } catch (e) {
        print("Error al subir la imagen de la mascota perdida: $e");
        imageUrls.add(null);
      }
    }
    return imageUrls;
  }

  // Metod para subir imagenes segun la plataforma
  Future<List<String?>> uploadImagesForPlatform(
      dynamic imageFiles, String petId) async {
    if (kIsWeb && imageFiles is List<Uint8List>) {
      return await uploadPetLostImagesWeb(imageFiles, petId);
    } else if (imageFiles is List<File>) {
      return await uploadPetLostImages(imageFiles, petId);
    } else {
      print("Error: tipo de archivo no soportado");
      return [];
    }
  }
}

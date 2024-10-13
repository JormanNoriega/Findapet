import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:findapet/controllers/auth_controller.dart';
import 'package:findapet/models/pet_model.dart';
import 'package:findapet/services/petlost_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class petlostController extends GetxController {
  final PetlostService _petlostService = PetlostService();

  var isLoading = false.obs;
  var imageFile = Rxn<File>();
  var imageWebFile = Rxn<Uint8List>();
  RxList<PetLost> petlostList = <PetLost>[].obs;
  RxList<PetLost> petlostListByOwner = <PetLost>[].obs;
  var filteredPetlostList = <PetLost>[].obs;
  var searchQuery = ''.obs;

  //Metodo para seleccionar imagen
  Future<void> pickImage(bool fromCamera) async {
    if (kIsWeb) {
      // Seleccionar imagen en Flutter Web usando FilePicker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );
      if (result != null && result.files.first.bytes != null) {
        imageWebFile.value =
            result.files.first.bytes; // Guardar imagen para la web
      } else {
        Get.snackbar("Error", "No se seleccionó ninguna imagen");
      }
    } else {
      // Seleccionar imagen en dispositivos móviles usando ImagePicker
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: fromCamera ? ImageSource.camera : ImageSource.gallery,
      );
      if (pickedFile != null) {
        imageFile.value = File(pickedFile.path); // Guardar la imagen en móviles
      } else {
        Get.snackbar("Error", "No se seleccionó ninguna imagen");
      }
    }
  }

  //Metodo para guardar un petLost
  Future<void> saveNewPetlost(String name, String breed, String ownerId,
      String description, String city, String lostDate, String location) async {
    try {
      isLoading.value = true;
      String id = const Uuid().v4(); // Generar un ID único para la mascota

      if (imageFile.value != null || imageWebFile.value != null) {
        String? imageUrl = await _petlostService.uploadImageForPlatform(
          kIsWeb ? imageWebFile.value! : imageFile.value!,
          id,
        );

        if (imageUrl != null) {
          // Crear una instancia de Petlost con todos los datos
          PetLost petLost = PetLost(
            id: id,
            name: name,
            breed: breed,
            ownerId: ownerId,
            description: description,
            imageUrl: imageUrl,
            city: city,
            lostDate: DateTime.parse(lostDate),
            location: location,
          );
          // Guardar el ítem usando el servicio
          await _petlostService.savePetlostData(petLost);
          Get.snackbar('Éxito', 'Publicacion Exitosa');
          fetchPetLostByOwner();
          fetchPetLost(); // Volver a cargar los ítems después de guardar
        } else {
          Get.snackbar('Error', 'No se pudo subir la imagen');
        }
      } else {
        Get.snackbar('Error', 'Debe seleccionar una imagen');
      }
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al Hacer una publicacion');
    } finally {
      isLoading.value = false;
    }
  }

  //Metodo para obtener todos los petLost
  void fetchPetLost() {
    isLoading.value = true;
    _petlostService.getPetlostData().listen((fetchedPetLost) {
      // Aquí actualizas la lista y aplicas el filtro
      petlostList.value = fetchedPetLost;
      applyFilter(); // Asegúrate de que esto no desencadene un rebuild
      isLoading.value = false; // Mueve esto después de aplicar el filtro
    });
  }

  //metodo para obtener los petLost por el id del dueño
  void fetchPetLostByOwner() {
    isLoading.value = true;
    String ownerId = Get.find<AuthController>().userModel.value!.uid;
    _petlostService
        .getPetlostDataByOwner(ownerId)
        .then((fetchedPetLostbyOwner) {
      petlostListByOwner.value = fetchedPetLostbyOwner;
      isLoading.value = false;
    });
  }

  // Método para aplicar el filtro basado en el texto de búsqueda
  void applyFilter() {
    if (searchQuery.value.isEmpty) {
      // Si no hay búsqueda, mostrar todos los ítems
      filteredPetlostList.value = petlostList;
    } else {
      // Filtrar los ítems según el texto de búsqueda
      filteredPetlostList.value = petlostList.where((petLost) {
        return petLost.name
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase());
      }).toList();
    }
  }

  // Método para actualizar el texto de búsqueda
  void updateSearchQuery(String query) {
    searchQuery.value = query;
    applyFilter(); // Aplicar el filtro cada vez que se actualice el texto de búsqueda
  }

  // Método para obtener un ítem por su ID
  Future<PetLost?> getItemPetLostById(String id) async {
    try {
      return await _petlostService.getPetLostById(id);
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al obtener el ítem');
      return null;
    }
  }

  //Metodo para actualizar un petLost
  Future<void> updatePetLost(PetLost petlost) async {
    try {
      isLoading.value = true;
      // Si hay una nueva imagen seleccionada, actualizar la imagen
      String? imageUrl;
      if (imageFile.value != null || imageWebFile.value != null) {
        imageUrl = await _petlostService.uploadImageForPlatform(
          kIsWeb ? imageWebFile.value! : imageFile.value!,
          petlost.id,
        );
        if (imageUrl != null) {
          petlost.imageUrl =
              imageUrl; // Actualizar la URL de la imagen en el ítem
        }
      }
      // Actualizar los datos del petlost en Firestore
      await _petlostService.updatePetlostData(petlost);
      Get.snackbar('Éxito', 'Ítem actualizado correctamente');
      fetchPetLost(); // Volver a cargar los petlost después de actualizar
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al actualizar el ítem');
    } finally {
      isLoading.value = false;
    }
  }

  //Metodo para eliminar un petLost
  Future<void> deletePetLost(PetLost petlost) async {
    try {
      isLoading.value = true;
      await _petlostService.deletePetlostData(petlost.id);
      Get.snackbar('Éxito', 'Ítem eliminado correctamente');
      fetchPetLost();
      fetchPetLostByOwner();
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al eliminar el ítem');
    } finally {
      isLoading.value = false;
    }
  }
}

import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:findapet/controllers/auth_controller.dart';
import 'package:findapet/models/pet_model.dart';
import 'package:findapet/services/petadoption_service.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class PetAdoptionController extends GetxController {
  final PetAdoptionService _petAdoptionService = PetAdoptionService();

  var isLoading = false.obs;
  var imageFiles = <File>[].obs;
  var imageWebFiles = <Uint8List>[].obs;
  RxList<PetAdoption> petAdoptionList = <PetAdoption>[].obs;
  RxList<PetAdoption> petAdoptionListByOwner = <PetAdoption>[].obs;
  var filteredPetAdoptionList = <PetAdoption>[].obs;
  var searchQuery = ''.obs;

  // Método para seleccionar imágenes
  Future<void> pickPetAdoptionImages(bool fromCamera) async {
    if (kIsWeb) {
      // Seleccionar imagen en Flutter Web usando FilePicker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );
      if (result != null && result.files.first.bytes != null) {
        imageWebFiles.value = result.files
            .map((file) => file.bytes!)
            .toList(); // Guardar imagen para la web
      } else {
        Get.snackbar("Error", "No se seleccionó ninguna imagen");
      }
    } else {
      // Seleccionar imagen en dispositivos móviles usando ImagePicker
      final picker = ImagePicker();
      final pickedFiles = await picker.pickMultiImage();
      if (pickedFiles.isNotEmpty) {
        imageFiles.value = pickedFiles
            .map((file) => File(file.path))
            .toList(); // Guardar la imagen en móviles
      } else {
        Get.snackbar("Error", "No se seleccionó ninguna imagen");
      }
    }
  }

  // Método para guardar un petAdoption
  Future<void> saveNewPetAdoption(
      String name,
      String type,
      String breed,
      String ownerId,
      String description,
      String department,
      String municipality,
      bool isVaccinated,
      bool isSterilized) async {
    try {
      isLoading.value = true;
      String id = const Uuid().v4(); // Generar un ID único para la mascota
      List<String> imageUrls = [];

      // Verificar si hay imágenes seleccionadas
      if (imageFiles.isNotEmpty || imageWebFiles.isNotEmpty) {
        List<String?> uploadedUrls =
            await _petAdoptionService.uploadImagesForPlatform(
          kIsWeb ? imageWebFiles : imageFiles,
          id,
        );

        // Filtrar URLs no nulas
        imageUrls =
            uploadedUrls.where((url) => url != null).cast<String>().toList();
      }

      // Crear una instancia de PetAdoption con todos los datos
      PetAdoption petAdoption = PetAdoption(
        id: id,
        name: name,
        type: type,
        breed: breed,
        ownerId: ownerId,
        description: description,
        imageUrls: imageUrls,
        department: department,
        municipality: municipality,
        isVaccinated: isVaccinated,
        isSterilized: isSterilized,
      );

      // Guardar el ítem usando el servicio
      await _petAdoptionService.savePetAdoptionData(petAdoption);
      Get.snackbar('Éxito', 'Publicación Exitosa');
      fetchPetAdoptionByOwner();
      fetchPetAdoption(); // Volver a cargar los ítems después de guardar
    } catch (e) {
      Get.snackbar('Error', 'No se pudo guardar la publicación');
    } finally {
      isLoading.value = false;
    }
  }

  // Método para obtener todos los petAdoption
  void fetchPetAdoption() {
    isLoading.value = true;
    _petAdoptionService.getPetAdoptionData().listen((fetchedPetAdoption) {
      petAdoptionList.value = fetchedPetAdoption;
      applyFilter(); // Asegúrate de que esto no desencadene un rebuild
      isLoading.value = false; // Mueve esto después de aplicar el filtro
    });
  }

  // Método para obtener los petAdoption por el id del dueño
  void fetchPetAdoptionByOwner() {
    isLoading.value = true;
    String ownerId = Get.find<AuthController>().userModel.value!.uid;
    _petAdoptionService
        .getPetAdoptionDataByOwner(ownerId)
        .then((fetchedPetAdoptionByOwner) {
      petAdoptionListByOwner.value = fetchedPetAdoptionByOwner;
      isLoading.value = false;
    });
  }

  // Método para aplicar el filtro basado en el texto de búsqueda
  void applyFilter() {
    if (searchQuery.value.isEmpty) {
      filteredPetAdoptionList.value = petAdoptionList;
    } else {
      filteredPetAdoptionList.value = petAdoptionList.where((petAdoption) {
        return petAdoption.name
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

  // Método para obtener un petAdoption por su ID
  Future<PetAdoption?> getItemPetAdoptionById(String id) async {
    try {
      return await _petAdoptionService.getPetAdoptionById(id);
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al buscar la mascota');
      return null;
    }
  }

  // Método para actualizar un petAdoption
  Future<void> updatePetAdoption(PetAdoption petAdoption) async {
    try {
      isLoading.value = true;
      List<String> imageUrls = List.from(petAdoption.imageUrls);
      // Verificar si hay nuevas imágenes seleccionadas
      if (imageFiles.isNotEmpty || imageWebFiles.isNotEmpty) {
        List<String?> uploadedUrls =
            await _petAdoptionService.uploadImagesForPlatform(
          kIsWeb ? imageWebFiles : imageFiles,
          petAdoption.id,
        );
        // Filtrar URLs no nulas y añadirlas a las URLs existentes
        imageUrls.addAll(
            uploadedUrls.where((url) => url != null).cast<String>().toList());
      }
      // Actualizar los datos del petAdoption en Firestore
      await _petAdoptionService.updatePetAdoptionData(petAdoption);
      Get.snackbar('Éxito', 'Mascota actualizada correctamente');
      fetchPetAdoption(); // Volver a cargar los petAdoption después de actualizar
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al actualizar la Mascota');
    } finally {
      isLoading.value = false;
    }
  }

  // Método para eliminar un petAdoption
  Future<void> deletePetAdoption(PetAdoption petAdoption) async {
    try {
      isLoading.value = true;
      await _petAdoptionService.deletePetAdoptionData(petAdoption.id);
      Get.snackbar('Éxito', 'Mascota eliminada correctamente');
      fetchPetAdoption();
      fetchPetAdoptionByOwner();
    } catch (e) {
      Get.snackbar('Error', 'Ocurrió un error al eliminar la Mascota');
    } finally {
      isLoading.value = false;
    }
  }
}

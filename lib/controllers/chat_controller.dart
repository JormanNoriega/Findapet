import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:findapet/models/message.dart';
import 'package:findapet/services/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observables
  var messages = <Message>[].obs;
  var isLoading = false.obs;

  // ID de usuario actual y receptor
  late String currentUserID;
  late String receiverID;
  late String currentUserEmail;

  // Inicializar el chat
  void initChat({
    required String otherUserID,
  }) {
    currentUserID = _auth.currentUser!.uid;
    currentUserEmail = _auth.currentUser!.email!;
    receiverID = otherUserID;
    _listenToMessages();
  }

  // Escuchar mensajes en tiempo real
  void _listenToMessages() {
    isLoading.value = true;
    _chatService.getMessages(currentUserID, receiverID).listen((snapshot) {
      messages.clear();
      for (var doc in snapshot.docs) {
        messages.add(Message.fromMap(doc));
      }
      isLoading.value = false;
    }, onError: (error) {
      isLoading.value = false;
      Get.snackbar('Error', 'No se pudo obtener los mensajes: $error');
    });
  }

  // Enviar mensaje
  Future<void> sendMessage(String messageText) async {
    if (messageText.trim().isEmpty) {
      Get.snackbar('Advertencia', 'El mensaje no puede estar vacío');
      return;
    }

    // Crear un objeto Message
    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: currentUserEmail,
      receiverID: receiverID,
      message: messageText,
      timestamp: Timestamp.now(),
    );

    try {
      await _chatService.sendMessage(newMessage);
    } catch (e) {
      Get.snackbar('Error', 'No se pudo enviar el mensaje: $e');
    }
  }

  // Limpiar datos al cerrar
  @override
  void onClose() {
    messages.clear();
    super.onClose();
  }
}

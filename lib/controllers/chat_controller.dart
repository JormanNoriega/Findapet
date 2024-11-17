import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findapet/models/chat_model.dart';
import 'package:findapet/models/message.dart';
import 'package:findapet/models/user_model.dart';
import 'package:findapet/services/chat_service.dart';

class ChatController extends GetxController {
  final ChatService _chatService = ChatService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Observables
  var messages = <Message>[].obs;
  var userChats = <Chat>[].obs; // Lista de chats
  var receiversInfo =
      <String, UserModel>{}.obs; // Mapa de ID del receptor a su información
  var isLoadingMessages = false.obs;
  var isLoadingChats = false.obs;

  // IDs del usuario actual y del receptor
  late String currentUserID;

  @override
  void onInit() {
    super.onInit();
    currentUserID = _auth.currentUser!.uid;
    loadUserChats();
  }

  // Obtener todos los chats en los que participa el usuario
  void loadUserChats() {
    isLoadingChats.value = true;

    _chatService.getUserChats(currentUserID).listen((chats) async {
      userChats.value = chats;

      // Cargar información de los receptores
      for (Chat chat in chats) {
        String otherUserID = chat.participants.firstWhere(
            (id) => id != currentUserID); // Obtener el ID del receptor
        if (!receiversInfo.containsKey(otherUserID)) {
          UserModel receiverInfo = await _chatService.getUserInfo(otherUserID);
          receiversInfo[otherUserID] = receiverInfo;
        }
      }
      isLoadingChats.value = false;
    }, onError: (error) {
      isLoadingChats.value = false;
      Get.snackbar('Error', 'No se pudieron cargar los chats: $error');
    });
  }

  // Inicializar un chat específico
  void initChat(String receiverID) {
    _listenToMessages(receiverID);
  }

  // Escuchar mensajes en tiempo real
  void _listenToMessages(String receiverID) {
    isLoadingMessages.value = true;

    _chatService.getMessages(currentUserID, receiverID).listen((messagesList) {
      messages.value = messagesList;
      isLoadingMessages.value = false;
    }, onError: (error) {
      isLoadingMessages.value = false;
      Get.snackbar('Error', 'No se pudieron cargar los mensajes: $error');
    });
  }

  // Enviar mensaje
  Future<void> sendMessage(String receiverID, String messageText) async {
    if (messageText.trim().isEmpty) {
      Get.snackbar('Advertencia', 'El mensaje no puede estar vacío');
      return;
    }

    Message newMessage = Message(
      senderID: currentUserID,
      senderEmail: _auth.currentUser!.email!,
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
}

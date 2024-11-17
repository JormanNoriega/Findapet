import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findapet/models/chat_model.dart';
import 'package:findapet/models/message.dart';
import 'package:findapet/models/user_model.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Enviar mensaje
  Future<void> sendMessage(Message message) async {
    try {
      // Generar el ID de la sala de chat
      List<String> ids = [message.senderID, message.receiverID];
      ids.sort();
      String chatRoomID = ids.join('_');

      // Crear o actualizar la sala de chat con el último mensaje
      await _firestore.collection('chat_rooms').doc(chatRoomID).set({
        'participants': ids,
        'lastMessage': message.message,
        'lastMessageTimestamp': message.timestamp,
      }, SetOptions(merge: true));

      // Agregar el mensaje a la subcolección
      await _firestore
          .collection('chat_rooms')
          .doc(chatRoomID)
          .collection('messages')
          .add(message.toMap());
    } catch (e) {
      print("Error al enviar mensaje: $e");
    }
  }

  // Obtener mensajes
  Stream<List<Message>> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => Message.fromMap(doc)).toList());
  }

  // Obtener todos los chats en los que participa un usuario
  Stream<List<Chat>> getUserChats(String userID) {
    return _firestore
        .collection('chat_rooms')
        .where('participants', arrayContains: userID)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => Chat.fromMap(doc)).toList();
    });
  }
  
  //Obtener información del usuario
  Future<UserModel> getUserInfo(String userID) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(userID).get();

      if (userDoc.exists) {
        // Proporciona ambos argumentos al constructor
        return UserModel.fromFirestore(
          userDoc.data() as Map<String, dynamic>, // Datos del usuario
          userDoc.id, // ID del documento
        );
      } else {
        throw Exception("El usuario con ID $userID no existe.");
      }
    } catch (e) {
      throw Exception("Error al obtener información del usuario: $e");
    }
  }
}

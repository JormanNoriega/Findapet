import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findapet/models/message.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Enviar mensaje
  Future<void> sendMessage(Message message) async {
    try {
      // Generar el ID de la sala de chat
      List<String> ids = [message.senderID, message.receiverID];
      ids.sort();
      String chatRoomID = ids.join('_');

      // Agregar mensaje a la base de datos
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
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomID)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}

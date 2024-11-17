import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderID;
  final String senderEmail;
  final String receiverID;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.senderID,
    required this.senderEmail,
    required this.receiverID,
    required this.message,
    required this.timestamp,
  });

  //convertir a MAP
  Map<String, dynamic> toMap() {
    return {
      'senderID': senderID,
      'senderEmail': senderEmail,
      'receiverID': receiverID,
      'message': message,
      'timestamp': timestamp,
    };
  }

  factory Message.fromMap(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Message(
      senderID: data['senderID'] ?? '',
      senderEmail: data['senderEmail'] ?? '',
      receiverID: data['receiverID'] ?? '',
      message: data['message'] ?? '',
      timestamp: data['timestamp'] ?? '',
    );
  }
}

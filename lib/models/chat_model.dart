import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String chatID;
  final List<String> participants;
  final String? lastMessage;
  final Timestamp? lastMessageTimestamp;

  Chat({
    required this.chatID,
    required this.participants,
    this.lastMessage,
    this.lastMessageTimestamp,
  });

  factory Chat.fromMap(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Chat(
      chatID: doc.id,
      participants: List<String>.from(data['participants']),
      lastMessage: data['lastMessage'],
      lastMessageTimestamp: data['lastMessageTimestamp'], // Mantener como Timestamp
    );
  }
}

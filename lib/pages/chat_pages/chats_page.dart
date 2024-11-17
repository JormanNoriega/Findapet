import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:findapet/pages/chat_pages/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:findapet/controllers/chat_controller.dart';

class ChatPages extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Chats', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        if (chatController.isLoadingChats.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation<Color>(const Color(0xFFF0F440)), // Color de carga
            ),
          );
        }

        if (chatController.userChats.isEmpty) {
          return Center(
              child: Text('No tienes chats aún',
                  style: TextStyle(fontSize: 18, color: Colors.grey)));
        }

        return ListView.builder(
          itemCount: chatController.userChats.length,
          itemBuilder: (context, index) {
            final chat = chatController.userChats[index];
            final otherUserID = chat.participants
                .firstWhere((id) => id != chatController.currentUserID);

            final receiverInfo = chatController.receiversInfo[otherUserID];

            return Card(
              margin: EdgeInsets.symmetric(
                  vertical: 8, horizontal: 16), // Márgenes de las tarjetas
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Bordes redondeados
              ),
              elevation: 5, // Sombra de la tarjeta
              child: ListTile(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                leading: CircleAvatar(
                  radius: 28, // Hacer las imágenes de perfil más grandes
                  backgroundImage: receiverInfo?.profileImageUrl != null
                      ? NetworkImage(receiverInfo!.profileImageUrl!)
                      : null,
                  backgroundColor:
                      Colors.grey[200], // Color de fondo si no hay imagen
                  child: receiverInfo?.profileImageUrl == null
                      ? Icon(Icons.person, size: 30, color: Colors.teal)
                      : null,
                ),
                title: Text(receiverInfo?.name ?? 'Cargando...',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                subtitle: Text(chat.lastMessage ?? 'Sin mensajes',
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                trailing: chat.lastMessageTimestamp != null
                    ? Text(
                        _formatTimestamp(chat.lastMessageTimestamp!),
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      )
                    : null,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(receiverID: otherUserID),
                    ),
                  );
                },
              ),
            );
          },
        );
      }),
    );
  }

  // Formatear el timestamp para mostrarlo como texto
  String _formatTimestamp(Timestamp timestamp) {
    DateTime date = timestamp.toDate();
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}";
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:findapet/controllers/chat_controller.dart';

class ChatPage extends StatelessWidget {
  final String receiverID;

  ChatPage({required this.receiverID});

  @override
  Widget build(BuildContext context) {
    final ChatController chatController = Get.find<ChatController>();
    chatController.initChat(receiverID);

    TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF0F440),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20, // Tamaño del avatar
              backgroundImage: NetworkImage(
                chatController.receiversInfo[receiverID]?.profileImageUrl ?? '',
              ),
            ),
            SizedBox(width: 15), // Espaciado entre la imagen y el nombre
            Expanded(
              child: Text(
                chatController.receiversInfo[receiverID]?.name ?? 'Usuario',
                style: TextStyle(color: Colors.black), // Estilo del texto
                overflow: TextOverflow.ellipsis, // Manejo de texto largo
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: Obx(() {
              if (chatController.isLoadingMessages.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (chatController.messages.isEmpty) {
                return Center(child: Text('No hay mensajes aún'));
              }

              return ListView.builder(
                reverse: true,
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  final message = chatController.messages[index];
                  final isSentByMe =
                      message.senderID == chatController.currentUserID;

                  return Align(
                    alignment: isSentByMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSentByMe
                            ? const Color(0xFFF0F440)
                            : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(message.message),
                    ),
                  );
                },
              );
            }),
          ),

          // Campo de texto para enviar mensajes
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onSubmitted: (text) {
                      if (text.isNotEmpty) {
                        chatController.sendMessage(receiverID, text);
                        messageController.clear();
                      }
                    },
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (messageController.text.isNotEmpty) {
                      chatController.sendMessage(
                          receiverID, messageController.text);
                      messageController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

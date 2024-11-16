import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:findapet/controllers/chat_controller.dart';
import 'package:findapet/models/message.dart';

class ChatPage extends StatelessWidget {
  final ChatController chatController = Get.put(ChatController());

  // Constructor para inicializar los datos del chat
  final String receiverID;

  ChatPage({
    required this.receiverID,
    Key? key,
  }) : super(key: key) {
    chatController.initChat(
      otherUserID: receiverID,
    );
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController messageController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat con $receiverID'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Lista de mensajes
          Expanded(
            child: Obx(() {
              if (chatController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }

              if (chatController.messages.isEmpty) {
                return Center(child: Text('No hay mensajes aún'));
              }

              return ListView.builder(
                reverse: true, // Mensajes más recientes al final
                itemCount: chatController.messages.length,
                itemBuilder: (context, index) {
                  Message message = chatController.messages[index];
                  bool isSentByMe =
                      message.senderID == chatController.currentUserID;
                  return Align(
                    alignment: isSentByMe
                        ? Alignment.centerRight
                        : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isSentByMe ? Colors.blue[200] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        message.message,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  );
                },
              );
            }),
          ),

          // Campo de texto y botón de enviar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Campo de texto
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: InputDecoration(
                      hintText: 'Escribe un mensaje...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 8),

                // Botón de enviar
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blue),
                  onPressed: () {
                    String text = messageController.text.trim();
                    if (text.isNotEmpty) {
                      chatController.sendMessage(text);
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

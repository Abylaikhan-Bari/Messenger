import 'package:flutter/material.dart';
import '../../domain/chat.dart';
import 'chat_page.dart'; // This is where chat messages would be shown

class ChatsPage extends StatelessWidget {
  final List<Chat> chats = [
    Chat(id: '1', name: 'Chat One', lastMessage: 'Hey there!', timestamp: DateTime.now().subtract(Duration(minutes: 5))),
    Chat(id: '2', name: 'Chat Two', lastMessage: 'How are you?', timestamp: DateTime.now().subtract(Duration(hours: 1))),
    // Add more chats as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          Chat chat = chats[index];
          return ListTile(
            title: Text(chat.name),
            subtitle: Text(chat.lastMessage),
            trailing: Text(chat.timestamp.toLocal().toString()),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ChatPage(chatId: chat.id),
              ));
            },
          );
        },
      ),
    );
  }
}

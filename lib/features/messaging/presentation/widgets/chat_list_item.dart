import 'package:flutter/material.dart';
import '../../domain/chat.dart';
import '../pages/chat_page.dart';

class ChatListItem extends StatelessWidget {
  final Chat chat;

  const ChatListItem({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(chat.name),
      subtitle: Text(chat.lastMessage),
      trailing: Text(chat.timestamp.toLocal().toString()),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(chatId: chat.id),
          ),
        );
      },
    );
  }
}

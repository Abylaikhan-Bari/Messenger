import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../domain/message.dart';

class ChatPage extends StatefulWidget {
  final String chatId;

  ChatPage({required this.chatId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void sendMessage() {
    final text = _controller.text;
    if (text.isNotEmpty) {
      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: widget.chatId,
        senderId: '123', // Replace with actual sender ID
        text: text,
        timestamp: DateTime.now(),
      );

      _firestore.collection('chats/${widget.chatId}/messages').add(message.toJson());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('chats/${widget.chatId}/messages').orderBy('timestamp', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                final docs = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: docs.length,
                  reverse: true,
                  itemBuilder: (context, index) {
                    final message = Message.fromFirestore(docs[index]);
                    return ListTile(
                      title: Text(message.text),
                      subtitle: Text(message.timestamp.toLocal().toString()),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Send a message...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

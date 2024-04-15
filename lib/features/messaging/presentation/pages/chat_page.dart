import 'package:flutter/material.dart';
import '../../domain/message.dart';

class ChatPage extends StatefulWidget {
  final String chatId;

  ChatPage({required this.chatId});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  List<Message> messages = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    // This would usually be where you load messages from your backend
    messages = [
      Message(id: '1', chatId: widget.chatId, senderId: '123', text: 'Hello!', timestamp: DateTime.now().subtract(Duration(minutes: 1))),
      Message(id: '2', chatId: widget.chatId, senderId: '456', text: 'Hi there!', timestamp: DateTime.now().subtract(Duration(minutes: 2))),
      // Add more messages as needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              reverse: true,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index].text),
                  subtitle: Text(messages[index].timestamp.toLocal().toString()),
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
                  onPressed: () {
                    // Here you would normally handle sending the message
                    if (_controller.text.isNotEmpty) {
                      setState(() {
                        messages.insert(0, Message(
                          id: DateTime.now().toString(),
                          chatId: widget.chatId,
                          senderId: '123',  // Typically the current user ID
                          text: _controller.text,
                          timestamp: DateTime.now(),
                        ));
                      });
                      _controller.clear();
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

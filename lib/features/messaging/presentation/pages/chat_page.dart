import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String chatName = "Chat"; // Default chat name

  @override
  void initState() {
    super.initState();
    _getChatDetails();
  }

  void _getChatDetails() async {
    DocumentSnapshot chatDoc =
        await _firestore.collection('chats').doc(widget.chatId).get();
    setState(() {
      chatName = chatDoc['name'] ?? "Chat"; // Set chat name from Firestore
    });
  }

  void sendMessage() {
    final text = _controller.text;
    if (text.isNotEmpty && FirebaseAuth.instance.currentUser != null) {
      User currentUser = FirebaseAuth.instance.currentUser!;
      final message = Message(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        chatId: widget.chatId,
        senderId: currentUser.uid,
        name: currentUser.displayName ?? "Unknown User",
        text: text,
        timestamp: DateTime.now(),
      );

      _firestore
          .collection('chats/${widget.chatId}/messages')
          .add(message.toJson());
      _controller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to send a message.')),
      );
    }
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    try {
      Message message = Message.fromFirestore(doc);
      bool isMe = FirebaseAuth.instance.currentUser?.uid == message.senderId;

      return Container(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              decoration: BoxDecoration(
                color: isMe ? Colors.green[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(message.name,
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(message.text),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 2.0,
                bottom: 4.0,
                left: isMe ? 0 : 8.0,
                right: isMe ? 8.0 : 0,
              ),
              child: Text(
                message.timestamp.toLocal().toString(),
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ),
          ],
        ),
      );
    } catch (e) {
      // Log the error or handle it appropriately
      return ListTile(
        title: Text('Error displaying message'),
        subtitle: Text(e.toString()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(chatName), // Display dynamic chat name
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats/${widget.chatId}/messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(child: CircularProgressIndicator());
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  reverse: true,
                  itemBuilder: (context, index) =>
                      _buildMessageItem(snapshot.data!.docs[index]),
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

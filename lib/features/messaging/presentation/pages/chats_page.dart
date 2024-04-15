import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/pages/login_page.dart';
import '../../domain/chat.dart';
import '../widgets/chat_list_item.dart';
import 'chat_page.dart';

class ChatsPage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> _createNewChat(BuildContext context) async {
    final User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You need to be logged in to start a new chat.')),
      );
      return;
    }

    final TextEditingController _chatNameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Create New Chat'),
          content: TextField(
            controller: _chatNameController,
            decoration: InputDecoration(hintText: "Enter chat name"),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () async {
                if (_chatNameController.text.isNotEmpty) {
                  try {
                    DocumentReference newChatRef = await _firestore.collection('chats').add({
                      'name': _chatNameController.text,
                      'initiatedBy': currentUser.uid,
                      'lastMessage': '',
                      'timestamp': FieldValue.serverTimestamp(),
                    });
                    Navigator.pop(context); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ChatPage(chatId: newChatRef.id)),
                    );
                  } catch (e) {
                    Navigator.pop(context); // Close the dialog
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to create new chat: ${e.toString()}')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Chat name cannot be empty')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteChat(BuildContext context, String chatId) async {
    try {
      await _firestore.collection('chats').doc(chatId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Chat deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting chat: ${e.toString()}')),
      );
    }
  }

  Stream<List<Chat>> getChatsStream() {
    return _firestore.collection('chats').orderBy('timestamp', descending: true).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Chat.fromFirestore(doc)).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.exit_to_app, color: Colors.black),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Confirm Sign Out'),
                    content: const Text('Are you sure you want to sign out?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<AuthBloc>().add(AuthSignOutRequested());
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(builder: (context) => LoginPage()),
                                (Route<dynamic> route) => false,
                          );
                        },
                        child: const Text('Sign Out'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Chat>>(
        stream: getChatsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Error fetching chats: ${snapshot.error}');
            return Center(child: Text("Error fetching data: ${snapshot.error}"));
          }
          final List<Chat> chats = snapshot.data ?? [];
          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(chatId: chat.id),
                    ),
                  );
                },
                onLongPress: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Delete Chat'),
                      content: Text('Are you sure you want to delete this chat? This cannot be undone.'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(); // Close the dialog first
                            _deleteChat(context, chat.id);
                          },
                          child: Text('Delete'),
                        ),
                      ],
                    ),
                  );
                },
                child: ChatListItem(chat: chat),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _createNewChat(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}

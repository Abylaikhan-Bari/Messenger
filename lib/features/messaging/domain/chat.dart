import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime timestamp;

  Chat(
      {required this.id,
      required this.name,
      required this.lastMessage,
      required this.timestamp});

  factory Chat.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Chat(
      id: doc.id,
      name: data['name'], // Make sure this is correctly mapped
      lastMessage: data['lastMessage'] ?? '',
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class Chat {
  final String id;
  final String name;
  final String lastMessage;
  final DateTime timestamp;

  Chat({required this.id, required this.name, required this.lastMessage, required this.timestamp});

  // Factory constructor to create a Chat instance from a Firestore document.
  factory Chat.fromFirestore(DocumentSnapshot doc) {
    var data = doc.data() as Map<String, dynamic>;
    return Chat(
      id: doc.id,
      name: doc.id,  // Assuming you use chat document ID as chat name
      lastMessage: data['lastMessage'] ?? '', // Default to empty string if lastMessage is not set
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }
}


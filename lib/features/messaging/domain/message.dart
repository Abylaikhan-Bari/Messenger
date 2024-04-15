import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String id;
  final String chatId;
  final String senderId;
  final String name; // Confirm this is the correct field name for sender's name
  final String text;
  final DateTime timestamp;

  Message({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.name, // Make sure this matches the actual field name used
    required this.text,
    required this.timestamp,
  });

  factory Message.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>? ?? {};

    if (!data.containsKey('senderId') || data['senderId'] == null) {
      throw Exception("Required field 'senderId' is missing or null");
    }
    if (!data.containsKey('text') || data['text'] == null) {
      throw Exception("Required field 'text' is missing or null");
    }

    return Message(
      id: doc.id,
      chatId: data['chatId'] ?? '',
      senderId: data['senderId'] as String, // Ensuring non-null with cast
      name: data['name'] ?? 'Unknown',
      text: data['text'] as String, // Ensuring non-null with cast
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'name': name,
      'text': text,
      'timestamp': timestamp,
    };
  }
}

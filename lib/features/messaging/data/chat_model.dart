import '../domain/chat.dart';

class ChatModel extends Chat {
  ChatModel({required String id, required String name, required String lastMessage, required DateTime timestamp})
      : super(id: id, name: name, lastMessage: lastMessage, timestamp: timestamp);

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      name: json['name'],
      lastMessage: json['lastMessage'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastMessage': lastMessage,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
import '../domain/message.dart';

class MessageModel extends Message {
  MessageModel({
    required String id,
    required String chatId,
    required String senderId,
    required String text,
    required DateTime timestamp,
  }) : super(
    id: id,
    chatId: chatId,
    senderId: senderId,
    text: text,
    timestamp: timestamp,
  );

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      chatId: json['chatId'],
      senderId: json['senderId'],
      text: json['text'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chatId': chatId,
      'senderId': senderId,
      'text': text,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}

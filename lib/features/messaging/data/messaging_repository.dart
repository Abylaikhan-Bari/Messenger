import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import '../../../core/error/failures.dart';
import '../domain/message.dart';

abstract class MessagingRepository {
  Future<Either<Failure, List<Message>>> getMessages(String chatId);
  Future<Either<Failure, void>> sendMessage(String chatId, Message message);
}

class FirebaseMessagingRepository implements MessagingRepository {
  final FirebaseFirestore _firestore;

  FirebaseMessagingRepository(this._firestore);

  @override
  Future<Either<Failure, List<Message>>> getMessages(String chatId) async {
    try {
      final querySnapshot = await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .orderBy('timestamp', descending: true)
          .get();
      final List<Message> messages = querySnapshot.docs
          .map((doc) => Message.fromFirestore(doc))
          .toList();
      return Right(messages);
    } catch (e) {
      return Left(Failure("Failed to fetch messages: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(
      String chatId, Message message) async {
    try {
      await _firestore
          .collection('chats')
          .doc(chatId)
          .collection('messages')
          .add(message.toJson());
      return Right(null);
    } catch (e) {
      return Left(Failure("Failed to send message: $e"));
    }
  }
}

void main() {
  // Instantiate FirebaseMessagingRepository with a Firestore instance
  FirebaseMessagingRepository messagingRepository = FirebaseMessagingRepository(FirebaseFirestore.instance);

  final chatId = 'exampleChatId';
  messagingRepository.getMessages(chatId).then((either) {
    either.fold(
          (failure) => print('Failed to get messages: ${failure.message}'),
          (messages) => print('Received messages: $messages'),
    );
  });
}

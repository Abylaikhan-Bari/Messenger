import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/message.dart';
import '../../data/messaging_repository.dart';

// Messaging States
abstract class MessagingState {}
class MessagingInitial extends MessagingState {}
class MessagesLoaded extends MessagingState {
  final List<Message> messages;
  MessagesLoaded(this.messages);
}
class MessageError extends MessagingState {
  final String error;
  MessageError(this.error);
}

// Messaging Events
abstract class MessagingEvent {}
class LoadMessages extends MessagingEvent {
  final String chatId;
  LoadMessages(this.chatId);
}
class SendMessage extends MessagingEvent {
  final Message message;
  SendMessage(this.message);
}

class MessagingBloc extends Bloc<MessagingEvent, MessagingState> {
  final MessagingRepository messagingRepository;

  MessagingBloc(this.messagingRepository) : super(MessagingInitial()) {
    on<LoadMessages>(handleLoadMessages);
    on<SendMessage>(handleSendMessage);
  }

  Future<void> handleLoadMessages(LoadMessages event, Emitter<MessagingState> emit) async {
    emit(MessagingInitial());
    try {
      var result = await messagingRepository.getMessages(event.chatId);
      result.fold(
              (failure) => emit(MessageError(failure.message)),
              (messages) => emit(MessagesLoaded(messages))
      );
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }

  Future<void> handleSendMessage(SendMessage event, Emitter<MessagingState> emit) async {
    try {
      var result = await messagingRepository.sendMessage(event.message.chatId, event.message);
      result.fold(
              (failure) => emit(MessageError(failure.message)),
              (_) => add(LoadMessages(event.message.chatId))  // Reload messages after sending
      );
    } catch (e) {
      emit(MessageError(e.toString()));
    }
  }
}

part of 'message_bloc.dart';

abstract class MessageState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MessageInitial extends MessageState {}

class MessageLoading extends MessageState {}

class MessageListLoaded extends MessageState {
  final Stream<dynamic> messageList;

  MessageListLoaded(this.messageList);

  @override
  List<Object> get props => [messageList];
}

class SendMessageSuccess extends MessageState {}

class NewChatAndMessageCreated extends MessageState {
  final String chatId;

  NewChatAndMessageCreated(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class MessageError extends MessageState {
  final String error;

  MessageError(this.error);

  @override
  List<Object?> get props => [error];
}

part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatInitial extends ChatState {}

class ChatListLoading extends ChatState {}

class ChatListLoaded extends ChatState {
  Stream<dynamic> chatList;

  ChatListLoaded(this.chatList);

  @override
  List<Object> get props => [chatList];
}

class ChatError extends ChatState {
  final String error;

  ChatError(this.error);

  @override
  List<Object?> get props => [error];
}

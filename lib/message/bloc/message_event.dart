part of 'message_bloc.dart';

abstract class MessageEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetMessageList extends MessageEvent {
  final String chatId;

  GetMessageList(this.chatId);

  @override
  List<Object> get props => [chatId];
}

class SendMessage extends MessageEvent {
  final String chatId;
  final String message;

  SendMessage(this.chatId, this.message);

  @override
  List<Object> get props => [chatId, message];
}

class CreateNewChatAndMessage extends MessageEvent {
  final String umkmId;
  final String influencerId;
  final String recentMessage;
  final String? negotiationId;

  CreateNewChatAndMessage(
      this.umkmId, this.influencerId, this.recentMessage, this.negotiationId);

  @override
  List<Object> get props =>
      [umkmId, influencerId, recentMessage, negotiationId!];
}

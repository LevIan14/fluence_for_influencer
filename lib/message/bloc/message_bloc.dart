import 'package:equatable/equatable.dart';
import 'package:fluence_for_influencer/message/repository/message_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final MessageRepository messageRepository;

  MessageBloc({required this.messageRepository}) : super(MessageInitial()) {
    on<GetMessageList>((event, emit) async {
      try {
        emit(MessageLoading());
        final Stream<dynamic> messageList =
            await messageRepository.getMessageList(event.chatId);
        emit(MessageListLoaded(messageList));
      } catch (e) {
        emit(MessageError(e.toString()));
      }
    });

    on<SendMessage>((event, emit) async {
      try {
        await messageRepository.sendMessage(event.chatId, event.message);
      } catch (e) {
        emit(MessageError(e.toString()));
      }
    });
  }
}

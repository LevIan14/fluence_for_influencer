import 'package:equatable/equatable.dart';
import 'package:fluence_for_influencer/chat/repository/chat_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;

  ChatBloc({required this.chatRepository}) : super(ChatInitial()) {
    on<GetChatList>((event, emit) async {
      try {
        emit(ChatListLoading());
        final Stream<dynamic> chatList = await chatRepository.getChatList();
        emit(ChatListLoaded(chatList));
      } catch (e) {
        emit(ChatError(e.toString()));
      }
    });
  }
}

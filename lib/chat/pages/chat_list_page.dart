import 'package:fluence_for_influencer/chat/bloc/chat_bloc.dart';
import 'package:fluence_for_influencer/chat/repository/chat_repository.dart';
import 'package:fluence_for_influencer/chat/widgets/chat_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  TextEditingController messageController = TextEditingController();
  late final ChatBloc chatBloc;
  final ChatRepository chatRepository = ChatRepository();

  @override
  void initState() {
    super.initState();
    chatBloc = ChatBloc(chatRepository: chatRepository);
    chatBloc.add(GetChatList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          title: const Text('List Chat'),
        ),
        body: BlocProvider(
            create: (context) => chatBloc,
            child: BlocConsumer<ChatBloc, ChatState>(
              listener: (context, state) {
                if (state is ChatError) {}
              },
              builder: (context, state) {
                if (state is ChatListLoading) {
                  return const SafeArea(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (state is ChatListLoaded) {
                  return StreamBuilder(
                      stream: state.chatList,
                      builder: (context, AsyncSnapshot snapshot) {
                        return snapshot.hasData
                            ? ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  return ChatRow(
                                    chatId: snapshot.data.docs[index].id,
                                    umkmId: snapshot.data.docs[index]
                                        ['umkm_id'],
                                    influencerId: snapshot.data.docs[index]
                                        ['influencer_id'],
                                    recentMessage: snapshot.data.docs[index]
                                        ['recent_message'],
                                  );
                                },
                              )
                            : _loadingAnimationCircular();
                      });
                }
                return Container();
              },
            )));
  }

  Widget _loadingAnimationCircular() {
    return const SafeArea(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

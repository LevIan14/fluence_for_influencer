import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluence_for_influencer/message/bloc/message_bloc.dart';
import 'package:fluence_for_influencer/message/repository/message_repository.dart';
import 'package:fluence_for_influencer/message/widgets/message_tile.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/util/date_utility.dart';
import 'package:fluence_for_influencer/umkm/pages/umkm_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MessageListPage extends StatefulWidget {
  final String fromUserName;
  String chatId;
  final String umkmId;
  final String influencerId;
  MessageListPage(
      {Key? key,
      required this.fromUserName,
      required this.chatId,
      required this.umkmId,
      required this.influencerId})
      : super(key: key);

  @override
  State<MessageListPage> createState() => _MessageListPageState();
}

class _MessageListPageState extends State<MessageListPage> {
  TextEditingController messageController = TextEditingController();
  late final MessageBloc messageBloc;
  final MessageRepository messageRepository = MessageRepository();

  ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    messageBloc = MessageBloc(messageRepository: messageRepository);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.chatId != "") {
      messageBloc.add(GetMessageList(widget.chatId));
    }

    return BlocProvider(
        create: (context) => messageBloc,
        child:
            BlocConsumer<MessageBloc, MessageState>(listener: (context, state) {
          if (state is NewChatAndMessageCreated) {
            messageBloc.add(GetMessageList(state.chatId));
          }
        }, builder: (context, state) {
          if (state is MessageLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is MessageListLoaded) {
            return Scaffold(
                appBar: AppBar(
                  flexibleSpace: GestureDetector(onTap: () {
                    print('hasi');

                    nextScreen(context, UmkmProfilePage(umkmId: widget.umkmId));
                  }),
                  elevation: 0,
                  title: GestureDetector(
                    onTap: () {
                      nextScreen(
                          context, UmkmProfilePage(umkmId: widget.umkmId));
                    },
                    child: Text(widget.fromUserName),
                  ),
                  backgroundColor: Constants.primaryColor,
                ),
                body: Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Column(
                    children: [
                      StreamBuilder(
                          stream: state.messageList,
                          builder: (context, AsyncSnapshot snapshot) {
                            DateTime tmpDate = DateUtil.tomorrow();

                            return snapshot.hasData
                                ? Expanded(
                                    child: SingleChildScrollView(
                                      reverse: true,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data.docs.length,
                                        itemBuilder: (context, index) {
                                          Timestamp timestampFromSnapshot =
                                              snapshot.data.docs[index]
                                                  ['created_at'];
                                          DateTime dateTime =
                                              timestampFromSnapshot.toDate();

                                          String negotiationId = "";

                                          try {
                                            negotiationId = snapshot.data
                                                .docs[index]['negotiation_id'];
                                          } catch (e) {
                                            negotiationId = "";
                                          }

                                          var isSameDate = false;

                                          isSameDate =
                                              tmpDate.isSameDate(dateTime);

                                          if (!isSameDate) {
                                            tmpDate = dateTime;
                                          }

                                          String date =
                                              DateUtil.dateWithDayFormat(
                                                  dateTime);

                                          String timestamp =
                                              DateUtil.hMMFormat(dateTime);

                                          return MessageTile(
                                              umkmId: widget.umkmId,
                                              influencerId: widget.influencerId,
                                              negotiationId: negotiationId,
                                              message: snapshot.data.docs[index]
                                                  ['message'],
                                              chatId: widget.chatId,
                                              showDate: !isSameDate,
                                              timestamp: timestamp,
                                              date: date,
                                              sender: snapshot.data.docs[index]
                                                  ['sender_id'],
                                              sentByMe: Constants.firebaseAuth
                                                      .currentUser!.uid ==
                                                  snapshot.data.docs[index]
                                                      ['sender_id']);
                                        },
                                      ),
                                    ),
                                  )
                                : const Expanded(
                                    child: Center(
                                        child: CircularProgressIndicator
                                            .adaptive()));
                          }),
                      Container(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(30)),
                          child: Row(children: [
                            Expanded(
                                child: TextFormField(
                              cursorColor: Colors.grey,
                              maxLines: null,
                              controller: messageController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                            )),
                            GestureDetector(
                              onTap: () {
                                sendMessage(context, widget.chatId);
                              },
                              child: Container(
                                margin: const EdgeInsets.only(left: 8),
                                child: const Center(
                                  child: Icon(
                                    Icons.send,
                                    color: Constants.primaryColor,
                                    size: 18,
                                  ),
                                ),
                              ),
                            )
                          ]),
                        ),
                      ),
                    ],
                  ),
                ));
          }
          return Container();
        }));
  }

  sendMessage(BuildContext context, String chatId) {
    if (messageController.text.isNotEmpty) {
      if (chatId != "") {
        messageBloc.add(SendMessage(chatId, messageController.text));
      } else if (chatId == "") {
        messageBloc.add(CreateNewChatAndMessage(
            widget.umkmId, widget.influencerId, messageController.text, null));
      }
      messageController.clear();
    }
  }
}

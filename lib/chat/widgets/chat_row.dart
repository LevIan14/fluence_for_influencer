import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluence_for_influencer/message/pages/message_list_page.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/util/date_utility.dart';
import 'package:fluence_for_influencer/umkm/bloc/umkm_bloc.dart';
import 'package:fluence_for_influencer/umkm/repository/umkm_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatRow extends StatefulWidget {
  final String chatId;
  final String umkmId;
  final String influencerId;
  final String recentMessage;
  final Timestamp timestamp;

  const ChatRow({
    Key? key,
    required this.chatId,
    required this.umkmId,
    required this.influencerId,
    required this.recentMessage,
    required this.timestamp,
  }) : super(key: key);

  @override
  State<ChatRow> createState() => ChatRowState();
}

class ChatRowState extends State<ChatRow> {
  late final UmkmBloc umkmBloc;
  final UmkmRepository umkmRepository = UmkmRepository();

  @override
  void initState() {
    super.initState();
    umkmBloc = UmkmBloc(umkmRepository: umkmRepository);
  }

  @override
  Widget build(BuildContext context) {
    umkmBloc.add(GetUmkmNameAndImage(widget.umkmId));

    return BlocProvider(
      create: (context) => umkmBloc,
      child: BlocConsumer<UmkmBloc, UmkmState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is UmkmNameLoaded) {
            return GestureDetector(
              onTap: () {
                nextScreen(
                    context,
                    MessageListPage(
                      fromUserName: state.umkmName,
                      chatId: widget.chatId,
                      umkmId: widget.umkmId,
                      influencerId: widget.influencerId,
                    ));
              },
              child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(state.profileImageUmkmUrl),
                  ),
                  title: Text(state.umkmName),
                  trailing: DateUtil.isToday(widget.timestamp.toDate())
                      ? const Text("Today")
                      : DateUtil.isYesterday(widget.timestamp.toDate())
                          ? const Text("Yesterday")
                          : Text(DateUtil.dateWithSlashFormat(
                              widget.timestamp.toDate())),
                  subtitle: Text(
                    widget.recentMessage,
                    overflow: TextOverflow.ellipsis,
                  )),
            );
          }
          return Container();
        },
      ),
    );
  }
}

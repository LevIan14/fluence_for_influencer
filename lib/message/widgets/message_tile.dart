import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/negotiation/pages/negotiation_detail_page.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/umkm/repository/umkm_repository.dart';
import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget {
  final String message;
  final bool showDate;
  final String timestamp;
  final String date;
  final String sender;
  final bool sentByMe;
  final String negotiationId;
  final String chatId;
  const MessageTile(
      {Key? key,
      required this.message,
      required this.showDate,
      required this.timestamp,
      required this.date,
      required this.sender,
      required this.sentByMe,
      required this.negotiationId,
      required this.chatId})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  UmkmRepository umkmRepository = UmkmRepository();
  InfluencerRepository influencerRepository = InfluencerRepository();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            widget.sentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (widget.showDate) _dateSeparator(context, widget.date),
          Column(
            crossAxisAlignment: widget.sentByMe
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              widget.negotiationId == ""
                  ? Container(
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75),
                      padding: const EdgeInsets.only(
                          top: 17, bottom: 17, left: 20, right: 20),
                      decoration: BoxDecoration(
                          borderRadius: widget.sentByMe
                              ? const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                )
                              : const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                          color: widget.sentByMe
                              ? Theme.of(context).primaryColor
                              : Colors.grey[700]),
                      child: Text(widget.message,
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                              fontSize: 16, color: Colors.white)))
                  : GestureDetector(
                      onTap: () {
                        nextScreen(
                            context,
                            NegotiationDetailPage(
                              negotiationId: widget.negotiationId,
                              chatId: widget.chatId,
                              sentByMe: widget.sentByMe,
                            ));
                      },
                      child: Container(
                        constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75),
                        padding: const EdgeInsets.only(
                            top: 17, bottom: 17, left: 20, right: 20),
                        decoration: BoxDecoration(
                            borderRadius: widget.sentByMe
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomLeft: Radius.circular(20),
                                  )
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                    bottomRight: Radius.circular(20),
                                  ),
                            color: widget.sentByMe
                                ? Theme.of(context).primaryColor
                                : Colors.grey[700]),
                        child: Column(children: [
                          Text(
                            widget.message,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                          const Text(
                            "Tap to see details",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          )
                        ]),
                      ),
                    ),
              Text(
                widget.timestamp,
              )
            ],
          )
        ],
      ),
    );
  }
}

Widget _dateSeparator(BuildContext context, String date) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 16),
    child: Row(children: [
      const Expanded(child: Divider()),
      Center(
        child: Container(
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(date),
        ),
      ),
      const Expanded(child: Divider()),
    ]),
  );
}

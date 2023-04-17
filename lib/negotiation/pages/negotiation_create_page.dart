import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class NegotiationCreatePage extends StatefulWidget {
  final String fromUserName;
  final String chatId;
  final String umkmId;
  final String influencerId;

  const NegotiationCreatePage(
      {Key? key,
      required this.fromUserName,
      required this.chatId,
      required this.umkmId,
      required this.influencerId})
      : super(key: key);

  @override
  State<NegotiationCreatePage> createState() => _NegotiationCreatePageState();
}

class _NegotiationCreatePageState extends State<NegotiationCreatePage> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

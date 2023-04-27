import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ReviewPage extends StatefulWidget {
  final String influencerId;
  final String transactionId;
  final String? reviewId;
  const ReviewPage(
      {Key? key,
      required this.influencerId,
      required this.transactionId,
      this.reviewId})
      : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

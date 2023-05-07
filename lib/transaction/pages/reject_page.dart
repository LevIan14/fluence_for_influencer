import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/widgets/text_input.dart';
import 'package:flutter/material.dart';

class RejectPage extends StatefulWidget {
  final String reason;
  const RejectPage({Key? key, required this.reason}) : super(key: key);

  @override
  State<RejectPage> createState() => _RejectPageState();
}

class _RejectPageState extends State<RejectPage> {
  final TextEditingController _rejectReasonController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _rejectReasonController.text = widget.reason;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pembatalan Transaksi"),
        backgroundColor: Constants.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Alasan',
              style: TextStyle(color: Constants.primaryColor),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _rejectReasonController,
              readOnly: true,
              maxLines: null,
              decoration: textInputDecoration,
            )
          ],
        ),
      ),
    );
  }
}

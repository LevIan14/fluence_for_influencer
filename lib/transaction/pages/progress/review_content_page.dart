import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/transaction/bloc/transaction_bloc.dart';
import 'package:fluence_for_influencer/transaction/repository/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewContentPage extends StatefulWidget {
  final String transactionId;

  const ReviewContentPage({Key? key, required this.transactionId})
      : super(key: key);

  @override
  State<ReviewContentPage> createState() => _ReviewContentPageState();
}

class _ReviewContentPageState extends State<ReviewContentPage> {
  late final TransactionBloc transactionBloc;
  final TransactionRepository transactionRepository = TransactionRepository();

  final TextEditingController _contentNoteController = TextEditingController();
  final TextEditingController _reviewNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    transactionBloc =
        TransactionBloc(transactionRepository: transactionRepository);
    transactionBloc.add(GetTransactionDetail(widget.transactionId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => transactionBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text("Review Content")),
        body: BlocConsumer<TransactionBloc, TransactionState>(
          listener: (context, state) {
            if (state is TransactionProcessSuccess) {
              navigateAsFirstScreen(context, const MainPage(index: 0));
            }
          },
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is TransactionLoaded) {
              _contentNoteController.text =
                  state.transaction.orderProgress.reviewContent.influencerNote;
              _reviewNoteController.text =
                  state.transaction.orderProgress.reviewContent.umkmNote;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Content Note"),
                    const SizedBox(height: 8),
                    TextFormField(
                      maxLines: null,
                      controller: _contentNoteController,
                      validator: (value) =>
                          value!.isEmpty ? "Insert content note" : null,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                    ),
                    const SizedBox(height: 16),
                    const Text("Review Note"),
                    const SizedBox(height: 8),
                    TextFormField(
                      readOnly: true,
                      maxLines: null,
                      controller: _reviewNoteController,
                    )
                  ],
                ),
              );
            }
            return Container();
          },
        ),
        bottomNavigationBar: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoaded) {
              return state.transaction.orderProgress.reviewContent.status ==
                      "NEED REVISION"
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () {
                                  if (_contentNoteController.text.isNotEmpty) {
                                    transactionBloc.add(
                                        UpdateStatusReviewContent(
                                            widget.transactionId,
                                            _contentNoteController.text,
                                            "ON REVIEW",
                                            state.transaction.orderProgress));
                                  }
                                },
                                child: const Text("Update Status"))),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                              onPressed: () {
                                transactionBloc.add(SaveNotesReviewContent(
                                    widget.transactionId,
                                    _contentNoteController.text,
                                    state.transaction.orderProgress));
                              },
                              child: const Text("Save Note")),
                        )
                      ]),
                    )
                  : const Padding(padding: EdgeInsets.all(0));
            }
            return Container();
          },
        ),
      ),
    );
  }
}

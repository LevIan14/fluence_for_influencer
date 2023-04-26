import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/transaction/bloc/transaction_bloc.dart';
import 'package:fluence_for_influencer/transaction/repository/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContentProgressPage extends StatefulWidget {
  final String transactionId;
  const ContentProgressPage({Key? key, required this.transactionId})
      : super(key: key);

  @override
  State<ContentProgressPage> createState() => _ContentProgressPageState();
}

class _ContentProgressPageState extends State<ContentProgressPage> {
  late final TransactionBloc transactionBloc;
  final TransactionRepository transactionRepository = TransactionRepository();

  final TextEditingController _notesController = TextEditingController();

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
        appBar: AppBar(
          title: const Text("Content Progress"),
        ),
        body: BlocConsumer<TransactionBloc, TransactionState>(
          listener: (context, state) {
            if (state is TransactionProcessSuccess) {
              navigateAsFirstScreen(context, const MainPage());
            }
          },
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is TransactionLoaded) {
              _notesController.text = state
                  .transaction.orderProgress.contentProgress.influencerNote;
              return Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Notes"),
                          const SizedBox(height: 8),
                          TextField(
                              controller: _notesController, maxLines: null)
                        ]),
                  ));
            }
            return Container();
          },
        ),
        bottomNavigationBar: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoaded) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            transactionBloc.add(UpdateStatusContentProgress(
                                widget.transactionId,
                                _notesController.text,
                                "DONE",
                                state.transaction.orderProgress));
                          },
                          child: const Text("Update Status")),
                    ),
                    SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                            onPressed: () {
                              transactionBloc.add(SaveNotesContentProgress(
                                  widget.transactionId,
                                  _notesController.text,
                                  state.transaction.orderProgress));
                            },
                            child: const Text("Save Notes"))),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

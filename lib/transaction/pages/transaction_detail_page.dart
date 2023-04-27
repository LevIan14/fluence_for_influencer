import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/transaction/bloc/transaction_bloc.dart';
import 'package:fluence_for_influencer/transaction/pages/review/review_page.dart';
import 'package:fluence_for_influencer/transaction/pages/transaction_progress_page.dart';
import 'package:fluence_for_influencer/transaction/repository/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionDetailPage extends StatefulWidget {
  final String transactionId;

  const TransactionDetailPage({Key? key, required this.transactionId})
      : super(key: key);

  @override
  State<TransactionDetailPage> createState() => TransactionDetailPageState();
}

class TransactionDetailPageState extends State<TransactionDetailPage> {
  late final TransactionBloc transactionBloc;
  final TransactionRepository transactionRepository = TransactionRepository();

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
            title: const Text("Transaction Detail"),
          ),
          body: BlocConsumer<TransactionBloc, TransactionState>(
            listener: (context, state) async {
              if (state is TransactionError) {
                print(state.error);
              }
            },
            builder: (context, state) {
              if (state is TransactionLoading) {
                return const CircularProgressIndicator.adaptive();
              }
              if (state is TransactionLoaded) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Status Transaksi"),
                              Text("Tanggal Transaksi")
                            ]),
                      ),
                      const Divider(),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text("Detail Project"),
                                      Text("Nama influencer")
                                    ],
                                  )),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: const [
                                      Text("Project Title"),
                                      Text("Amount")
                                    ],
                                  ),
                                  const Text("Date Range - Date Range"),
                                ],
                              ),
                              const Divider(),
                              const Text("Project Description"),
                            ]),
                      ),
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
                return Padding(
                    padding: const EdgeInsets.all(8),
                    child: state.transaction.transactionStatus == "DONE"
                        ? Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              state.transaction.reviewId.isEmpty
                                  ? SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            nextScreen(
                                                context,
                                                ReviewPage(
                                                    influencerId: state
                                                        .transaction
                                                        .influencerId,
                                                    transactionId:
                                                        widget.transactionId));
                                          },
                                          child: const Text("Give Review")),
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            nextScreen(
                                                context,
                                                ReviewPage(
                                                    influencerId: state
                                                        .transaction
                                                        .influencerId,
                                                    transactionId:
                                                        widget.transactionId,
                                                    reviewId: state
                                                        .transaction.reviewId));
                                          },
                                          child: const Text("Check Review"))),
                              SizedBox(
                                width: double.infinity,
                                child: OutlinedButton(
                                    onPressed: () {
                                      nextScreen(
                                          context,
                                          TransactionProgressPage(
                                            transactionId: widget.transactionId,
                                          ));
                                    },
                                    child: const Text("Check Progress")),
                              ),
                            ],
                          )
                        : ElevatedButton(
                            onPressed: () {
                              nextScreen(
                                  context,
                                  TransactionProgressPage(
                                      transactionId: state.transaction.id));
                            },
                            child: const Text("Check Progress")));
              }
              return Container();
            },
          ),
        ));
  }
}

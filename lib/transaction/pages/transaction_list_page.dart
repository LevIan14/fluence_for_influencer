import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/transaction/bloc/transaction_bloc.dart';
import 'package:fluence_for_influencer/transaction/repository/transaction_repository.dart';
import 'package:fluence_for_influencer/transaction/widget/transaction_list_row.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionListPage extends StatefulWidget {
  const TransactionListPage({super.key});

  @override
  State<TransactionListPage> createState() => _TransactionListPageState();
}

class _TransactionListPageState extends State<TransactionListPage> {
  late final TransactionBloc transactionBloc;
  final TransactionRepository transactionRepository = TransactionRepository();

  @override
  void initState() {
    super.initState();
    transactionBloc =
        TransactionBloc(transactionRepository: transactionRepository);
    transactionBloc
        .add(GetTransactionList(Constants.firebaseAuth.currentUser!.uid));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => transactionBloc,
        child: BlocConsumer<TransactionBloc, TransactionState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is TransactionLoading) {
              return _loadingAnimationCircular();
            }
            if (state is TransactionListLoaded) {
              return StreamBuilder(
                stream: state.transactionList,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.length <= 0) {
                      return const Center(
                        child: Text("There is no data to show",
                            style: TextStyle(
                                color: Constants.grayColor,
                                fontSize: 16.0,
                                fontStyle: FontStyle.italic)),
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          return TransactionListRow(
                            transactionId: snapshot.data.docs[index].id,
                            agreementId: snapshot.data.docs[index]
                                ['agreement_id'],
                            influencerId: snapshot.data.docs[index]
                                ['influencer_id'],
                            negotiationId: snapshot.data.docs[index]
                                ['negotiation_id'],
                            transactionStatus: snapshot.data.docs[index]
                                ['transaction_status'],
                          );
                        },
                      );
                    }
                  }
                  return _loadingAnimationCircular();
                },
              );
            }
            return Container();
          },
        ));
  }

  Widget _loadingAnimationCircular() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

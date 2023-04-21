import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/transaction/bloc/transaction_bloc.dart';
import 'package:fluence_for_influencer/transaction/pages/transaction_detail_page.dart';
import 'package:fluence_for_influencer/transaction/repository/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
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
              return const CircularProgressIndicator();
            }
            if (state is TransactionListLoaded) {
              return StreamBuilder(
                stream: state.transactionList,
                builder: (context, snapshot) {
                  return snapshot.hasData
                      ? ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                nextScreen(
                                    context, const TransactionDetailPage());
                              },
                              child: ListTile(
                                title: Text(
                                    snapshot.data.docs[index]['influencer_id']),
                                subtitle: Text(
                                    snapshot.data.docs[index]['influencer_id']),
                              ),
                            );
                          },
                        )
                      : Container();
                },
              );
            }
            return Container();
          },
        ));
  }
}

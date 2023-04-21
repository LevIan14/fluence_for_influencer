import 'package:equatable/equatable.dart';
import 'package:fluence_for_influencer/transaction/repository/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'transaction_event.dart';
part 'transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository transactionRepository;

  TransactionBloc({required this.transactionRepository})
      : super(TransactionInitial()) {
    on<GetTransactionDetail>((event, emit) async {
      try {
        emit(TransactionLoading());
        final dynamic transaction = await transactionRepository
            .getTransactionDetail(event.transactionId);
        emit(TransactionLoaded(transaction));
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });

    on<GetTransactionList>((event, emit) async {
      try {
        emit(TransactionLoading());
        final Stream<dynamic> transactionList =
            await transactionRepository.getTransactionList(event.influencerId);
        emit(TransactionListLoaded(transactionList));
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });

    on<CreateNewTransaction>((event, emit) async {
      try {
        await transactionRepository.createNewTransaction(event.newTransaction);
        emit(CreateNewTransactionSuccess());
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });
  }
}

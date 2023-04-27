import 'package:equatable/equatable.dart';
import 'package:fluence_for_influencer/transaction/model/order_transaction.dart';
import 'package:fluence_for_influencer/transaction/model/order_transaction_progress.dart';
import 'package:fluence_for_influencer/transaction/repository/transaction_repository.dart';
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
        final OrderTransaction transaction = await transactionRepository
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
        emit(TransactionProcessSuccess());
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });

    on<UpdateStatusContentProgress>((event, emit) async {
      try {
        await transactionRepository.updateStatusContentProgress(
            event.transactionId,
            event.influencerNote,
            event.status,
            event.orderTransactionProgress);
        emit(TransactionProcessSuccess());
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });

    on<SaveNotesContentProgress>((event, emit) async {
      try {
        await transactionRepository.saveNotesContentProgress(
            event.transactionId,
            event.influencerNote,
            event.orderTransactionProgress);
        emit(TransactionProcessSuccess());
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });

    on<UpdateStatusUploadProgress>((event, emit) async {
      try {
        await transactionRepository.updateStatusUploadProgress(
            event.transactionId,
            event.influencerNote,
            event.status,
            event.orderTransactionProgress);
        emit(TransactionProcessSuccess());
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });

    on<SaveNotesUploadProgress>((event, emit) async {
      try {
        await transactionRepository.saveNotesUploadProgress(event.transactionId,
            event.influencerNote, event.orderTransactionProgress);
        emit(TransactionProcessSuccess());
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });
  }
}

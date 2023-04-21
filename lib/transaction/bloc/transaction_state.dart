part of 'transaction_bloc.dart';

abstract class TransactionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final dynamic transaction;

  TransactionLoaded(this.transaction);

  @override
  List<Object> get props => [transaction];
}

class TransactionListLoaded extends TransactionState {
  final Stream<dynamic> transactionList;

  TransactionListLoaded(this.transactionList);

  @override
  List<Object> get props => [transactionList];
}

class CreateNewTransactionSuccess extends TransactionState {}

class TransactionError extends TransactionState {
  final String error;

  TransactionError(this.error);

  @override
  List<Object?> get props => [error];
}

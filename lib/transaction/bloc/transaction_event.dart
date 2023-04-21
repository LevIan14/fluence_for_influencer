part of 'transaction_bloc.dart';

abstract class TransactionEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetTransactionDetail extends TransactionEvent {
  final String transactionId;

  GetTransactionDetail(this.transactionId);

  @override
  List<Object> get props => [transactionId];
}

class GetTransactionList extends TransactionEvent {
  final String influencerId;

  GetTransactionList(this.influencerId);

  @override
  List<Object> get props => [influencerId];
}

class CreateNewTransaction extends TransactionEvent {
  final dynamic newTransaction;

  CreateNewTransaction(this.newTransaction);

  @override
  List<Object> get props => [newTransaction];
}

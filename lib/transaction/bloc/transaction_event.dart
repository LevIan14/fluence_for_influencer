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

class UpdateStatusContentProgress extends TransactionEvent {
  final String transactionId;
  final String influencerNote;
  final String status;
  final OrderTransactionProgress orderTransactionProgress;

  UpdateStatusContentProgress(this.transactionId, this.influencerNote,
      this.status, this.orderTransactionProgress);

  @override
  List<Object> get props =>
      [transactionId, influencerNote, status, orderTransactionProgress];
}

class SaveNotesContentProgress extends TransactionEvent {
  final String transactionId;
  final String influencerNote;
  final OrderTransactionProgress orderTransactionProgress;

  SaveNotesContentProgress(
      this.transactionId, this.influencerNote, this.orderTransactionProgress);

  @override
  List<Object> get props =>
      [transactionId, influencerNote, orderTransactionProgress];
}

class UpdateStatusUploadProgress extends TransactionEvent {
  final String transactionId;
  final String influencerNote;
  final String status;
  final OrderTransactionProgress orderTransactionProgress;

  UpdateStatusUploadProgress(this.transactionId, this.influencerNote,
      this.status, this.orderTransactionProgress);

  @override
  List<Object> get props =>
      [transactionId, influencerNote, status, orderTransactionProgress];
}

class SaveNotesUploadProgress extends TransactionEvent {
  final String transactionId;
  final String influencerNote;
  final OrderTransactionProgress orderTransactionProgress;

  SaveNotesUploadProgress(
      this.transactionId, this.influencerNote, this.orderTransactionProgress);

  @override
  List<Object> get props =>
      [transactionId, influencerNote, orderTransactionProgress];
}

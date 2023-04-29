import 'package:fluence_for_influencer/transaction/model/order_transaction_progress.dart';

class OrderTransaction {
  final String id;
  final String influencerId;
  final String umkmId;
  final String agreementId;
  final String negotiationId;
  final String reviewId;
  final String transactionStatus;
  final OrderTransactionProgress orderProgress;
  final DateTime createdAt;

  OrderTransaction(
      this.id,
      this.influencerId,
      this.umkmId,
      this.agreementId,
      this.negotiationId,
      this.reviewId,
      this.transactionStatus,
      this.orderProgress,
      this.createdAt);
}

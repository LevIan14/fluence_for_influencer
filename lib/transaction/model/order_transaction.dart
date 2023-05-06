import 'package:fluence_for_influencer/transaction/model/order_transaction_progress.dart';

class OrderTransaction {
  final String id;
  final String orderId;
  final String influencerId;
  final String umkmId;
  final String agreementId;
  final String negotiationId;
  final String reviewId;
  final String transactionStatus;
  final String cancelReason;
  final OrderTransactionProgress orderProgress;
  final DateTime createdAt;

  OrderTransaction(
      this.id,
      this.orderId,
      this.influencerId,
      this.umkmId,
      this.agreementId,
      this.negotiationId,
      this.reviewId,
      this.transactionStatus,
      this.cancelReason,
      this.orderProgress,
      this.createdAt);
}

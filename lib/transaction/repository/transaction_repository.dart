import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/transaction/bloc/transaction_bloc.dart';
import 'package:fluence_for_influencer/transaction/model/order_transaction.dart';
import 'package:fluence_for_influencer/transaction/model/order_transaction_progress.dart';
import 'package:fluence_for_influencer/transaction/model/progress/content_progress.dart';
import 'package:fluence_for_influencer/transaction/model/progress/review_content.dart';
import 'package:fluence_for_influencer/transaction/model/progress/review_upload.dart';
import 'package:fluence_for_influencer/transaction/model/progress/upload_progress.dart';

class TransactionRepository {
  Future<dynamic> getTransactionDetail(String transactionId) async {
    try {
      DocumentSnapshot snapshot = await Constants.firebaseFirestore
          .collection("transactions")
          .doc(transactionId)
          .get();

      if (snapshot.exists) {
        ContentProgress contentProgress = ContentProgress(
            snapshot.get("progress")['content_progress']['status'],
            snapshot.get("progress")['content_progress']['influencer_note']);

        ReviewContent reviewContent = ReviewContent(
          snapshot.get("progress")['review_content']['status'],
          snapshot.get("progress")['review_content']['influencer_note'],
          snapshot.get("progress")['review_content']['umkm_note'],
        );

        UploadProgress uploadProgress = UploadProgress(
            snapshot.get("progress")['upload_progress']['status'],
            snapshot.get("progress")['upload_progress']['influencer_note']);

        ReviewUpload reviewUpload = ReviewUpload(
          snapshot.get("progress")['review_upload']['status'],
          snapshot.get("progress")['review_content']['influencer_note'],
          snapshot.get("progress")['review_content']['umkm_note'],
        );

        OrderTransactionProgress orderTransactionProgress =
            OrderTransactionProgress(
                contentProgress, reviewContent, uploadProgress, reviewUpload);

        OrderTransaction orderTransaction = OrderTransaction(
            snapshot.id,
            snapshot.get("influencer_id"),
            snapshot.get("umkm_id"),
            snapshot.get("agreement_id"),
            snapshot.get("negotiation_id"),
            snapshot.get("review_id"),
            snapshot.get("transaction_status"),
            orderTransactionProgress);

        return orderTransaction;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> getTransactionList(String influencerId) async {
    try {
      return Constants.firebaseFirestore
          .collection("transactions")
          .where("influencer_id", isEqualTo: influencerId)
          .snapshots();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> createNewTransaction(dynamic newTransaction) async {
    try {
      await Constants.firebaseFirestore
          .collection("transactions")
          .add(newTransaction);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateStatusContentProgress(
      String transactionId,
      String influencerNote,
      String status,
      OrderTransactionProgress orderTransactionProgress) async {
    try {
      await Constants.firebaseFirestore
          .collection("transactions")
          .doc(transactionId)
          .update({
        "progress": {
          "content_progress": {
            "influencer_note": influencerNote,
            "status": status
          },
          "review_content": {
            "status": orderTransactionProgress.reviewContent.status,
            "influencer_note":
                orderTransactionProgress.reviewContent.influencerNote,
            "umkm_note": orderTransactionProgress.reviewContent.umkmNote,
          },
          "upload_progress": {
            "influencer_note":
                orderTransactionProgress.uploadProgress.influencerNote,
            "status": orderTransactionProgress.uploadProgress.status
          },
          "review_upload": {
            "status": orderTransactionProgress.reviewUpload.status,
            "influencer_note":
                orderTransactionProgress.reviewUpload.influencerNote,
            "umkm_note": orderTransactionProgress.reviewUpload.umkmNote,
          },
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveNotesContentProgress(
      String transactionId,
      String influencerNote,
      OrderTransactionProgress orderTransactionProgress) async {
    try {
      await Constants.firebaseFirestore
          .collection("transactions")
          .doc(transactionId)
          .update({
        "progress": {
          "content_progress": {
            "influencer_note": influencerNote,
            "status": orderTransactionProgress.contentProgress.status
          },
          "review_content": {
            "status": orderTransactionProgress.reviewContent.status,
            "influencer_note":
                orderTransactionProgress.reviewContent.influencerNote,
            "umkm_note": orderTransactionProgress.reviewContent.umkmNote,
          },
          "upload_progress": {
            "influencer_note":
                orderTransactionProgress.uploadProgress.influencerNote,
            "status": orderTransactionProgress.uploadProgress.status
          },
          "review_upload": {
            "status": orderTransactionProgress.reviewUpload.status,
            "influencer_note":
                orderTransactionProgress.reviewUpload.influencerNote,
            "umkm_note": orderTransactionProgress.reviewUpload.umkmNote,
          },
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateStatusUploadProgress(
      String transactionId,
      String influencerNote,
      String status,
      OrderTransactionProgress orderTransactionProgress) async {
    try {
      await Constants.firebaseFirestore
          .collection("transactions")
          .doc(transactionId)
          .update({
        "progress": {
          "content_progress": {
            "influencer_note":
                orderTransactionProgress.contentProgress.influencerNote,
            "status": orderTransactionProgress.contentProgress.status
          },
          "review_content": {
            "status": orderTransactionProgress.reviewContent.status,
            "influencer_note":
                orderTransactionProgress.reviewContent.influencerNote,
            "umkm_note": orderTransactionProgress.reviewContent.umkmNote,
          },
          "upload_progress": {
            "influencer_note": influencerNote,
            "status": status
          },
          "review_upload": {
            "status": orderTransactionProgress.reviewUpload.status,
            "influencer_note":
                orderTransactionProgress.reviewUpload.influencerNote,
            "umkm_note": orderTransactionProgress.reviewUpload.umkmNote,
          },
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveNotesUploadProgress(
      String transactionId,
      String influencerNote,
      OrderTransactionProgress orderTransactionProgress) async {
    try {
      await Constants.firebaseFirestore
          .collection("transactions")
          .doc(transactionId)
          .update({
        "progress": {
          "content_progress": {
            "influencer_note":
                orderTransactionProgress.contentProgress.influencerNote,
            "status": orderTransactionProgress.contentProgress.status
          },
          "review_content": {
            "status": orderTransactionProgress.reviewContent.status,
            "influencer_note":
                orderTransactionProgress.reviewContent.influencerNote,
            "umkm_note": orderTransactionProgress.reviewContent.umkmNote,
          },
          "upload_progress": {
            "influencer_note": influencerNote,
            "status": orderTransactionProgress.uploadProgress.status
          },
          "review_upload": {
            "status": orderTransactionProgress.reviewUpload.status,
            "influencer_note":
                orderTransactionProgress.reviewUpload.influencerNote,
            "umkm_note": orderTransactionProgress.reviewUpload.umkmNote,
          },
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

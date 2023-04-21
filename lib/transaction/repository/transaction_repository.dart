import 'package:fluence_for_influencer/shared/constants.dart';

class TransactionRepository {
  Future<dynamic> getTransactionDetail(String transactionId) async {
    try {
      return await Constants.firebaseFirestore
          .collection("transactions")
          .doc(transactionId)
          .get();
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
}

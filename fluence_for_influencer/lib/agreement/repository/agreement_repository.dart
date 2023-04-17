import 'package:fluence_for_influencer/shared/constants.dart';

class AgreementRepository {
  Future<dynamic> getAgreementList(String influencerId) async {
    try {
      return Constants.firebaseFirestore
          .collection("agreements")
          .where("influencer_id", isEqualTo: influencerId)
          .snapshots();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> getAgreementDetail(String agreementId) async {
    try {
      return await Constants.firebaseFirestore
          .collection("agreements")
          .doc(agreementId)
          .get();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> createNewAgreement(newAgreement) async {
    try {
      await Constants.firebaseFirestore
          .collection("agreements")
          .add(newAgreement);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluence_for_influencer/agreement/model/agreement.dart';
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
      DocumentSnapshot snapshot = await Constants.firebaseFirestore
          .collection("agreements")
          .doc(agreementId)
          .get();

      if (snapshot.exists) {
        Timestamp createdAt = snapshot.get('created_at');
        Agreement agreement = Agreement(
            snapshot.id,
            snapshot.get('influencer_id'),
            snapshot.get('umkm_id'),
            snapshot.get('negotiation_id'),
            snapshot.get('umkm_agreement'),
            snapshot.get('umkm_agreement_status'),
            snapshot.get('influencer_agreement'),
            snapshot.get('influencer_agreement_status'),
            createdAt.toDate());
        return agreement;
      }
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

  Future<void> acceptAgreement(String agreementId) async {
    try {
      await Constants.firebaseFirestore
          .collection("agreements")
          .doc(agreementId)
          .update({"umkm_agreement_status": "ACCEPTED"});
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> needRevisionAgreement(String agreementId) async {
    try {
      await Constants.firebaseFirestore
          .collection("agreements")
          .doc(agreementId)
          .update({"umkm_agreement_status": "ACCEPTED"});
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateInfluencerAgreement(
      String agreementId, String influencerAgreement) async {
    try {
      await Constants.firebaseFirestore
          .collection("agreements")
          .doc(agreementId)
          .update({
        "influencer_agreement": influencerAgreement,
        "influencer_agreement_status": "ON REVIEW",
        "agreement_status": "ON PROCESS"
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> saveNoteInfluencerAgreement(
      String agreementId, String influencerAgreement) async {
    try {
      await Constants.firebaseFirestore
          .collection("agreements")
          .doc(agreementId)
          .update({
        "influencer_agreement": influencerAgreement,
      });
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

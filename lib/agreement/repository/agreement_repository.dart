import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluence_for_influencer/agreement/model/agreement.dart';
import 'package:fluence_for_influencer/shared/constants.dart';

class AgreementRepository {
  Future<dynamic> getAgreementList(String influencerId) async {
    try {
      return Constants.firebaseFirestore
          .collection("agreements")
          .where("influencer_id", isEqualTo: influencerId)
          .orderBy('created_at', descending: true)
          .snapshots();
    } catch (e) {
      throw Exception(Constants.genericErrorException);
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
            snapshot.get('umkm_agreement_draft'),
            snapshot.get('umkm_agreement_status'),
            snapshot.get('influencer_agreement'),
            snapshot.get('influencer_agreement_draft'),
            snapshot.get('influencer_agreement_status'),
            snapshot.get('agreement_status'),
            createdAt.toDate());
        return agreement;
      }
    } catch (e) {
      throw Exception(Constants.genericErrorException);
    }
  }

  Future<void> createNewAgreement(newAgreement) async {
    try {
      await Constants.firebaseFirestore
          .collection("agreements")
          .add(newAgreement);
    } catch (e) {
      throw Exception(Constants.genericErrorException);
    }
  }

  Future<void> acceptAgreement(String agreementId) async {
    try {
      await Constants.firebaseFirestore
          .collection("agreements")
          .doc(agreementId)
          .update({"umkm_agreement_status": "ACCEPTED"});

      DocumentSnapshot snapshot = await Constants.firebaseFirestore
          .collection("agreements")
          .doc(agreementId)
          .get();

      if (snapshot.get('umkm_agreement_status') == 'ACCEPTED' &&
          snapshot.get('influencer_agreement_status') == 'ACCEPTED') {
        await Constants.firebaseFirestore
            .collection("agreements")
            .doc(agreementId)
            .update({"agreement_status": "DONE"});
      }
    } catch (e) {
      throw Exception(Constants.genericErrorException);
    }
  }

  Future<void> needRevisionAgreement(String agreementId) async {
    try {
      await Constants.firebaseFirestore
          .collection("agreements")
          .doc(agreementId)
          .update({"umkm_agreement_status": "NEED REVISION"});
    } catch (e) {
      throw Exception(Constants.genericErrorException);
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
        "influencer_agreement_draft": influencerAgreement,
        "influencer_agreement_status": "ON REVIEW",
        "agreement_status": "ON PROCESS"
      });
    } catch (e) {
      throw Exception(Constants.genericErrorException);
    }
  }

  Future<void> saveNoteInfluencerAgreement(
      String agreementId, String influencerAgreement) async {
    try {
      await Constants.firebaseFirestore
          .collection("agreements")
          .doc(agreementId)
          .update({
        "influencer_agreement_draft": influencerAgreement,
      });
    } catch (e) {
      throw Exception(Constants.genericErrorException);
    }
  }
}

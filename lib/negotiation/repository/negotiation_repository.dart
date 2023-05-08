import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluence_for_influencer/negotiation/model/negotiation.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/util/custom_exception.dart';

class NegotiationRepository {
  Future<dynamic> getNegotiationDetail(String negotiationId) async {
    try {
      var negotiationSnapshot = await Constants.firebaseFirestore
          .collection("negotiation")
          .doc(negotiationId)
          .get();

      if (negotiationSnapshot.exists) {
        Timestamp start = negotiationSnapshot.get('project_duration')['start'];
        Timestamp end = negotiationSnapshot.get('project_duration')['end'];

        final Map<String, DateTime> projectDuration = {
          "start": start.toDate(),
          "end": end.toDate(),
        };

        Negotiation data = Negotiation(
            negotiationSnapshot.id,
            negotiationSnapshot.get('influencer_id'),
            negotiationSnapshot.get('umkm_id'),
            negotiationSnapshot.get('project_title'),
            negotiationSnapshot.get('project_description'),
            double.parse(negotiationSnapshot.get('project_price').toString()),
            projectDuration,
            negotiationSnapshot.get("negotiation_status"));
        return data;
      }
    } catch (e) {
      throw CustomException(e.toString());
    }
    return null;
  }

  Future<void> acceptNegotiation(String negotiationId) async {
    try {
      await Constants.firebaseFirestore
          .collection("negotiation")
          .doc(negotiationId)
          .update({"negotiation_status": "DONE"});
    } catch (e) {
      throw CustomException(e.toString());
    }
  }

  Future<void> rejectNegotiation(String negotiationId) async {
    try {
      await Constants.firebaseFirestore
          .collection("negotiation")
          .doc(negotiationId)
          .update({"negotiation_status": "REJECTED"});
    } catch (e) {
      throw CustomException(e.toString());
    }
  }
}

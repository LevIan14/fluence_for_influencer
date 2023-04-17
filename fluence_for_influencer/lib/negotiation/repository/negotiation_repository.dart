import 'package:fluence_for_influencer/negotiation/model/Negotiation.dart';
import 'package:fluence_for_influencer/shared/constants.dart';

class NegotiationRepository {
  Future<dynamic> getNegotiationDetail(String negotiationId) async {
    try {
      var negotiationSnapshot = await Constants.firebaseFirestore
          .collection("negotiation")
          .doc(negotiationId)
          .get();

      if (negotiationSnapshot.exists) {
        Negotiation data = Negotiation(
            negotiationSnapshot.id,
            negotiationSnapshot.data()!['project_title'],
            negotiationSnapshot.data()!['project_description'],
            negotiationSnapshot.data()!['amount'],
            negotiationSnapshot.data()!['range_date'],
            negotiationSnapshot.data()!['influencer_id'],
            negotiationSnapshot.data()!['umkm_id']);
        return data;
      }
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }
}

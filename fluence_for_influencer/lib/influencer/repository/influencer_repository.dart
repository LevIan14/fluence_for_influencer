import 'package:fluence_for_influencer/shared/constants.dart';

class InfluencerRepository {
  Future<dynamic> getInfluencerDetail(String userId) async {
    try {
      return await Constants.firebaseFirestore
          .collection("influencers")
          .doc(userId)
          .get();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

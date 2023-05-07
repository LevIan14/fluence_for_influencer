import 'package:fluence_for_influencer/shared/constants.dart';

class ChatRepository {
  Future<dynamic> getChatList() async {
    try {
      return Constants.firebaseFirestore
          .collection("chats")
          .where("influencer_id",
              isEqualTo: Constants.firebaseAuth.currentUser!.uid)
          .orderBy("updated_at", descending: true)
          .snapshots();
    } catch (e) {
      throw Exception(Constants.genericErrorException);
    }
  }
}

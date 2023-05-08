import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/util/custom_exception.dart';

class MessageRepository {
  Future<dynamic> getMessageList(String chatId) async {
    try {
      return Constants.firebaseFirestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .orderBy("created_at", descending: false)
          .snapshots();
    } catch (e) {
      throw CustomException(e.toString());
    }
  }

  Future<void> sendMessage(String chatId, String message) async {
    try {
      Timestamp timestamp = Timestamp.now();
      await Constants.firebaseFirestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .add({
        "message": message,
        "created_at": timestamp,
        "sender_id": Constants.firebaseAuth.currentUser!.uid
      });

      // Update Recent Message & Updated Time
      await Constants.firebaseFirestore
          .collection("chats")
          .doc(chatId)
          .update({"recent_message": message, "updated_at": timestamp});
    } catch (e) {
      throw CustomException(e.toString());
    }
  }

  Future<dynamic> sendNewNegotiation(String chatId, String senderId,
      String negotiationId, String message) async {
    try {
      Timestamp timestamp = Timestamp.now();
      await Constants.firebaseFirestore
          .collection("chats")
          .doc(chatId)
          .collection("messages")
          .add({
        "message": message,
        "created_at": timestamp,
        "sender_id": senderId,
        "negotiation_id": negotiationId
      });

      await Constants.firebaseFirestore
          .collection("chats")
          .doc(chatId)
          .update({"recent_message": message, "updated_at": timestamp});
    } catch (e) {
      throw CustomException(e.toString());
    }
  }
}

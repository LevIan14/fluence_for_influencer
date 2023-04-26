import 'package:fluence_for_influencer/shared/constants.dart';

class UmkmRepository {
  Future<dynamic> getUmkmDetail(String umkmId) async {
    try {
      return await Constants.firebaseFirestore
          .collection("umkm")
          .doc(umkmId)
          .get();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

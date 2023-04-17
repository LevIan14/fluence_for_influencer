import 'package:fluence_for_influencer/shared/constants.dart';

class UmkmRepository {
  Future<dynamic> getUmkmName(String umkmId) async {
    try {
      return await Constants.firebaseFirestore
          .collection("umkm")
          .doc(umkmId)
          .get()
          .then((value) => value["name"]);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}

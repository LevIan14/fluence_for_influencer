import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/util/custom_exception.dart';
import 'package:fluence_for_influencer/umkm/model/umkm.dart';

class UmkmRepository {
  Future<Umkm> getUmkmDetail(String umkmId) async {
    late Umkm u;
    try {
      await Constants.firebaseFirestore
          .collection("umkm")
          .doc(umkmId)
          .get()
          .then((value) {
        u = Umkm.fromJson(value.id, value.data()!);
      });
    } catch (e) {
      throw CustomException(e.toString());
    }
    return u;
  }
}

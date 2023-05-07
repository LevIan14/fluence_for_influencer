import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluence_for_influencer/models/category_type.dart';
import 'package:fluence_for_influencer/shared/constants.dart';

class CategoryRepository {
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<List<CategoryType>> getCategoryTypeList() async {
    List<CategoryType> categoryList = [];
    try {
      await firebaseFirestore.collection("category_types").get().then((value) {
        for (var v in value.docs) {
          CategoryType categoryType = CategoryType.fromJson(v.id, v.data());
          categoryList.add(categoryType);
        }
      });
    } catch (e) {
      throw Exception(Constants.genericErrorException);
    }
    return categoryList;
  }
}

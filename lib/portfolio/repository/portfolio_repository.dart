
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluence_for_influencer/models/portfolio.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:image_picker/image_picker.dart';

class PortfolioRepository {

  Future<List<Portfolio>> getInfluencerPortfolioList(String influencerId) async {
    List<Portfolio> portfolioList = [];
    try {
      await Constants.firebaseFirestore
          .collection("influencers")
          .doc(influencerId)
          .collection("portfolio")
          .orderBy('uploaded_at', descending: true)
          .get()
          .then((value) {
        for (var v in value.docs) {
          Portfolio portfolio = Portfolio.fromJson(v.id, v.data());
          portfolioList.add(portfolio);
        }
      });
    } catch (e) {
      throw Exception(e.toString());
    }
    return portfolioList;
  }

  Future<void> uploadInfluencerPortfolio(String influencerId, XFile img, String caption) async {
    try {
      String finalImagePath = 'influencers/$influencerId/portfolio/${img.name}';
      File file = File(img.path);
      final storageRef = Constants.firebaseStorage.ref();
      final fileRef = storageRef
          .child(finalImagePath); // defining image path in firebase storage
      UploadTask uploadTask = fileRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      try {
        Timestamp now = Timestamp.now();
        await Constants.firebaseFirestore
            .collection("influencers")
            .doc(influencerId)
            .collection("portfolio")
            .add({
          'image_url': downloadURL,
          'caption': caption,
          'uploaded_at': now,
        });
      } catch (e) {
        throw Exception(e.toString());
      }
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
    return;
  }

  Future<void> editInfluencerPortfolio(String influencerId, Portfolio updatedPortfolio) async {
    // late Portfolio ;
    try {
      await Constants.firebaseFirestore
        .collection("influencers")
        .doc(influencerId)
        .collection("portfolio")
        .doc(updatedPortfolio.portfolioId)
        .update({
          'caption': updatedPortfolio.caption,
        });
      // await getInfluencerPortfolio(influencerId, portfolio.portfolioId);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> deleteInfluencerPortfolio(String influencerId, Portfolio portfolio) async {
    try {
      final storageRef = FirebaseStorage.instance;
      final imageRef = storageRef.refFromURL(portfolio.imageUrl);
      imageRef.delete();
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      try {
        await Constants.firebaseFirestore
        .collection('influencers')
        .doc(influencerId)
        .collection('portfolio')
        .doc(portfolio.portfolioId)
        .delete();
      } catch (e) {
        throw Exception(e.toString());
      } finally {
        List<Portfolio> portfolioList = await getInfluencerPortfolioList(influencerId);
        // kalo hrs return nnt di return
      }
    }

  }

}

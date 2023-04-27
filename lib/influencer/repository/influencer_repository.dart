import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluence_for_influencer/models/category_type.dart';
import 'package:fluence_for_influencer/models/influencer.dart';
import 'package:fluence_for_influencer/models/portfolio.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/category/repository/category_repository.dart';
import 'package:image_picker/image_picker.dart';

class InfluencerRepository {

  Future<Influencer> getInfluencerDetail(String influencerId) async {
    late final Influencer i;
    try {
      await Constants.firebaseFirestore
          .collection("influencers")
          .doc(influencerId)
          .get()
          .then((value) {
        i = Influencer.fromJson(value.id, value.data()!);
      });
    } catch (e) {
      throw Exception(e.toString());
    }
    return i;
  }

  
  Future<String> updateInfluencerAvatar(String influencerId, String avatarUrl, XFile img) async {
    try {
      final avatarRef = Constants.firebaseStorage.refFromURL(avatarUrl);
      avatarRef.delete();
    } catch (e) {
      throw Exception(e.toString());
    }
    String finalImagePath = 'influencers/$influencerId/${img.name}';
    File file = File(img.path);
    try {
      final storageRef = Constants.firebaseStorage.ref();
      final fileRef = storageRef
          .child(finalImagePath); // defining image path in firebase storage
      UploadTask uploadTask = fileRef.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      String downloadURL = await snapshot.ref.getDownloadURL();
      await Constants.firebaseFirestore
          .collection('influencers')
          .doc(influencerId)
          .update({'avatar_url': downloadURL});
      return downloadURL;
    } on FirebaseException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateInfluencerProfileSettings(Influencer influencer, XFile? img) async {
    if(img != null){
      try {
        await updateInfluencerAvatar(influencer.userId, influencer.avatarUrl, img);
      } catch (e) {
        throw Exception(e.toString());
      }
    } 
    try {
      List<String> categoryTypeId = [];
      for(CategoryType category in influencer.categoryType) { 
        categoryTypeId.add(category.categoryTypeId);
      }
      await Constants.firebaseFirestore
        .collection('influencers')
        .doc(influencer.userId)
        .update({
          'about': influencer.about,
          'category_type_id': categoryTypeId,
          'fullname': influencer.fullname,
          'gender': influencer.gender,
          'location': influencer.location,
          'note_agreement': influencer.noteAgreement,
        });
    } catch (e) {
      throw Exception(e.toString());
    }
    return;
  }



  Future<Influencer> getInfluencerInsight(Influencer influencer) async {
    log('${influencer.userId} with instagram id: ${influencer.instagramUserId}');
    int followersCount = 0;
    int previousImpressions = 0;
    int fourWeekImpressions = 0;
    int previousReach = 0;
    int fourWeekReach = 0;
    List<String> topAudienceCity = [];
    try {
      try {
        HttpClientResponse response = await getUserFromAPI(
            influencer.instagramUserId!, influencer.facebookAccessToken!);
        String resp = await response.transform(utf8.decoder).join();
        Map<String, dynamic> res = jsonDecode(resp);
        followersCount = res["followers_count"];
      } catch (e) {
        throw Exception(e.toString());
      }
      try {
        HttpClientResponse response = await getAudienceFromAPI(
            influencer.instagramUserId!, influencer.facebookAccessToken!);
        String resp = await response.transform(utf8.decoder).join();
        Map<String, dynamic> res = jsonDecode(resp);
        Map<String, dynamic> data = res["data"].first;
        Map<String, dynamic> values = data["values"].first;
        Map<String, dynamic> audienceCity = values["value"];
        List<Map<String, dynamic>> toBeSorted = [];
        audienceCity.forEach((key, value) {
          toBeSorted.add({'city': key, 'value': value});
        });
        toBeSorted.sort((a, b) => b['value'].compareTo(a['value']));
        for (int i = 0; i < 5; i++) {
          topAudienceCity.add(toBeSorted[i]['city']);
        }
      } catch (e) {
        throw Exception(e.toString());
      }
      try {
        HttpClientResponse response = await getInsightFromAPI(
            influencer.instagramUserId!, influencer.facebookAccessToken!);
        String resp = await response.transform(utf8.decoder).join();
        Map<String, dynamic> res = jsonDecode(resp);
        List<dynamic> data = res["data"];
        final Map<String, dynamic> impressions = data.first;
        List<dynamic> impressionsValue = impressions["values"];
        previousImpressions = impressionsValue.first["value"];
        fourWeekImpressions = impressionsValue.last["value"];
        final Map<String, dynamic> reach = data.last;
        List<dynamic> reachValue = reach["values"];
        previousReach = reachValue.first["value"];
        fourWeekReach = reachValue.last["value"];
      } catch (e) {
        throw Exception(e.toString());
      }
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      influencer.followersCount = followersCount;
      influencer.topAudienceCity = topAudienceCity;
      influencer.previousImpressions = previousImpressions;
      influencer.fourWeekImpressions = fourWeekImpressions;
      influencer.previousReach = previousReach;
      influencer.fourWeekReach = fourWeekReach;
    }
    return influencer;
  }

  Future<HttpClientResponse> getUserFromAPI(
      String instagramUserId, String facebookAccessToken) async {
    final HttpClient httpClient = HttpClient();
    Map<String, String> queryParameters = {
      'fields': 'followers_count',
      'access_token': facebookAccessToken,
    };
    HttpClientResponse response;
    try {
      HttpClientRequest request = await httpClient.getUrl(Uri.https(
          'graph.facebook.com', '/v16.0/$instagramUserId', queryParameters));
      response = await request.close();
    } catch (e) {
      throw Exception(e);
    } finally {
      httpClient.close();
    }
    return response;
  }

  Future<HttpClientResponse> getAudienceFromAPI(
      String instagramUserId, String facebookAccessToken) async {
    final HttpClient httpClient = HttpClient();
    Map<String, String> queryParameters = {
      'metric': 'audience_city',
      'period': 'lifetime',
      'access_token': facebookAccessToken,
    };
    HttpClientResponse response;
    try {
      HttpClientRequest request = await httpClient.getUrl(Uri.https(
          'graph.facebook.com',
          '/v16.0/$instagramUserId/insights',
          queryParameters));
      response = await request.close();
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      httpClient.close();
    }
    return response;
  }

  Future<HttpClientResponse> getInsightFromAPI(
      String instagramUserId, String facebookAccessToken) async {
    final HttpClient httpClient = HttpClient();
    DateTime now = DateTime.now();
    DateTime fourWeeksAgo = now.subtract(const Duration(days: 28));
    int since = fourWeeksAgo.toUtc().millisecondsSinceEpoch ~/ 1000;
    int until = now.toUtc().millisecondsSinceEpoch ~/ 1000;
    Map<String, String> queryParameters = {
      'metric': 'impressions,reach',
      'period': 'days_28',
      'access_token': facebookAccessToken,
      'since': '$since',
      'until': '$until',
    };
    log('since: $since, until: $until');
    HttpClientResponse response;
    try {
      HttpClientRequest request = await httpClient.getUrl(Uri.https(
          'graph.facebook.com',
          '/v16.0/$instagramUserId/insights',
          queryParameters));
      response = await request.close();
    } catch (e) {
      throw Exception(e);
    } finally {
      httpClient.close();
    }
    return response;
  }
}

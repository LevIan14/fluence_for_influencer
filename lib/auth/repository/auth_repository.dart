import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final storage = const FlutterSecureStorage();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = (await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password));
      await storage.write(key: "KEY_UID", value: userCredential.user?.uid);
      await storage.write(key: "KEY_EMAIL", value: userCredential.user?.email);
      await storage.write(
          key: "KEY_NAME", value: userCredential.user?.displayName);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> registerUserWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final dataInfluencer = {"category_type_id": "123", "name": "levi"};

      firebaseFirestore
          .collection("influencers")
          .doc(userCredential.user?.uid)
          .set(dataInfluencer);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      storage.write(key: "KEY_UID", value: userCredential.user?.uid);
      storage.write(key: "KEY_EMAIL", value: userCredential.user?.email);
      storage.write(key: "KEY_NAME", value: userCredential.user?.displayName);
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Map<String, dynamic>?> connectToFacebook(String influencerId) async {
    List<String> permissionsList = const [
      'email',
      'instagram_basic',
      'instagram_manage_insights',
      'pages_read_engagement',
      'pages_show_list'
    ];
    try {
      final LoginResult result =
          await FacebookAuth.instance.login(permissions: permissionsList);
      if (result.status == LoginStatus.success) {
        final AuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        log("successfully logged in to facebook!");
        final String facebookAccessToken = result.accessToken!.token;
        final String facebookUserId = result.accessToken!.userId;
        try {
          HttpClientResponse response =
              await getLongLivedUserAccessToken(facebookAccessToken);
          String resp = await response
              .transform(utf8.decoder)
              .join(); // returns access_token, token_type, expires_in
          Map<String, dynamic> res = jsonDecode(resp);
          final String longLivedUserAccessToken = res["access_token"];
          try {
            HttpClientResponse response = await getLongLivedPageAccessToken(
                facebookUserId, longLivedUserAccessToken);
            String resp = await response.transform(utf8.decoder).join();
            Map<String, dynamic> res = jsonDecode(resp);
            List<dynamic> data = res["data"];
            final Map<String, dynamic> first = data.first;
            final String longLivedPageAccessToken = first["access_token"];
            final String facebookPageId = first["id"];
            try {
              HttpClientResponse response = await getInstagramBusinessUserId(
                  facebookPageId, longLivedUserAccessToken);
              String resp = await response.transform(utf8.decoder).join();
              Map<String, dynamic> res = jsonDecode(resp);
              final String instagramUserId =
                  res["instagram_business_account"]["id"];
              // connectingInfluencerWithFacebook(
              //     influencerId, longLivedUserAccessToken, instagramUserId);
              return {'id': influencerId, 'facebook_access_token': longLivedUserAccessToken, 'instagram_user_id': instagramUserId};
            } catch (e) {
              log(e.toString());
            } finally {}
          } catch (e) {
            log(e.toString());
          }
        } catch (e) {
          log(e.toString());
        }
      } else
        log('error!');
    } catch (e) {
      throw Exception(e.toString());
    }
    return null;
  }

  Future<HttpClientResponse> getLongLivedUserAccessToken(
      String facebookAccessToken) async {
    final HttpClient httpClient = HttpClient();
    const String appId = "748827173013593";
    const String appSecret = "c5db0e16112891e6bdb198f9a5026810";
    Map<String, String> queryParameters = {
      'grant_type': 'fb_exchange_token',
      'client_id': appId,
      'client_secret': appSecret,
      'fb_exchange_token': facebookAccessToken,
    };
    HttpClientResponse response;
    try {
      HttpClientRequest request = await httpClient.getUrl(Uri.https(
          'graph.facebook.com', '/v16.0/oauth/access_token', queryParameters));
      response = await request.close();
    } catch (e) {
      throw Exception(e);
    } finally {
      httpClient.close();
    }
    return response;
  }

  Future<HttpClientResponse> getLongLivedPageAccessToken(
      String facebookUserId, String longLivedUserAccessToken) async {
    final HttpClient httpClient = HttpClient();
    Map<String, String> queryParameters = {
      'access_token': longLivedUserAccessToken,
    };
    HttpClientResponse response;
    try {
      HttpClientRequest request = await httpClient.getUrl(Uri.https(
          'graph.facebook.com',
          '/v16.0/$facebookUserId/accounts',
          queryParameters));
      response = await request.close();
    } catch (e) {
      throw Exception(e);
    } finally {
      httpClient.close();
    }
    return response;
  }

  Future<HttpClientResponse> getInstagramBusinessUserId(
      String facebookPageId, String longLivedUserAccessToken) async {
    final HttpClient httpClient = HttpClient();
    Map<String, String> queryParameters = {
      'fields': 'instagram_business_account',
      'access_token': longLivedUserAccessToken,
    };
    HttpClientResponse response;
    try {
      HttpClientRequest request = await httpClient.getUrl(Uri.https(
          'graph.facebook.com', '/v16.0/$facebookPageId', queryParameters));
      response = await request.close();
    } catch (e) {
      throw Exception(e);
    } finally {
      httpClient.close();
    }
    return response;
  }

  // Future<void> connectingInfluencerWithFacebook(String influencerId,
  //     String longLivedUserAccessToken, String instagramUserId) async {
  //   try {
  //     firebaseFirestore.collection('influencers').doc(influencerId).update({
  //       'facebook_access_token': longLivedUserAccessToken,
  //       'instagram_user_id': instagramUserId,
  //     });
  //   } catch (e) {
  //     throw Exception('Facebook connection failed!');
  //   }
  // }

  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
      await storage.deleteAll();
    } catch (e) {
      throw Exception(e);
    }
  }
}

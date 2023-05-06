import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepository {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  Future<void> loginWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      UserCredential userCredential = (await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password));

      DocumentSnapshot snapshot = await Constants.firebaseFirestore
          .collection('influencers')
          .doc(userCredential.user!.uid)
          .get();

      if (snapshot.exists) {
        return;
      } else {
        throw FirebaseAuthException(code: 'user-not-found');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Pengguna tidak ditemukan');
      } else if (e.code == 'wrong-password') {
        throw Exception('Password salah');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> checkIsUserLoggedIn() async {
    try {
      User? user = Constants.firebaseAuth.currentUser;
      if (user == null) {
        return false;
      } else {
        DocumentSnapshot snapshot = await Constants.firebaseFirestore
            .collection('influencers')
            .doc(user.uid)
            .get();
        if (snapshot.exists) {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> checkEmailIsUsed(String email) async {
    try {
      final list =
          await Constants.firebaseAuth.fetchSignInMethodsForEmail(email);
      if (list.isNotEmpty) {
        throw FirebaseAuthException(code: 'email-already-in-use');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('Email telah digunakan');
      }
    } catch (e) {
      throw Exception(Constants.genericErrorException);
    }
  }

  Future<void> changePassword(String oldPassword, String newPassword) async {
    try {
      await Constants.firebaseAuth.signInWithEmailAndPassword(
          email: Constants.firebaseAuth.currentUser!.email!,
          password: oldPassword);
      await Constants.firebaseAuth.currentUser!.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('Pengguna tidak ditemukan');
      } else if (e.code == 'wrong-password') {
        throw Exception('Password salah');
      } else if (e.code == 'too-many-request') {
        throw Exception(Constants.genericErrorException);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      return Constants.firebaseAuth.currentUser!.sendEmailVerification();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<bool> checkIsEmailVerified() async {
    try {
      return Constants.firebaseAuth.currentUser!.emailVerified;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> registerUserWithEmailAndPassword(
      String email,
      String password,
      String fullname,
      String bankAccount,
      String bankAccountName,
      String bankAccountNumber,
      String gender,
      String location,
      List<String> categoryList,
      String customCategory) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final dataInfluencer = {
        "avatar_url":
            "https://firebasestorage.googleapis.com/v0/b/fluence-1673609236730.appspot.com/o/dummy-profile-pic.png?alt=media&token=23db1237-3e40-4643-8af0-e63e1583e8ab",
        "fullname": fullname,
        "category_type_id": categoryList,
        "custom_category": customCategory,
        "note_agreement": "",
        "about": "",
        "email": email,
        "location": location,
        "bank_account": bankAccount,
        "bank_account_name": bankAccountName,
        "bank_account_number": bankAccountNumber,
        "gender": gender
      };

      firebaseFirestore
          .collection("influencers")
          .doc(userCredential.user?.uid)
          .set(dataInfluencer);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Password terlalu lemah');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Email telah digunakan oleh pengguna lain');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<dynamic> loginWithGoogle() async {
    try {
      Map<String, dynamic> userUmkm = {};
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      DocumentSnapshot snapshot = await Constants.firebaseFirestore
          .collection("umkm")
          .doc(userCredential.user!.uid)
          .get();

      if (snapshot.exists) {
        userUmkm = {
          "fullname": snapshot.get("fullname"),
          "email": snapshot.get("email"),
          "id": snapshot.id,
          "exist": true
        };
      } else {
        userUmkm = {
          "fullname": userCredential.user!.displayName,
          "email": userCredential.user!.email,
          "id": userCredential.user!.uid,
          "exist": false
        };
      }
      return userUmkm;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> registerUserWithGoogleLogin(
      String email,
      String fullname,
      String bankAccount,
      String bankAccountName,
      String bankAccountNumber,
      String gender,
      String location,
      List<String> categoryList,
      String customCategory,
      String id) async {
    try {
      final dataUmkm = {
        "avatar_url":
            "https://firebasestorage.googleapis.com/v0/b/fluence-1673609236730.appspot.com/o/dummy-profile-pic.png?alt=media&token=23db1237-3e40-4643-8af0-e63e1583e8ab",
        "fullname": fullname,
        "location": location,
        "category_type_id": categoryList,
        "custom_category": customCategory,
        "note_agreement": "",
        "about": "",
        "email": email,
        "bank_account": bankAccount,
        "bank_account_name": bankAccountName,
        "bank_account_number": bankAccountNumber,
        "gender": gender
      };

      await firebaseFirestore.collection("umkm").doc(id).set(dataUmkm);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Exception('Password terlalu lemah');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('Email telah digunakan oleh pengguna lain');
      }
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
              return {
                'id': influencerId,
                'facebook_access_token': longLivedUserAccessToken,
                'instagram_user_id': instagramUserId
              };
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

  Future<void> forgotPassword(String email) async {
    try {
      await Constants.firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(Constants.genericErrorException);
    }
  }

  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      throw Exception(e);
    }
  }
}

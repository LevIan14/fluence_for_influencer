import 'dart:developer';

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

  Future<void> loginWithFacebook() async {
    List<String> permissionsList = const [
      'instagram_basic',
      'instagram_manage_insights'
    ];
    try {
      final LoginResult result =
          await FacebookAuth.instance.login(permissions: permissionsList);
      if (result.status == LoginStatus.success) {
        // log(result.toString());
        final AuthCredential facebookCredential =
            FacebookAuthProvider.credential(result.accessToken!.token);
        await firebaseAuth.signInWithCredential(facebookCredential);
      }
    } on FirebaseAuthException catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> logout() async {
    try {
      await firebaseAuth.signOut();
      await storage.deleteAll();
    } catch (e) {
      throw Exception(e);
    }
  }
}

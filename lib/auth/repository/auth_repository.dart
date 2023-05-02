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
        throw Exception('No user found for that email');
      } else if (e.code == 'wrong-password') {
        throw Exception('Wrong password provided for that user');
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

  Future<void> registerUserWithEmailAndPassword(String email, String password,
      String fullname, String location, List<String> categoryList) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final dataInfluencer = {
        "avatar_url":
            "https://firebasestorage.googleapis.com/v0/b/fluence-1673609236730.appspot.com/o/dummy-profile-pic.png?alt=media&token=23db1237-3e40-4643-8af0-e63e1583e8ab",
        "fullname": fullname,
        "category_type_id": categoryList,
        "note_agreement": "",
        "about": "",
        "email": email,
        "location": location,
      };

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

  Future<void> registerUserWithGoogleLogin(String email, String fullname,
      String location, List<String> categoryList, String id) async {
    try {
      final dataUmkm = {
        "avatar_url":
            "https://firebasestorage.googleapis.com/v0/b/fluence-1673609236730.appspot.com/o/dummy-profile-pic.png?alt=media&token=23db1237-3e40-4643-8af0-e63e1583e8ab",
        "fullname": fullname,
        "location": location,
        "category_type_id": categoryList,
        "note_agreement": "",
        "about": "",
        "email": email,
      };

      await firebaseFirestore.collection("umkm").doc(id).set(dataUmkm);
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

  Future<void> forgotPassword(String email) async {
    try {
      await Constants.firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw Exception(e.toString());
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

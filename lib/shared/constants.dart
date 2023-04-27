import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Constants {
  static const primaryColor = Color(0xFFA20021);
  static const secondaryColor = Color.fromARGB(90, 250, 206, 216);
  static const grayColor = Color.fromRGBO(177, 177, 177, 1);
  static const navyColor = Color.fromRGBO(18, 44, 52, 1);
  static const creamColor = Color.fromRGBO(245, 243, 187, 1);
  // static const backgroundColor = Color.fromRGBO(253, 240, 242, 0.247);
  static const backgroundColor = Color.fromRGBO(253, 240, 242, 0.74);

  static const defaultPadding = 20.0;

  static const defaultPaddingIcon =
      EdgeInsets.symmetric(horizontal: 1.0, vertical: 1.0);
  static const defaultPaddingButton =
      EdgeInsets.symmetric(horizontal: 21.0, vertical: 16.0);
  static final defaultBorderRadiusButton = BorderRadius.circular(15);

  static FlutterSecureStorage storage = const FlutterSecureStorage();
  static String? uid = "";
  static FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  static FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static FirebaseStorage firebaseStorage = FirebaseStorage.instance;
}

import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  filled: true,
  fillColor: Constants.secondaryColor,
  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  labelStyle: TextStyle(color: Colors.black),
  // Enabled and focused
  focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Constants.secondaryColor, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(20))),
  // Enabled and not showing error
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Constants.secondaryColor, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(20))),
  // Has error but not focus
  errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Constants.primaryColor, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(20))),
  // Has error and focus
  focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Constants.primaryColor, width: 1),
      borderRadius: BorderRadius.all(Radius.circular(20))),
);

// const inputDecorationTheme = InputDecorationTheme(
//   contentPadding: EdgeInsets.all(16),
//   isDense: true,

// );


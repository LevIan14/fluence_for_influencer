import 'package:fluence_for_influencer/shared/constants.dart';

class CustomException implements Exception {
  final dynamic message;

  CustomException([this.message]);

  @override
  String toString() {
    String? message = this.message;
    if (message == null) return Constants.genericErrorException;
    return message;
  }
}

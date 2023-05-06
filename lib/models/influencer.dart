import 'dart:convert';
import 'dart:developer';
import 'review.dart';
import 'package:fluence_for_influencer/models/category_type.dart';
import 'package:fluence_for_influencer/models/portfolio.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(includeIfNull: false)
class Influencer {
  final String userId;
  final String email;
  String? password;

  String avatarUrl;
  String fullname;
  String? gender;
  String location;
  String about;
  String? noteAgreement;
  num? lowestFee;
  num? highestFee;

  late String? facebookAccessToken;
  late String? instagramUserId;

  late int? followersCount;
  late List<String>? topAudienceCity;
  late int? fourWeekReach;
  late int? previousReach;
  late int? fourWeekImpressions;
  late int? previousImpressions;

  late List<dynamic> categoryType;
  late String customCategory;
  late List<Portfolio>? portfolio;
  late List<Review>? review;

  String bankAccount;
  String bankAccountName;
  String bankAccountNumber;

  Influencer(
      this.userId,
      this.portfolio,
      this.categoryType,
      this.customCategory,
      this.review,
      this.fullname,
      this.gender,
      this.email,
      this.password,
      this.noteAgreement,
      this.location,
      this.avatarUrl,
      this.about,
      this.lowestFee,
      this.highestFee,
      this.facebookAccessToken,
      this.instagramUserId,
      this.followersCount,
      this.topAudienceCity,
      this.fourWeekReach,
      this.previousReach,
      this.fourWeekImpressions,
      this.previousImpressions,
      this.bankAccount,
      this.bankAccountName,
      this.bankAccountNumber);

  factory Influencer.fromJson(String userId, Map<String, dynamic> json) {
    return Influencer(
        userId,
        json['portfolio'],
        json['category_type_id'],
        json['custom_category'],
        json['reviews'],
        json['fullname'],
        json['gender'],
        json['email'],
        json['password'],
        json['note_agreement'],
        json['location'],
        json['avatar_url'],
        json['about'],
        json['lowest_fee'],
        json['highest_fee'],
        json['facebook_access_token'] ?? "",
        json['instagram_user_id'] ?? "",
        json['followers_count'],
        json['top_audience_city'],
        json['four_week_reach'],
        json['previous_reach'],
        json['four_week_impressions'],
        json['previous_impressions'],
        json['bank_account'],
        json['bank_account_name'],
        json['bank_account_number']);
  }
}

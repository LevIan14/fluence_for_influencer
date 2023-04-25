import 'dart:convert';
import 'dart:developer';

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

  late String? facebookAccessToken;
  late String? instagramUserId;

  late int? followersCount;
  late List<String>? topAudienceCity;
  late int? fourWeekReach;
  late int? previousReach;
  late int? fourWeekImpressions;
  late int? previousImpressions;

  late List<dynamic> categoryType;
  late List<Portfolio>? portfolio;

  Influencer(this.userId, this.portfolio, this.categoryType, this.fullname, this.gender, this.email, this.password, this.noteAgreement, this.location, this.avatarUrl, this.about,
    this.facebookAccessToken, this.instagramUserId, this.followersCount, this.topAudienceCity, this.fourWeekReach, this.previousReach, this.fourWeekImpressions, this.previousImpressions);

  factory Influencer.fromJson(String userId, Map<String, dynamic> json) {
    return Influencer(userId, json['portfolio'], json['category_type_id'], json['fullname'], json['gender'], json['email'], json['password'], json['note_agreement'], json['location'], json['avatar_url'], json['about'],
      json['facebook_access_token'], json['instagram_user_id'], json['followers_count'], json['top_audience_city'], json['four_week_reach'], json['previous_reach'], json['four_week_impressions'], json['previous_impressions']);
  }



}
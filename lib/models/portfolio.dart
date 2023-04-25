import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
@JsonSerializable(includeIfNull: false)
class Portfolio {
  final String portfolioId;
  final String imageUrl;
  final String? caption;
  final Timestamp uploadedAt;

  Portfolio(this.portfolioId, this.imageUrl, this.caption, this.uploadedAt);

  factory Portfolio.fromJson(String portfolioId, Map<String, dynamic> json){
    return Portfolio(portfolioId, json['image_url'], json['caption'], json['uploaded_at']);
  }
}
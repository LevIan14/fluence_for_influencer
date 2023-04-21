import 'dart:developer';

import 'package:json_annotation/json_annotation.dart';
@JsonSerializable(includeIfNull: false)
class Portfolio {
  final String portfolioId;
  final String imageUrl;
  final String? caption;

  Portfolio(this.portfolioId, this.imageUrl, this.caption);

  factory Portfolio.fromJson(String portfolioId, Map<String, dynamic> json){
    log('masuk porto');
    return Portfolio(portfolioId, json['image_url'], json['caption']);
  }
}
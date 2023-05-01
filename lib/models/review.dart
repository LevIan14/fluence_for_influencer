class Review {
  final String reviewId;
  final String? transactionId;
  final String? umkmId;
  final num rating;
  final String? review;


  Review(this.reviewId, this.transactionId, this.umkmId, this.rating, this.review);

  factory Review.fromJson(String id, Map<String, dynamic> json){
    return Review(id, json['transaction_id'], json['umkm_id'], json['rating'], json['review']);
  }
}
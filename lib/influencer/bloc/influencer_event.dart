part of 'influencer_bloc.dart';

abstract class InfluencerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetInfluencerDetail extends InfluencerEvent {
  final String influencerId;

  GetInfluencerDetail(this.influencerId);

  @override
  List<Object> get props => [influencerId];
}

// class UploadInfluencerProfileImage extends InfluencerEvent {
//   final String influencerId;
//   final XFile img;
//   UploadInfluencerProfileImage(this.influencerId, this.img);

//   @override
//   List<Object> get props => [influencerId, img];
// }

class UpdateInfluencerProfileSettings extends InfluencerEvent {
  final Influencer influencer;
  final XFile? img;
  UpdateInfluencerProfileSettings(this.influencer, this.img);

  @override
  List<Object> get props => [influencer];
}

class GetInfluencerReviewOnCurrentTransaction extends InfluencerEvent {
  final String influencerId;
  final String reviewId;

  GetInfluencerReviewOnCurrentTransaction(this.influencerId, this.reviewId);
}

class InfluencerFacebookAccess extends InfluencerEvent {
  final String influencerId;
  final String longLivedUserAccessToken;
  final String instagramUserId;

  InfluencerFacebookAccess(this.influencerId, this.longLivedUserAccessToken, this.instagramUserId);
}


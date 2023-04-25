part of 'influencer_bloc.dart';

abstract class InfluencerEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetInfluencerDetail extends InfluencerEvent {
  final String userId;

  GetInfluencerDetail(this.userId);

  @override
  List<Object> get props => [userId];
}

class UploadInfluencerPortfolio extends InfluencerEvent {
  final String influencerId;
  final XFile img;
  final String caption;

  UploadInfluencerPortfolio(this.influencerId, this.img, this.caption);

  @override
  List<Object> get props => [influencerId, img, caption];
}

class UploadInfluencerProfileImage extends InfluencerEvent {
  final String influencerId;
  final XFile img;
  UploadInfluencerProfileImage(this.influencerId, this.img);

  @override
  List<Object> get props => [influencerId];
}
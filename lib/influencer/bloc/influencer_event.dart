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

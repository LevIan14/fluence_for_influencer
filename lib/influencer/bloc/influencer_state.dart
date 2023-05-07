part of 'influencer_bloc.dart';

abstract class InfluencerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InfluencerInitial extends InfluencerState {}

class InfluencerLoading extends InfluencerState {}

class UpdateInfluencerProfileSuccess extends InfluencerState {}

class InfluencerLoaded extends InfluencerState {
  final Influencer influencer;

  InfluencerLoaded(this.influencer);

  @override
  List<Object> get props => [influencer];
}

class InfluencerError extends InfluencerState {
  final String error;

  InfluencerError(this.error);

  @override
  List<Object?> get props => [error];
}

class InfluencerProfileImageUploaded extends InfluencerState {
  final String profileImageURL;
  InfluencerProfileImageUploaded(this.profileImageURL);

  @override
  List<Object?> get props => [profileImageURL];
}

class GetInfluencerReviewOnCurrentTransactionSuccess extends InfluencerState {
  final dynamic review;

  GetInfluencerReviewOnCurrentTransactionSuccess(this.review);

  @override
  List<Object?> get props => [review];
}

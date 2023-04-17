part of 'influencer_bloc.dart';

abstract class InfluencerState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InfluencerInitial extends InfluencerState {}

class InfluencerLoading extends InfluencerState {}

class InfluencerLoaded extends InfluencerState {
  final dynamic influencer;

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

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

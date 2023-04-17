part of 'negotiation_bloc.dart';

abstract class NegotiationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetNegotiationDetail extends NegotiationEvent {
  final String negotiationId;

  GetNegotiationDetail(this.negotiationId);

  @override
  List<Object> get props => [negotiationId];
}

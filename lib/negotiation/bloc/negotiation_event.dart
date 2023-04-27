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

class CreateNewNegotiation extends NegotiationEvent {
  final String projectTitle;
  final String projectDesc;
  final String projectPrice;
  final Map<String, DateTime> projectDuration;
  final String influencerId;
  final String umkmId;

  CreateNewNegotiation(this.projectTitle, this.projectDesc, this.projectPrice,
      this.projectDuration, this.influencerId, this.umkmId);

  @override
  List<Object> get props => [
        projectTitle,
        projectDesc,
        projectPrice,
        projectDuration,
        influencerId,
        umkmId
      ];
}

class UpdateNegotiation extends NegotiationEvent {
  final Negotiation negotiation;

  UpdateNegotiation(this.negotiation);

  @override
  List<Object> get props => [negotiation];
}

class AcceptNegotiation extends NegotiationEvent {
  final String negotiationId;

  AcceptNegotiation(this.negotiationId);

  @override
  List<Object> get props => [negotiationId];
}

class RejectNegotiation extends NegotiationEvent {
  final String negotiationId;

  RejectNegotiation(this.negotiationId);

  @override
  List<Object> get props => [negotiationId];
}

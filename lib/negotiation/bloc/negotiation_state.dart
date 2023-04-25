part of 'negotiation_bloc.dart';

abstract class NegotiationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NegotiationInitial extends NegotiationState {}

class NegotiationLoading extends NegotiationState {}

class NegotiationLoaded extends NegotiationState {
  final Negotiation negotiationDetails;

  NegotiationLoaded(this.negotiationDetails);

  @override
  List<Object?> get props => [negotiationDetails];
}

class UpdateNegotiationSuccess extends NegotiationState {}

class AcceptNegotiationSuccess extends NegotiationState {}

class RejectNegotiationSuccess extends NegotiationState {}

class NegotiationError extends NegotiationState {
  final String error;

  NegotiationError(this.error);

  @override
  List<Object?> get props => [error];
}

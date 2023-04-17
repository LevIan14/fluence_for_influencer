import 'package:equatable/equatable.dart';
import 'package:fluence_for_influencer/negotiation/model/Negotiation.dart';
import 'package:fluence_for_influencer/negotiation/repository/negotiation_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'negotiation_event.dart';
part 'negotiation_state.dart';

class NegotiationBloc extends Bloc<NegotiationEvent, NegotiationState> {
  final NegotiationRepository negotiationRepository;

  NegotiationBloc({required this.negotiationRepository})
      : super(NegotiationInitial()) {
    on<GetNegotiationDetail>((event, emit) async {
      try {
        emit(NegotiationLoading());
        Negotiation negotiationDetail = await negotiationRepository
            .getNegotiationDetail(event.negotiationId);
        emit(NegotiationLoaded(negotiationDetail));
      } catch (e) {
        emit(NegotiationError(e.toString()));
      }
    });
  }
}

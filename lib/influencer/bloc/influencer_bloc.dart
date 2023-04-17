import 'package:equatable/equatable.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'influencer_event.dart';
part 'influencer_state.dart';

class InfluencerBloc extends Bloc<InfluencerEvent, InfluencerState> {
  final InfluencerRepository influencerRepository;

  InfluencerBloc({required this.influencerRepository})
      : super(InfluencerInitial()) {
    on<GetInfluencerDetail>((event, emit) async {
      try {
        emit(InfluencerLoading());
        final influencer =
            await influencerRepository.getInfluencerDetail(event.userId);
        emit(InfluencerLoaded(influencer));
      } catch (e) {
        emit(InfluencerError(e.toString()));
      }
    });
  }
}

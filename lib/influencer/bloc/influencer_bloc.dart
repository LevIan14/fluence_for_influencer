import 'package:equatable/equatable.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/models/influencer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'influencer_event.dart';
part 'influencer_state.dart';

class InfluencerBloc extends Bloc<InfluencerEvent, InfluencerState> {
  final InfluencerRepository influencerRepository;

  InfluencerBloc({required this.influencerRepository})
      : super(InfluencerInitial()) {
    on<GetInfluencerDetail>((event, emit) async {
      try {
        emit(InfluencerLoading());
        Influencer influencer =
            await influencerRepository.getInfluencerDetail(event.userId);
        if (influencer.instagramUserId!.isNotEmpty &&
            influencer.facebookAccessToken!.isNotEmpty) {
          influencer =
              await influencerRepository.getInfluencerInsight(influencer);
        }

        emit(InfluencerLoaded(influencer));
      } catch (e) {
        emit(InfluencerError(e.toString()));
      }
    });
    on<UploadInfluencerPortfolio>((event, emit) async {
      try {
        emit(InfluencerLoading());
        await influencerRepository.uploadInfluencerPortfolio(
            event.influencerId, event.img, event.caption);
        emit(InfluencerPortfolioUploaded());
      } catch (e) {
        emit(InfluencerError(e.toString()));
      }
    });
    on<UploadInfluencerProfileImage>((event, emit) async {
      try {
        emit(InfluencerLoading());
        var profileImageURL = await influencerRepository.uploadInfluencerImage(
            event.influencerId, event.img);
        emit(InfluencerProfileImageUploaded(profileImageURL));
      } catch (e) {
        emit(InfluencerError(e.toString()));
      }
    });
    on<UpdateInfluencerProfileSettings>((event, emit) async {
      try {
        emit(InfluencerLoading());
      } catch (e) {
        emit(InfluencerError(e.toString()));
      }
    });
  }
}

import 'package:equatable/equatable.dart';
import 'package:fluence_for_influencer/category/repository/category_repository.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/models/category_type.dart';
import 'package:fluence_for_influencer/models/influencer.dart';
import 'package:fluence_for_influencer/models/portfolio.dart';
import 'package:fluence_for_influencer/portfolio/repository/portfolio_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'influencer_event.dart';
part 'influencer_state.dart';

class InfluencerBloc extends Bloc<InfluencerEvent, InfluencerState> {

  final InfluencerRepository influencerRepository;
  final CategoryRepository categoryRepository;

  InfluencerBloc({required this.influencerRepository, required this.categoryRepository})
      : super(InfluencerInitial()) {
    on<GetInfluencerDetail>((event, emit) async {
      try {
        emit(InfluencerLoading());
        late Influencer influencer;
        influencer = await influencerRepository.getInfluencerDetail(event.influencerId);
        List<CategoryType> categoryTypeList = await categoryRepository.getCategoryTypeList();
        List<CategoryType> influencerCategoryList = [];
        for(var category in influencer.categoryType) {
          CategoryType element = categoryTypeList
          .firstWhere((element) => element.categoryTypeId == category);
          influencerCategoryList.add(element);
        }
        influencer.categoryType = influencerCategoryList;
        if (influencer.instagramUserId!.isNotEmpty &&
            influencer.facebookAccessToken!.isNotEmpty) {
          influencer = await influencerRepository.getInfluencerInsight(influencer);
        }
        emit(InfluencerLoaded(influencer));
      } catch (e) {
        emit(InfluencerError(e.toString()));
      }
    });
    on<UpdateInfluencerProfileSettings>((event, emit) async {
      try {
        emit(InfluencerLoading());
        await influencerRepository.updateInfluencerProfileSettings(event.influencer, event.img);
      } catch (e) {
        emit(InfluencerError(e.toString()));
      }
    });
    // on<UploadInfluencerProfileImage>((event, emit) async {
    //   try {
    //     emit(InfluencerLoading());
    //     var profileImageURL = await influencerRepository.uploadInfluencerImage(
    //         event.influencerId, event.img);
    //     emit(InfluencerProfileImageUploaded(profileImageURL));
    //   } catch (e) {
    //     emit(InfluencerError(e.toString()));
    //   }
    // });
  }
}

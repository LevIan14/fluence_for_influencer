import 'package:fluence_for_influencer/portfolio/repository/portfolio_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:fluence_for_influencer/influencer/bloc/influencer_bloc.dart';
import 'package:fluence_for_influencer/models/portfolio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

part 'portfolio_event.dart';
part 'portfolio_state.dart';

class PortfolioBloc extends Bloc<PortfolioEvent, PortfolioState> {
  final PortfolioRepository portfolioRepository;

  PortfolioBloc({required this.portfolioRepository}) : super(PortfolioInitial()) {
    on<GetInfluencerPortfolioList>((event, emit) async {
      try {
        emit(PortfolioLoading());
        List<Portfolio> portfolioList = await portfolioRepository.getInfluencerPortfolioList(event.influencerId);
        emit(InfluencerPortfoliosLoaded(portfolioList));
      } catch (e) {
        emit(PortfolioError(e.toString()));
      }
    });
    on<UploadInfluencerPortfolio>((event, emit) async {
      try {
        emit(PortfolioLoading());
        await portfolioRepository.uploadInfluencerPortfolio(
            event.influencerId, event.img, event.caption);
        emit(InfluencerPortfolioUploaded());
      } catch (e) {
        emit(PortfolioError(e.toString()));
      }
    });    
    on<DeleteInfluencerPortfolio>((event, emit) async {
      try {
        await portfolioRepository.deleteInfluencerPortfolio(event.influencerId, event.portfolio);
        emit(InfluencerPortfolioDeleted());
      } catch (e) {
        emit(PortfolioError(e.toString()));
      }
    });
    on<EditInfluencerPortfolio>((event, emit) async {
      try {
        await portfolioRepository.editInfluencerPortfolio(event.influencerId, event.editedPortfolio);
        emit(InfluencerPortfolioUpdated());
      } catch (e) {
        emit(PortfolioError(e.toString()));
      }
    });
  }
}
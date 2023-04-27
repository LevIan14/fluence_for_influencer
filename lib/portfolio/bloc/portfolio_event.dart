part of 'portfolio_bloc.dart';

abstract class PortfolioEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetInfluencerPortfolioList extends PortfolioEvent {
  final String influencerId;

  GetInfluencerPortfolioList(this.influencerId);

  @override
  List<Object> get props => [influencerId];
}

class UploadInfluencerPortfolio extends PortfolioEvent {
  final String influencerId;
  final XFile img;
  final String caption;

  UploadInfluencerPortfolio(this.influencerId, this.img, this.caption);

  @override
  List<Object> get props => [influencerId, img, caption];
}

class EditInfluencerPortfolio extends PortfolioEvent {
  final String influencerId;
  final Portfolio editedPortfolio;

  EditInfluencerPortfolio(this.influencerId, this.editedPortfolio);

  @override
  List<Object> get props => [influencerId, editedPortfolio];
}

class DeleteInfluencerPortfolio extends PortfolioEvent {
  final String influencerId;
  final Portfolio portfolio;
  DeleteInfluencerPortfolio(this.influencerId, this.portfolio);

  @override
  List<Object> get props => [influencerId, portfolio];
}
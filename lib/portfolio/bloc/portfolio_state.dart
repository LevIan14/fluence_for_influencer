part of 'portfolio_bloc.dart';

abstract class PortfolioState extends Equatable {
  @override
  List<Object?> get props => [];
}

class PortfolioInitial extends PortfolioState { }

class PortfolioLoading extends PortfolioState { }

class InfluencerPortfoliosLoaded extends PortfolioState {
  final List<Portfolio> portfolioList;

  InfluencerPortfoliosLoaded(this.portfolioList);
  
  @override
  List<Object> get props => [portfolioList];
}

class InfluencerPortfolioUploaded extends PortfolioState { }

class InfluencerPortfolioUpdated extends PortfolioState { }

class InfluencerPortfolioDeleted extends PortfolioState { }

class PortfolioError extends PortfolioState {
  final String error;

  PortfolioError(this.error);

  @override
  List<Object> get props => [error];
}

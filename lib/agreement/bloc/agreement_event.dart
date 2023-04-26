part of 'agreement_bloc.dart';

abstract class AgreementEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetAgreementDetail extends AgreementEvent {
  final String agreementId;

  GetAgreementDetail(this.agreementId);

  @override
  List<Object> get props => [agreementId];
}

class GetListAgreement extends AgreementEvent {
  final String influencerId;

  GetListAgreement(this.influencerId);

  @override
  List<Object> get props => [influencerId];
}

class CreateNewAgreement extends AgreementEvent {
  final dynamic newAgreement;

  CreateNewAgreement(this.newAgreement);

  @override
  List<Object> get props => [newAgreement];
}

class AcceptAgreement extends AgreementEvent {
  final String agreementId;

  AcceptAgreement(this.agreementId);

  @override
  List<Object> get props => [agreementId];
}

class UpdateInfluencerAgreement extends AgreementEvent {
  final String agreementId;
  final String influencerAgreement;

  UpdateInfluencerAgreement(this.agreementId, this.influencerAgreement);
}

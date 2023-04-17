part of 'agreement_bloc.dart';

abstract class AgreementState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AgreementInitial extends AgreementState {}

class AgreementLoading extends AgreementState {}

class AgreementLoaded extends AgreementState {
  final dynamic agreement;

  AgreementLoaded(this.agreement);

  @override
  List<Object> get props => [agreement];
}

class AgreementListLoaded extends AgreementState {
  final Stream<dynamic> agreementList;

  AgreementListLoaded(this.agreementList);

  @override
  List<Object> get props => [agreementList];
}

class CreateNewAgreementSuccess extends AgreementState {}

class AcceptAgreementSuccess extends AgreementState {}

class AgreementError extends AgreementState {
  final String error;

  AgreementError(this.error);

  @override
  List<Object?> get props => [error];
}

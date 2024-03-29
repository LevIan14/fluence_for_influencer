import 'package:equatable/equatable.dart';
import 'package:fluence_for_influencer/agreement/repository/agreement_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'agreement_event.dart';
part 'agreement_state.dart';

class AgreementBloc extends Bloc<AgreementEvent, AgreementState> {
  final AgreementRepository agreementRepository;

  AgreementBloc({required this.agreementRepository})
      : super(AgreementInitial()) {
    on<GetListAgreement>((event, emit) async {
      try {
        emit(AgreementLoading());
        final Stream<dynamic> agreementList =
            await agreementRepository.getAgreementList(event.influencerId);
        emit(AgreementListLoaded(agreementList));
      } catch (e) {
        emit(AgreementError(e.toString()));
      }
    });

    on<GetAgreementDetail>((event, emit) async {
      try {
        emit(AgreementLoading());
        final agreement =
            await agreementRepository.getAgreementDetail(event.agreementId);
        emit(AgreementLoaded(agreement));
      } catch (e) {
        emit(AgreementError(e.toString()));
      }
    });

    on<CreateNewAgreement>((event, emit) async {
      try {
        await agreementRepository.createNewAgreement(event.newAgreement);
        emit(CreateNewAgreementSuccess());
      } catch (e) {
        emit(AgreementError(e.toString()));
      }
    });
  }
}

import 'package:fluence_for_influencer/agreement/bloc/agreement_bloc.dart';
import 'package:fluence_for_influencer/agreement/pages/agreement_detail_page.dart';
import 'package:fluence_for_influencer/agreement/repository/agreement_repository.dart';
import 'package:fluence_for_influencer/agreement/widget/agreement_row.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgreementListPage extends StatefulWidget {
  const AgreementListPage({super.key});

  @override
  State<AgreementListPage> createState() => _AgreementListPageState();
}

class _AgreementListPageState extends State<AgreementListPage> {
  late final AgreementBloc agreementBloc;
  final AgreementRepository agreementRepository = AgreementRepository();

  @override
  void initState() {
    super.initState();
    agreementBloc = AgreementBloc(agreementRepository: agreementRepository);
    agreementBloc
        .add(GetListAgreement(Constants.firebaseAuth.currentUser!.uid));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => agreementBloc,
        child: BlocConsumer<AgreementBloc, AgreementState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is AgreementLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is AgreementListLoaded) {
                return StreamBuilder(
                  stream: state.agreementList,
                  builder: (context, AsyncSnapshot snapshot) {
                    return snapshot.hasData
                        ? ListView.builder(
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              return AgreementRow(
                                  influencerId: snapshot.data.docs[index]
                                      ['influencer_id'],
                                  agreementStatus: snapshot.data.docs[index]
                                      ['agreement_status'],
                                  agreementId: snapshot.data.docs[index].id,
                                  negotiationId: snapshot.data.docs[index]
                                      ['negotiation_id']);
                            })
                        : _loadingAnimationCircular();
                  },
                );
              }
              return Container();
            }));
  }

  Widget _loadingAnimationCircular() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}

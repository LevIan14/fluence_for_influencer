import 'package:fluence_for_influencer/agreement/pages/agreement_detail_page.dart';
import 'package:fluence_for_influencer/negotiation/bloc/negotiation_bloc.dart';
import 'package:fluence_for_influencer/negotiation/repository/negotiation_repository.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgreementRow extends StatefulWidget {
  final String agreementId;
  final String negotiationId;

  const AgreementRow(
      {Key? key, required this.agreementId, required this.negotiationId})
      : super(key: key);

  @override
  State<AgreementRow> createState() => _AgreementRowState();
}

class _AgreementRowState extends State<AgreementRow> {
  late final NegotiationBloc negotiationBloc;
  final NegotiationRepository negotiationRepository = NegotiationRepository();

  @override
  void initState() {
    super.initState();
    negotiationBloc =
        NegotiationBloc(negotiationRepository: negotiationRepository);
    negotiationBloc.add(GetNegotiationDetail(widget.negotiationId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => negotiationBloc,
      child: BlocConsumer<NegotiationBloc, NegotiationState>(
        listener: (context, state) {},
        builder: (context, state) {
          if (state is NegotiationLoaded) {
            return GestureDetector(
              onTap: () {
                nextScreen(
                    context,
                    AgreementDetailPage(
                      agreementId: widget.agreementId,
                      negotiationId: widget.negotiationId,
                    ));
              },
              child: ListTile(
                title: Text(state.negotiationDetails.projectTitle),
                subtitle: Text(state.negotiationDetails.projectDesc!,
                    overflow: TextOverflow.ellipsis),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

import 'package:fluence_for_influencer/agreement/pages/agreement_detail_page.dart';
import 'package:fluence_for_influencer/category/repository/category_repository.dart';
import 'package:fluence_for_influencer/influencer/bloc/influencer_bloc.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/models/influencer.dart';
import 'package:fluence_for_influencer/negotiation/bloc/negotiation_bloc.dart';
import 'package:fluence_for_influencer/negotiation/repository/negotiation_repository.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/util/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgreementRow extends StatefulWidget {
  final String agreementId;
  final String negotiationId;
  final String influencerId;
  final String agreementStatus;

  const AgreementRow(
      {Key? key,
      required this.agreementId,
      required this.negotiationId,
      required this.influencerId,
      required this.agreementStatus})
      : super(key: key);

  @override
  State<AgreementRow> createState() => _AgreementRowState();
}

class _AgreementRowState extends State<AgreementRow> {
  late final NegotiationBloc negotiationBloc;
  final NegotiationRepository negotiationRepository = NegotiationRepository();

  late final InfluencerBloc influencerBloc;
  final InfluencerRepository influencerRepository = InfluencerRepository();
  final CategoryRepository categoryRepository = CategoryRepository();

  Influencer? influencer;

  @override
  void initState() {
    super.initState();
    negotiationBloc =
        NegotiationBloc(negotiationRepository: negotiationRepository);
    influencerBloc = InfluencerBloc(
        influencerRepository: influencerRepository,
        categoryRepository: categoryRepository);

    influencerBloc.add(GetInfluencerDetail(widget.influencerId));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => negotiationBloc),
        BlocProvider(create: (context) => influencerBloc)
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<InfluencerBloc, InfluencerState>(
            listener: (context, state) {
              if (state is InfluencerLoaded) {
                influencer = state.influencer;
                negotiationBloc.add(GetNegotiationDetail(widget.negotiationId));
              }
            },
          ),
          BlocListener<NegotiationBloc, NegotiationState>(
            listener: (context, state) {},
          )
        ],
        child: BlocBuilder<NegotiationBloc, NegotiationState>(
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
                  subtitle: Text(
                    "${DateUtil.dateWithDayFormat(state.negotiationDetails.projectDuration['start']!)} - ${DateUtil.dateWithDayFormat(state.negotiationDetails.projectDuration['end']!)}",
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Chip(
                    label: Text(widget.agreementStatus),
                    backgroundColor: widget.agreementStatus == "DONE"
                        ? Colors.green[300]
                        : widget.agreementStatus == "ON PROCESS"
                            ? Colors.blue[300]
                            : Colors.yellow[300],
                    labelStyle: const TextStyle(fontSize: 10),
                  ),
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }
}

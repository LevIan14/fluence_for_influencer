import 'package:fluence_for_influencer/influencer/bloc/influencer_bloc.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/negotiation/bloc/negotiation_bloc.dart';
import 'package:fluence_for_influencer/negotiation/repository/negotiation_repository.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/util/date_utility.dart';
import 'package:fluence_for_influencer/transaction/pages/transaction_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionListRow extends StatefulWidget {
  final String transactionId;
  final String influencerId;
  final String negotiationId;
  final String transactionStatus;

  const TransactionListRow(
      {Key? key,
      required this.transactionId,
      required this.influencerId,
      required this.negotiationId,
      required this.transactionStatus})
      : super(key: key);

  @override
  State<TransactionListRow> createState() => _TransactionListRowState();
}

class _TransactionListRowState extends State<TransactionListRow> {
  late final NegotiationBloc negotiationBloc;
  final NegotiationRepository negotiationRepository = NegotiationRepository();

  late final InfluencerBloc influencerBloc;
  final InfluencerRepository influencerRepository = InfluencerRepository();

  String influencerName = "";

  @override
  void initState() {
    super.initState();
    influencerBloc = InfluencerBloc(influencerRepository: influencerRepository);
    influencerBloc.add(GetInfluencerDetail(widget.influencerId));

    negotiationBloc =
        NegotiationBloc(negotiationRepository: negotiationRepository);
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
            BlocListener<NegotiationBloc, NegotiationState>(
              listener: (context, state) {},
            ),
            BlocListener<InfluencerBloc, InfluencerState>(
              listener: (context, state) {
                if (state is InfluencerLoaded) {
                  influencerName = state.influencer.fullname;
                  negotiationBloc
                      .add(GetNegotiationDetail(widget.negotiationId));
                }
              },
            )
          ],
          child: BlocBuilder<NegotiationBloc, NegotiationState>(
              builder: (context, state) {
            if (state is NegotiationLoaded) {
              return GestureDetector(
                onTap: () {
                  nextScreen(
                      context,
                      TransactionDetailPage(
                          transactionId: widget.transactionId));
                },
                child: ListTile(
                  title: Text(state.negotiationDetails.projectTitle),
                  subtitle: Text(
                    "${DateUtil.dateWithDayFormat(state.negotiationDetails.projectDuration['start']!)} - ${DateUtil.dateWithDayFormat(state.negotiationDetails.projectDuration['end']!)}",
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(influencerName),
                ),
              );
            }
            return Container(
              child: Text(state.toString()),
            );
          }),
        ));
  }
}

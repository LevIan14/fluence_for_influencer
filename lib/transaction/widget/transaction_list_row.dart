import 'package:fluence_for_influencer/category/repository/category_repository.dart';
import 'package:fluence_for_influencer/influencer/bloc/influencer_bloc.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/negotiation/bloc/negotiation_bloc.dart';
import 'package:fluence_for_influencer/negotiation/repository/negotiation_repository.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/util/date_utility.dart';
import 'package:fluence_for_influencer/transaction/pages/transaction_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class TransactionListRow extends StatefulWidget {
  final String transactionId;
  final String influencerId;
  final String umkmId;
  final String negotiationId;
  final String transactionStatus;
  final String agreementId;

  const TransactionListRow(
      {Key? key,
      required this.transactionId,
      required this.influencerId,
      required this.umkmId,
      required this.negotiationId,
      required this.transactionStatus,
      required this.agreementId})
      : super(key: key);

  @override
  State<TransactionListRow> createState() => _TransactionListRowState();
}

class _TransactionListRowState extends State<TransactionListRow> {
  late final NegotiationBloc negotiationBloc;
  final NegotiationRepository negotiationRepository = NegotiationRepository();

  // late final InfluencerBloc influencerBloc;
  // final InfluencerRepository influencerRepository = InfluencerRepository();
  // final CategoryRepository categoryRepository = CategoryRepository();

  @override
  void initState() {
    super.initState();
    // influencerBloc = InfluencerBloc(
    //     influencerRepository: influencerRepository,
    //     categoryRepository: categoryRepository);
    // influencerBloc.add(GetInfluencerDetail(widget.influencerId));

    negotiationBloc =
        NegotiationBloc(negotiationRepository: negotiationRepository);
    negotiationBloc.add(GetNegotiationDetail(widget.negotiationId));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => negotiationBloc),
          // BlocProvider(create: (context) => influencerBloc)
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<NegotiationBloc, NegotiationState>(
              listener: (context, state) {},
            ),
            BlocListener<InfluencerBloc, InfluencerState>(
              listener: (context, state) {
                if (state is InfluencerLoaded) {
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
                          umkmId: widget.umkmId,
                          negotiationId: widget.negotiationId,
                          agreementId: widget.agreementId,
                          influencerId: widget.influencerId,
                          transactionId: widget.transactionId));
                },
                child: ListTile(
                  title: Text(
                    state.negotiationDetails.projectTitle,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    "${DateUtil.dateWithDayFormat(state.negotiationDetails.projectDuration['start']!)} - ${DateUtil.dateWithDayFormat(state.negotiationDetails.projectDuration['end']!)}",
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Chip(
                    labelStyle: const TextStyle(fontSize: 10),
                    label: Text(widget.transactionStatus),
                    backgroundColor: widget.transactionStatus == "DONE"
                        ? Colors.green[300]
                        : widget.transactionStatus == "PENDING"
                            ? Colors.yellow[300]
                            : widget.transactionStatus == 'CANCELED'
                                ? Colors.red[300]
                                : Colors.blue[300],
                  ),
                ),
              );
            }

            return const Center(
                child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ));
            // return Shimmer.fromColors(
            //   baseColor: Colors.grey[300]!,
            //   highlightColor: Colors.grey[100]!,
            //   child: ListView.builder(
            //     itemCount: 6,
            //     itemBuilder: (context, index) {
            //       return Card(
            //         elevation: 1.0,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(16),
            //         ),
            //         child: const SizedBox(height: 80),
            //       );
            //     },
            //   ),
            // );
          }),
        ));
  }
}

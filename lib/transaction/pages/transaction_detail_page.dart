import 'package:fluence_for_influencer/agreement/bloc/agreement_bloc.dart';
import 'package:fluence_for_influencer/agreement/model/agreement.dart';
import 'package:fluence_for_influencer/agreement/pages/influencer_agreement_page.dart';
import 'package:fluence_for_influencer/agreement/pages/umkm_agreement_page.dart';
import 'package:fluence_for_influencer/agreement/repository/agreement_repository.dart';
import 'package:fluence_for_influencer/category/repository/category_repository.dart';
import 'package:fluence_for_influencer/influencer/bloc/influencer_bloc.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/negotiation/bloc/negotiation_bloc.dart';
import 'package:fluence_for_influencer/negotiation/model/negotiation.dart';
import 'package:fluence_for_influencer/negotiation/pages/negotiation_detail_page.dart';
import 'package:fluence_for_influencer/negotiation/repository/negotiation_repository.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/util/currency_utility.dart';
import 'package:fluence_for_influencer/shared/util/date_utility.dart';
import 'package:fluence_for_influencer/transaction/bloc/transaction_bloc.dart';
import 'package:fluence_for_influencer/transaction/pages/reject_page.dart';
import 'package:fluence_for_influencer/transaction/pages/review/review_page.dart';
import 'package:fluence_for_influencer/transaction/pages/transaction_progress_page.dart';
import 'package:fluence_for_influencer/transaction/repository/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionDetailPage extends StatefulWidget {
  final String transactionId;
  final String negotiationId;
  final String agreementId;
  final String influencerId;
  final String umkmId;

  const TransactionDetailPage({
    Key? key,
    required this.transactionId,
    required this.negotiationId,
    required this.agreementId,
    required this.influencerId,
    required this.umkmId,
  }) : super(key: key);

  @override
  State<TransactionDetailPage> createState() => TransactionDetailPageState();
}

class TransactionDetailPageState extends State<TransactionDetailPage> {
  late final TransactionBloc transactionBloc;
  final TransactionRepository transactionRepository = TransactionRepository();

  late final NegotiationBloc negotiationBloc;
  final NegotiationRepository negotiationRepository = NegotiationRepository();

  late final AgreementBloc agreementBloc;
  final AgreementRepository agreementRepository = AgreementRepository();

  late final InfluencerBloc influencerBloc;
  final InfluencerRepository influencerRepository = InfluencerRepository();
  final CategoryRepository categoryRepository = CategoryRepository();

  late Negotiation negotiation;
  late Agreement agreement;
  late String influencerName;

  @override
  void initState() {
    super.initState();
    negotiationBloc =
        NegotiationBloc(negotiationRepository: negotiationRepository);
    negotiationBloc.add(GetNegotiationDetail(widget.negotiationId));

    agreementBloc = AgreementBloc(agreementRepository: agreementRepository);

    influencerBloc = InfluencerBloc(
        influencerRepository: influencerRepository,
        categoryRepository: categoryRepository);

    transactionBloc =
        TransactionBloc(transactionRepository: transactionRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => transactionBloc),
          BlocProvider(create: (context) => negotiationBloc),
          BlocProvider(create: (context) => agreementBloc),
          BlocProvider(create: (context) => influencerBloc)
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<NegotiationBloc, NegotiationState>(
              listener: (context, state) {
                if (state is NegotiationLoaded) {
                  negotiation = state.negotiationDetails;
                  agreementBloc.add(GetAgreementDetail(widget.agreementId));
                }
              },
            ),
            BlocListener<AgreementBloc, AgreementState>(
              listener: (context, state) {
                if (state is AgreementLoaded) {
                  agreement = state.agreement;
                  influencerBloc.add(GetInfluencerDetail(widget.influencerId));
                }
              },
            ),
            BlocListener<InfluencerBloc, InfluencerState>(
              listener: (context, state) {
                if (state is InfluencerLoaded) {
                  influencerName = state.influencer.fullname;
                  transactionBloc
                      .add(GetTransactionDetail(widget.transactionId));
                }
              },
            ),
          ],
          child: Scaffold(
            appBar: AppBar(
              title: const Text("Detail Transaksi"),
              backgroundColor: Constants.primaryColor,
            ),
            body: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
                if (state is TransactionLoaded) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(DateUtil.dateWithDayFormat(
                                  state.transaction.createdAt)),
                              Chip(
                                backgroundColor: state
                                            .transaction.transactionStatus ==
                                        'DONE'
                                    ? Colors.green[300]
                                    : state.transaction.transactionStatus ==
                                            'PENDING'
                                        ? Colors.yellow[300]
                                        : state.transaction.transactionStatus ==
                                                'CANCELED'
                                            ? Colors.red[300]
                                            : Colors.blue[300],
                                label: Text(state.transaction.transactionStatus,
                                    style: const TextStyle(fontSize: 10)),
                              )
                            ],
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 8),
                              child: const Divider()),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text("Informasi Negosiasi"),
                                      const SizedBox(height: 8),
                                      GestureDetector(
                                        onTap: () {
                                          nextScreen(
                                              context,
                                              NegotiationDetailPage(
                                                  umkmId: widget.umkmId,
                                                  negotiationId:
                                                      widget.negotiationId,
                                                  influencerId:
                                                      widget.influencerId));
                                        },
                                        child: Card(
                                            child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                      negotiation.projectTitle),
                                                  const Icon(
                                                    Icons
                                                        .arrow_forward_ios_outlined,
                                                    size: 12,
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                  "${DateUtil.dateWithDayFormat(negotiation.projectDuration['start']!)} - ${DateUtil.dateWithDayFormat(negotiation.projectDuration['end']!)}"),
                                              Container(
                                                  margin: const EdgeInsets
                                                      .symmetric(vertical: 8),
                                                  child: const Divider()),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      const Text(
                                                          "Kesepakatan Harga"),
                                                      Text(influencerName)
                                                    ],
                                                  ),
                                                  const SizedBox(height: 8),
                                                  Text(CurrencyFormat
                                                      .convertToIDR(negotiation
                                                          .projectPrice)),
                                                ],
                                              )
                                            ],
                                          ),
                                        )),
                                      ),
                                    ]),
                                Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 8),
                                    child: const Divider()),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Informasi Persetujuan"),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        nextScreen(
                                            context,
                                            UmkmAgreementPage(
                                                agreementId:
                                                    widget.agreementId));
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Text('Persetujuan UMKM'),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios_rounded,
                                                    size: 12,
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                agreement.umkmAgreement!,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        nextScreen(
                                            context,
                                            InfluencerAgreementPage(
                                                agreementId:
                                                    widget.agreementId));
                                      },
                                      child: Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(12),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Text(
                                                      'Persetujuan Influencer'),
                                                  Icon(
                                                    Icons
                                                        .arrow_forward_ios_outlined,
                                                    size: 12,
                                                  )
                                                ],
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                agreement.influencerAgreement!,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              ]),
                        ],
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
            bottomNavigationBar: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoaded) {
                  return Padding(
                      padding: const EdgeInsets.all(16),
                      child: state.transaction.transactionStatus == 'PENDING'
                          ? const Padding(
                              padding: EdgeInsets.zero,
                            )
                          : state.transaction.transactionStatus == "DONE"
                              ? Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    state.transaction.reviewId.isEmpty
                                        ? const Padding(
                                            padding: EdgeInsets.zero)
                                        : SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Constants.primaryColor,
                                                    elevation: 0,
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        30))),
                                                onPressed: () {
                                                  nextScreen(
                                                      context,
                                                      ReviewPage(
                                                          influencerId: state
                                                              .transaction
                                                              .influencerId,
                                                          transactionId: widget
                                                              .transactionId,
                                                          reviewId: state
                                                              .transaction
                                                              .reviewId));
                                                },
                                                child: const Text(
                                                    "Lihat Review"))),
                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              elevation: 0,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30))),
                                          onPressed: () {
                                            nextScreen(
                                                context,
                                                TransactionProgressPage(
                                                  transactionId:
                                                      widget.transactionId,
                                                ));
                                          },
                                          child: const Text(
                                              "Lihat Status Pengerjaan")),
                                    ),
                                  ],
                                )
                              : state.transaction.transactionStatus ==
                                      'CANCELED'
                                  ? ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Constants.primaryColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                      onPressed: () {
                                        nextScreen(
                                            context,
                                            RejectPage(
                                                reason: state
                                                    .transaction.cancelReason));
                                      },
                                      child:
                                          const Text('Lihat Alasan Pembatalan'))
                                  : ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Constants.primaryColor,
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                      onPressed: () {
                                        nextScreen(
                                            context,
                                            TransactionProgressPage(
                                                transactionId:
                                                    state.transaction.id));
                                      },
                                      child: const Text(
                                          "Lihat Status Pengerjaan")));
                }
                return Container();
              },
            ),
          ),
        ));
  }
}

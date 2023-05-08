import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluence_for_influencer/agreement/bloc/agreement_bloc.dart';
import 'package:fluence_for_influencer/agreement/pages/influencer_agreement_page.dart';
import 'package:fluence_for_influencer/agreement/pages/umkm_agreement_page.dart';
import 'package:fluence_for_influencer/agreement/repository/agreement_repository.dart';
import 'package:fluence_for_influencer/category/repository/category_repository.dart';
import 'package:fluence_for_influencer/influencer/bloc/influencer_bloc.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/negotiation/bloc/negotiation_bloc.dart';
import 'package:fluence_for_influencer/negotiation/model/negotiation.dart';
import 'package:fluence_for_influencer/negotiation/pages/negotiation_detail_page.dart';
import 'package:fluence_for_influencer/negotiation/repository/negotiation_repository.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/util/currency_utility.dart';
import 'package:fluence_for_influencer/shared/util/date_utility.dart';
import 'package:fluence_for_influencer/shared/widgets/snackbar_widget.dart';
import 'package:fluence_for_influencer/transaction/bloc/transaction_bloc.dart';
import 'package:fluence_for_influencer/transaction/repository/transaction_repository.dart';
import 'package:fluence_for_influencer/umkm/bloc/umkm_bloc.dart';
import 'package:fluence_for_influencer/umkm/repository/umkm_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluence_for_influencer/shared/widgets/show_alert_dialog.dart';
import 'package:uuid/uuid.dart';

class AgreementDetailPage extends StatefulWidget {
  final String agreementId;
  final String negotiationId;
  final String umkmId;

  const AgreementDetailPage({
    Key? key,
    required this.agreementId,
    required this.negotiationId,
    required this.umkmId,
  }) : super(key: key);

  @override
  State<AgreementDetailPage> createState() => _AgreementDetailPageState();
}

class _AgreementDetailPageState extends State<AgreementDetailPage> {
  late final AgreementBloc agreementBloc;
  final AgreementRepository agreementRepository = AgreementRepository();

  late final TransactionBloc transactionBloc;
  final TransactionRepository transactionRepository = TransactionRepository();

  late final Negotiation negotiation;
  late final NegotiationBloc negotiationBloc;
  final NegotiationRepository negotiationRepository = NegotiationRepository();

  late final UmkmBloc umkmBloc;
  final UmkmRepository umkmRepository = UmkmRepository();
  final CategoryRepository categoryRepository = CategoryRepository();

  final TextEditingController _umkmAgreementController =
      TextEditingController();
  final TextEditingController _influencerAgreementController =
      TextEditingController();

  bool isInfluencerAgreementEmpty = true;
  String umkmName = '';

  @override
  void initState() {
    super.initState();
    negotiationBloc =
        NegotiationBloc(negotiationRepository: negotiationRepository);
    negotiationBloc.add(GetNegotiationDetail(widget.negotiationId));

    transactionBloc =
        TransactionBloc(transactionRepository: transactionRepository);
    agreementBloc = AgreementBloc(agreementRepository: agreementRepository);
    umkmBloc = UmkmBloc(
        umkmRepository: umkmRepository, categoryRepository: categoryRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => agreementBloc),
          BlocProvider(create: (context) => transactionBloc),
          BlocProvider(create: (context) => negotiationBloc),
          BlocProvider(create: (context) => umkmBloc)
        ],
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Detail Persetujuan'),
            backgroundColor: Constants.primaryColor,
          ),
          body: MultiBlocListener(
              listeners: [
                BlocListener<AgreementBloc, AgreementState>(
                  listener: (context, state) {
                    if (state is AcceptAgreementSuccess) {
                      if (state.agreement.umkmAgreementStatus == 'ACCEPTED' &&
                          state.agreement.influencerAgreementStatus ==
                              'ACCEPTED') {
                        Uuid uuid = const Uuid();

                        final newTransaction = {
                          "order_id": uuid.v4(),
                          "negotiation_id": state.agreement.negotiationId,
                          "influencer_id": state.agreement.influencerId,
                          "umkm_id": state.agreement.umkmId,
                          "transaction_status": "PENDING",
                          "progress": {
                            "content_progress": {
                              "status": "PENDING",
                              "influencer_note": ""
                            },
                            "review_content": {
                              "status": "PENDING",
                              "influencer_note": "",
                              "influencer_note_draft": "",
                              "umkm_note": "",
                              "umkm_note_draft": "",
                            },
                            "upload_progress": {
                              "status": "PENDING",
                              "influencer_note": ""
                            },
                            "review_upload": {
                              "status": "PENDING",
                              "influencer_note": "",
                              "influencer_note_draft": "",
                              "umkm_note": "",
                              "umkm_note_draft": "",
                            }
                          },
                          "agreement_id": widget.agreementId,
                          "review_id": "",
                          "cancel_reason": "",
                          "created_at": Timestamp.now()
                        };
                        transactionBloc
                            .add(CreateNewTransaction(newTransaction));
                      } else {
                        SnackBarWidget.success(
                            context, 'Berhasil melakukan aktivitas');
                        navigateAsFirstScreen(
                            context, const MainPage(index: 0));
                      }
                    }
                    if (state is AgreementLoaded) {
                      _influencerAgreementController.text =
                          state.agreement.influencerAgreement!;

                      _umkmAgreementController.text =
                          state.agreement.umkmAgreement!;
                    }
                    if (state is AgreementError) {
                      SnackBarWidget.failed(context, state.error);
                    }
                  },
                ),
                BlocListener<TransactionBloc, TransactionState>(
                  listener: (context, state) {
                    if (state is TransactionProcessSuccess) {
                      SnackBarWidget.success(
                          context, 'Berhasil menerima persetujuan');
                      navigateAsFirstScreen(context, const MainPage(index: 0));
                    }
                    if (state is TransactionError) {
                      SnackBarWidget.failed(context, state.error);
                    }
                  },
                ),
                BlocListener<NegotiationBloc, NegotiationState>(
                  listener: (context, state) {
                    if (state is NegotiationLoaded) {
                      negotiation = state.negotiationDetails;
                      umkmBloc.add(GetUmkmDetail(widget.umkmId));
                    }
                    if (state is NegotiationError) {
                      SnackBarWidget.failed(context, state.error);
                    }
                  },
                ),
                BlocListener<UmkmBloc, UmkmState>(
                  listener: (context, state) {
                    if (state is UmkmLoaded) {
                      umkmName = state.umkm.fullname;
                      agreementBloc.add(GetAgreementDetail(widget.agreementId));
                    }
                    if (state is UmkmError) {
                      SnackBarWidget.failed(context, state.error);
                    }
                  },
                )
              ],
              child: BlocBuilder<AgreementBloc, AgreementState>(
                builder: (context, state) {
                  if (state is AgreementLoading) {
                    return const Center(
                      child: CircularProgressIndicator.adaptive(),
                    );
                  }
                  if (state is AgreementLoaded) {
                    return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(DateUtil.dateWithDayFormat(
                                        state.agreement.createdAt)),
                                    Chip(
                                      backgroundColor: state
                                                  .agreement.agreementStatus ==
                                              'DONE'
                                          ? Colors.green[300]
                                          : state.agreement.agreementStatus ==
                                                  'PENDING'
                                              ? Colors.yellow[300]
                                              : Colors.blue[300],
                                      label: Text(
                                          state.agreement.agreementStatus,
                                          style: const TextStyle(fontSize: 10)),
                                    )
                                  ],
                                ),
                                Container(
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 4),
                                    child: const Divider()),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Informasi Negosiasi"),
                                    const SizedBox(height: 8),
                                    GestureDetector(
                                      onTap: () {
                                        nextScreen(
                                            context,
                                            NegotiationDetailPage(
                                                umkmId: widget.umkmId,
                                                influencerId: state
                                                    .agreement.influencerId,
                                                negotiationId: state
                                                    .agreement.negotiationId));
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
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(negotiation
                                                        .projectTitle),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                        "${DateUtil.dateWithDayFormat(negotiation.projectDuration['start']!)} - ${DateUtil.dateWithDayFormat(negotiation.projectDuration['end']!)}"),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            Container(
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 8),
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
                                                          'Kesepakatan Harga'),
                                                      Text(umkmName)
                                                    ]),
                                                const SizedBox(height: 8),
                                                Text(
                                                    CurrencyFormat.convertToIDR(
                                                        negotiation
                                                            .projectPrice))
                                              ],
                                            )
                                          ],
                                        ),
                                      )),
                                    )
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    nextScreen(
                                        context,
                                        UmkmAgreementPage(
                                            agreementId: widget.agreementId));
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
                                                  const Text(
                                                      "Persetujuan UMKM"),
                                                  Chip(
                                                      backgroundColor: state
                                                                  .agreement
                                                                  .umkmAgreementStatus ==
                                                              "ACCEPTED"
                                                          ? Colors.green[300]
                                                          : state.agreement
                                                                      .umkmAgreementStatus ==
                                                                  "ON REVIEW"
                                                              ? Colors.blue[300]
                                                              : state.agreement
                                                                          .umkmAgreementStatus ==
                                                                      'NEED REVISION'
                                                                  ? Colors.orange[
                                                                      300]
                                                                  : Colors.yellow[
                                                                      300],
                                                      labelStyle:
                                                          const TextStyle(
                                                              fontSize: 10),
                                                      label: Text(state
                                                          .agreement
                                                          .umkmAgreementStatus))
                                                ]),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              child: Text(
                                                state.agreement.umkmAgreement!,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Wrap(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  child: const Icon(
                                                    Icons.info_outline_rounded,
                                                    color: Colors.grey,
                                                    size: 12,
                                                  ),
                                                ),
                                                const Text(
                                                  "Kontak perusahaan untuk mengisi persetujuan",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                )
                                              ],
                                            )
                                          ]),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    nextScreen(
                                        context,
                                        InfluencerAgreementPage(
                                            agreementId: widget.agreementId));
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
                                                const Text(
                                                    "Persetujuan Influencer"),
                                                Chip(
                                                  backgroundColor: state
                                                              .agreement
                                                              .influencerAgreementStatus ==
                                                          "ACCEPTED"
                                                      ? Colors.green[300]
                                                      : state.agreement
                                                                  .influencerAgreementStatus ==
                                                              "ON REVIEW"
                                                          ? Colors.blue[300]
                                                          : state.agreement
                                                                      .influencerAgreementStatus ==
                                                                  'NEED REVISION'
                                                              ? Colors
                                                                  .orange[300]
                                                              : Colors
                                                                  .yellow[300],
                                                  labelStyle: const TextStyle(
                                                      fontSize: 10),
                                                  label: Text(state.agreement
                                                      .influencerAgreementStatus),
                                                )
                                              ],
                                            ),
                                            Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 12),
                                              child: Text(
                                                state.agreement
                                                    .influencerAgreementDraft!,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            Wrap(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      right: 4),
                                                  child: const Icon(
                                                    Icons.info_outline_rounded,
                                                    color: Colors.grey,
                                                    size: 12,
                                                  ),
                                                ),
                                                const Text(
                                                  "Isi persetujuan untuk melanjutkan proses pemesanan",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.grey),
                                                )
                                              ],
                                            )
                                          ]),
                                    ),
                                  ),
                                ),
                              ]),
                        ));
                  }
                  return Container();
                },
              )),
          bottomNavigationBar: BlocBuilder<AgreementBloc, AgreementState>(
            builder: (context, state) {
              if (state is AgreementLoaded) {
                return state.agreement.umkmAgreementStatus != 'ACCEPTED'
                    ? Padding(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Constants.primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              onPressed: state.agreement.umkmAgreementStatus ==
                                      "ON REVIEW"
                                  ? () {
                                      acceptDialog(context);
                                    }
                                  : null,
                              child: const Text("Terima Persetujuan UMKM")),
                        ),
                      )
                    : state.agreement.agreementStatus == 'DONE'
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Constants.primaryColor,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  onPressed: () {
                                    navigateAsFirstScreen(
                                        context, const MainPage(index: 3));
                                  },
                                  child: const Text("Ke Halaman Transaksi")),
                            ),
                          )
                        : const Padding(padding: EdgeInsets.zero);
              }
              return Container();
            },
          ),
        ));
  }

  Future<bool> acceptDialog(context) async {
    Text dialogTitle = const Text("Terima Persetujuan");
    Text dialogContent =
        const Text("Apakah Anda yakin untuk menerima persetujuan?");
    TextButton primaryButton = TextButton(
      child: const Text("Terima"),
      onPressed: () {
        acceptAgreement();
        Navigator.pop(context, true);
      },
    );
    TextButton secondaryButton = TextButton(
      child: const Text("Batal"),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    final bool resp = await showDialog(
        context: context,
        builder: (context) => showAlertDialog(context, dialogTitle,
            dialogContent, primaryButton, secondaryButton));
    if (!resp) return false;
    return true;
  }

  void acceptAgreement() {
    agreementBloc.add(AcceptAgreement(widget.agreementId));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluence_for_influencer/agreement/bloc/agreement_bloc.dart';
import 'package:fluence_for_influencer/agreement/repository/agreement_repository.dart';
import 'package:fluence_for_influencer/category/repository/category_repository.dart';
import 'package:fluence_for_influencer/influencer/bloc/influencer_bloc.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/message/bloc/message_bloc.dart';
import 'package:fluence_for_influencer/message/repository/message_repository.dart';
import 'package:fluence_for_influencer/models/influencer.dart';
import 'package:fluence_for_influencer/negotiation/bloc/negotiation_bloc.dart';
import 'package:fluence_for_influencer/negotiation/repository/negotiation_repository.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/util/date_utility.dart';
import 'package:fluence_for_influencer/shared/widgets/show_alert_dialog.dart';
import 'package:fluence_for_influencer/shared/widgets/snackbar_widget.dart';
import 'package:fluence_for_influencer/shared/widgets/text_input.dart';
import 'package:fluence_for_influencer/umkm/bloc/umkm_bloc.dart';
import 'package:fluence_for_influencer/umkm/model/umkm.dart';
import 'package:fluence_for_influencer/umkm/repository/umkm_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NegotiationDetailPage extends StatefulWidget {
  final String negotiationId;
  final String influencerId;
  final String umkmId;
  final String? chatId;
  final bool? sentByMe;
  const NegotiationDetailPage(
      {Key? key,
      required this.negotiationId,
      required this.influencerId,
      required this.umkmId,
      this.chatId,
      this.sentByMe})
      : super(key: key);

  @override
  State<NegotiationDetailPage> createState() => _NegotiationDetailPageState();
}

class _NegotiationDetailPageState extends State<NegotiationDetailPage> {
  String umkmId = "";

  final CategoryRepository categoryRepository = CategoryRepository();
  final InfluencerRepository influencerRepository = InfluencerRepository();
  late final InfluencerBloc influencerBloc;

  final AgreementRepository agreementRepository = AgreementRepository();
  late final AgreementBloc agreementBloc;

  final NegotiationRepository negotiationRepository = NegotiationRepository();
  late final NegotiationBloc negotiationBloc;

  late final MessageBloc messageBloc;
  final MessageRepository messageRepository = MessageRepository();

  late final UmkmBloc umkmBloc;
  final UmkmRepository umkmRepository = UmkmRepository();

  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _projectDurationController =
      TextEditingController();
  final TextEditingController _projectPriceController = TextEditingController();
  final TextEditingController _projectDescController = TextEditingController();

  late Map<String, DateTime> projectDuration;

  late Umkm umkmProfile;
  late Influencer influencerProfile;

  String? _projectTitleValidator(String? value) {
    return value!.isEmpty ? "Masukkan judul" : null;
  }

  String? _projectDurationValidator(String? value) {
    return value!.isEmpty ? "Pilih durasi" : null;
  }

  String? _projectPriceValidator(String? value) {
    return value!.isEmpty ? "Masukkan harga yang ditawarkan" : null;
  }

  @override
  void initState() {
    super.initState();
    influencerBloc = InfluencerBloc(
        influencerRepository: influencerRepository,
        categoryRepository: categoryRepository);
    umkmBloc = UmkmBloc(
        umkmRepository: umkmRepository, categoryRepository: categoryRepository);
    agreementBloc = AgreementBloc(agreementRepository: agreementRepository);
    messageBloc = MessageBloc(messageRepository: messageRepository);
    negotiationBloc =
        NegotiationBloc(negotiationRepository: negotiationRepository);
    negotiationBloc.add(GetNegotiationDetail(widget.negotiationId));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => negotiationBloc),
        BlocProvider(create: (context) => influencerBloc),
        BlocProvider(create: (context) => agreementBloc),
        BlocProvider(create: (context) => umkmBloc),
        BlocProvider(create: (context) => messageBloc)
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detail Negosiasi'),
          elevation: 0,
          backgroundColor: Constants.primaryColor,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<UmkmBloc, UmkmState>(
              listener: (context, state) {
                if (state is UmkmLoaded) {
                  umkmProfile = state.umkm;
                  influencerBloc.add(GetInfluencerDetail(widget.influencerId));
                }
                if (state is UmkmError) {
                  SnackBarWidget.failed(context, state.error);
                }
              },
            ),
            BlocListener<InfluencerBloc, InfluencerState>(
              listener: (context, state) {
                if (state is InfluencerLoaded) {
                  influencerProfile = state.influencer;
                  negotiationBloc.add(AcceptNegotiation(widget.negotiationId));
                }
              },
            ),
            BlocListener<AgreementBloc, AgreementState>(
              listener: (context, state) {
                if (state is CreateNewAgreementSuccess) {
                  SnackBarWidget.success(
                      context, 'Berhasil menerima negosiasi');
                  messageBloc.add(SendNewNegotiation(
                      widget.chatId!,
                      Constants.firebaseAuth.currentUser!.uid,
                      widget.negotiationId,
                      'Negosiasi telah diterima'));
                }
              },
            ),
            BlocListener<NegotiationBloc, NegotiationState>(
              listener: (context, state) {
                if (state is AcceptNegotiationSuccess) {
                  final newAgreement = {
                    "influencer_agreement": influencerProfile.noteAgreement,
                    "influencer_agreement_draft":
                        influencerProfile.noteAgreement,
                    "influencer_agreement_status": "PENDING",
                    "umkm_agreement": umkmProfile.noteAgreement,
                    "umkm_agreement_draft": umkmProfile.noteAgreement,
                    "umkm_agreement_status": "PENDING",
                    "influencer_id": widget.influencerId,
                    "umkm_id": widget.umkmId,
                    "negotiation_id": widget.negotiationId,
                    "agreement_status": "PENDING",
                    "created_at": Timestamp.now()
                  };
                  agreementBloc.add(CreateNewAgreement(newAgreement));
                }
                if (state is RejectNegotiationSuccess) {
                  SnackBarWidget.success(context, 'Berhasil menolak negosiasi');
                  messageBloc.add(SendNewNegotiation(
                      widget.chatId!,
                      Constants.firebaseAuth.currentUser!.uid,
                      widget.negotiationId,
                      'Negosiasi ditolak'));
                }
                if (state is NegotiationError) {
                  SnackBarWidget.failed(context, state.error);
                }
              },
            ),
            BlocListener<MessageBloc, MessageState>(
              listener: (context, state) {
                if (state is NewChatAndMessageCreated) {
                  Navigator.pop(context);
                  // navigateAsFirstScreen(context, const MainPage(index: 1));
                }
              },
            )
          ],
          child: BlocBuilder<NegotiationBloc, NegotiationState>(
            builder: (context, state) {
              if (state is NegotiationLoaded) {
                _projectTitleController.text =
                    state.negotiationDetails.projectTitle;
                _projectDescController.text =
                    state.negotiationDetails.projectDesc ?? "";
                _projectPriceController.text =
                    state.negotiationDetails.projectPrice.toString();
                _projectDurationController.text =
                    "${DateUtil.dateWithDayFormat(state.negotiationDetails.projectDuration['start']!)} - ${DateUtil.dateWithDayFormat(state.negotiationDetails.projectDuration['end']!)}";

                projectDuration = {
                  "start": state.negotiationDetails.projectDuration['start']!,
                  "end": state.negotiationDetails.projectDuration['end']!
                };
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    "Informasi Negosiasi",
                                    style: TextStyle(
                                      color: Constants.primaryColor,
                                    ),
                                  ),
                                  Chip(
                                      backgroundColor: state.negotiationDetails
                                                  .negotiationStatus ==
                                              'DONE'
                                          ? Colors.green[300]
                                          : state.negotiationDetails
                                                      .negotiationStatus ==
                                                  "REJECTED"
                                              ? Colors.red[300]
                                              : Colors.yellow[300],
                                      label: Text(
                                        state.negotiationDetails
                                            .negotiationStatus,
                                        style: const TextStyle(fontSize: 10),
                                      )),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                "Judul Project",
                                style: TextStyle(color: Constants.primaryColor),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                readOnly: true,
                                controller: _projectTitleController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: _projectTitleValidator,
                                decoration: textInputDecoration,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Durasi Project",
                                style: TextStyle(color: Constants.primaryColor),
                              ),
                              const SizedBox(height: 8),
                              TextFormField(
                                readOnly: true,
                                controller: _projectDurationController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: _projectDurationValidator,
                                decoration: textInputDecoration,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Harga Project",
                                  style:
                                      TextStyle(color: Constants.primaryColor)),
                              const SizedBox(height: 8),
                              TextFormField(
                                readOnly: true,
                                controller: _projectPriceController,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                validator: _projectPriceValidator,
                                keyboardType: TextInputType.number,
                                decoration: textInputDecoration,
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Deskripsi Project",
                              style: TextStyle(color: Constants.primaryColor),
                            ),
                            const SizedBox(height: 8),
                            TextFormField(
                              readOnly: true,
                              controller: _projectDescController,
                              maxLines: null,
                              decoration: textInputDecoration,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              return Text(state.toString());
            },
          ),
        ),
        bottomNavigationBar: BlocConsumer<NegotiationBloc, NegotiationState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is NegotiationLoaded) {
              if (state.negotiationDetails.negotiationStatus == 'PENDING') {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.primaryColor,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () {
                              acceptDialog(context);
                            },
                            child: const Text("Terima")),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () {
                              rejectDialog(context);
                            },
                            child: const Text(
                              "Tolak",
                              style: TextStyle(color: Constants.primaryColor),
                            )),
                      )
                    ],
                  ),
                );
              } else if (state.negotiationDetails.negotiationStatus == 'DONE') {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Constants.primaryColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30))),
                        onPressed: () {
                          navigateAsFirstScreen(
                              context, const MainPage(index: 0));
                        },
                        child: const Text("Ke Halaman Persetujuan")),
                  ),
                );
              } else {
                return const Padding(padding: EdgeInsets.zero);
              }
            }
            return Container();
          },
        ),
      ),
    );
  }

  // Function on tap pick date range
  Future<void> pickDateRange(context) async {
    DateTimeRange? newDateRange = await showDateRangePicker(
        context: context, firstDate: DateTime(1900), lastDate: DateTime(2100));
    if (newDateRange != null) {
      String startDate = DateUtil.dateWithDayFormat(newDateRange.start);
      String endDate = DateUtil.dateWithDayFormat(newDateRange.end);
      _projectDurationController.text = "$startDate - $endDate";
    }
  }

  Future<bool> acceptDialog(context) async {
    Text dialogTitle = const Text("Terima Negosiasi");
    Text dialogContent =
        const Text("Apakah Anda yakin untuk menerima negosiasi?");
    TextButton primaryButton = TextButton(
      child: const Text("Terima"),
      onPressed: () {
        acceptNegotiation();
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

  Future<bool> rejectDialog(context) async {
    Text dialogTitle = const Text("Tolak Negosiasi");
    Text dialogContent =
        const Text("Apakah Anda yakin untuk menolak negosiasi?");
    TextButton primaryButton = TextButton(
      child: const Text("Tolak"),
      onPressed: () {
        rejectNegotiation();
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

  void acceptNegotiation() {
    umkmBloc.add(GetUmkmDetail(widget.umkmId));
  }

  void rejectNegotiation() {
    negotiationBloc.add(RejectNegotiation(widget.negotiationId));
  }
}

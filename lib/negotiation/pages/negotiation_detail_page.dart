import 'package:fluence_for_influencer/agreement/bloc/agreement_bloc.dart';
import 'package:fluence_for_influencer/agreement/repository/agreement_repository.dart';
import 'package:fluence_for_influencer/influencer/bloc/influencer_bloc.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/message/bloc/message_bloc.dart';
import 'package:fluence_for_influencer/message/repository/message_repository.dart';
import 'package:fluence_for_influencer/negotiation/bloc/negotiation_bloc.dart';
import 'package:fluence_for_influencer/negotiation/model/negotiation.dart';
import 'package:fluence_for_influencer/negotiation/repository/negotiation_repository.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/util/date_utility.dart';
import 'package:fluence_for_influencer/shared/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NegotiationDetailPage extends StatefulWidget {
  final String negotiationId;
  final String chatId;
  final bool sentByMe;
  const NegotiationDetailPage(
      {Key? key,
      required this.negotiationId,
      required this.chatId,
      required this.sentByMe})
      : super(key: key);

  @override
  State<NegotiationDetailPage> createState() => _NegotiationDetailPageState();
}

class _NegotiationDetailPageState extends State<NegotiationDetailPage> {
  String umkmId = "";
  final InfluencerRepository influencerRepository = InfluencerRepository();
  late final InfluencerBloc influencerBloc;

  final AgreementRepository agreementRepository = AgreementRepository();
  late final AgreementBloc agreementBloc;

  final NegotiationRepository negotiationRepository = NegotiationRepository();
  late final NegotiationBloc negotiationBloc;

  late final MessageBloc messageBloc;
  final MessageRepository messageRepository = MessageRepository();

  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _projectDurationController =
      TextEditingController();
  final TextEditingController _projectPriceController = TextEditingController();
  final TextEditingController _projectDescController = TextEditingController();

  late Map<String, DateTime> projectDuration;

  String? _projectTitleValidator(String? value) {
    return value!.isEmpty ? "Insert project title" : null;
  }

  String? _projectDurationValidator(String? value) {
    return value!.isEmpty ? "Insert range date" : null;
  }

  String? _projectPriceValidator(String? value) {
    return value!.isEmpty ? "Insert negotiation amount" : null;
  }

  @override
  void initState() {
    super.initState();
    influencerBloc = InfluencerBloc(influencerRepository: influencerRepository);

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
        BlocProvider(create: (context) => messageBloc)
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Details Negotiation'),
          elevation: 0,
          backgroundColor: Constants.primaryColor,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<InfluencerBloc, InfluencerState>(
              listener: (context, state) {
                if (state is InfluencerLoaded) {
                  final newAgreement = {
                    "influencer_agreement": state.influencer.noteAgreement,
                    "influencer_agreement_status": "PENDING",
                    "umkm_agreement": "",
                    "umkm_agreement_status": "PENDING",
                    "influencer_id": Constants.firebaseAuth.currentUser!.uid,
                    "umkm_id": umkmId,
                    "negotiation_id": widget.negotiationId
                  };
                  agreementBloc.add(CreateNewAgreement(newAgreement));
                }
              },
            ),
            BlocListener<AgreementBloc, AgreementState>(
              listener: (context, state) {
                if (state is CreateNewAgreementSuccess) {
                  navigateAsFirstScreen(context, const MainPage());
                }
              },
            ),
            BlocListener<NegotiationBloc, NegotiationState>(
              listener: (context, state) {
                if (state is RejectNegotiationSuccess) {
                  navigateAsFirstScreen(context, const MainPage());
                } else if (state is UpdateNegotiationSuccess) {
                  messageBloc.add(SendNewNegotiation(
                    widget.chatId,
                    Constants.firebaseAuth.currentUser!.uid,
                    widget.negotiationId,
                    "Negotiation Updated!",
                  ));
                }
              },
            ),
            BlocListener<MessageBloc, MessageState>(
              listener: (context, state) {
                if (state is NewChatAndMessageCreated) {
                  Navigator.pop(context);
                }
              },
            )
          ],
          child: BlocBuilder<NegotiationBloc, NegotiationState>(
            builder: (context, state) {
              if (state is NegotiationLoaded) {
                umkmId = state.negotiationDetails.umkmId;

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
                return SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
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
                                    const Text("Project Title"),
                                    Chip(
                                        label: Text(
                                      state
                                          .negotiationDetails.negotiationStatus,
                                      style: const TextStyle(fontSize: 10),
                                    )),
                                  ],
                                ),
                                TextFormField(
                                  controller: _projectTitleController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: _projectTitleValidator,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Project Duration"),
                                TextFormField(
                                  controller: _projectDurationController,
                                  onTap: () async {
                                    DateTimeRange? newDateRange =
                                        await showDateRangePicker(
                                            context: context,
                                            firstDate:
                                                DateTime(DateTime.now().year),
                                            lastDate: DateTime(2100));
                                    if (newDateRange != null) {
                                      String startDate =
                                          DateUtil.dateWithDayFormat(
                                              newDateRange.start);
                                      String endDate =
                                          DateUtil.dateWithDayFormat(
                                              newDateRange.end);

                                      projectDuration = {
                                        "start": newDateRange.start,
                                        "end": newDateRange.end
                                      };
                                      _projectDurationController.text =
                                          "$startDate - $endDate";
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: _projectDurationValidator,
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Project Price"),
                                TextFormField(
                                  controller: _projectPriceController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: _projectPriceValidator,
                                  keyboardType: TextInputType.number,
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Project Description"),
                              TextFormField(
                                controller: _projectDescController,
                                maxLines: null,
                              ),
                            ],
                          ),
                        ],
                      )),
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
              if (state.negotiationDetails.negotiationStatus == 'PENDING' &&
                  !widget.sentByMe) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              acceptNegotiation(
                                  state.negotiationDetails.influencerId);
                            },
                            child: const Text("Accept")),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                            onPressed: () {
                              rejectNegotiation();
                            },
                            child: const Text("Reject")),
                      )
                    ],
                  ),
                );
              } else if (state.negotiationDetails.negotiationStatus ==
                      "PENDING" &&
                  widget.sentByMe) {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                            onPressed: () {
                              Negotiation negotiation = Negotiation(
                                  widget.negotiationId,
                                  state.negotiationDetails.influencerId,
                                  state.negotiationDetails.umkmId,
                                  _projectTitleController.text,
                                  _projectDescController.text,
                                  double.parse(_projectPriceController.text),
                                  projectDuration,
                                  state.negotiationDetails.negotiationStatus);
                              negotiationBloc
                                  .add(UpdateNegotiation(negotiation));
                              // acceptNegotiation(
                              //     state.negotiationDetails.influencerId);
                            },
                            child: const Text("Submit")),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Back")),
                      )
                    ],
                  ),
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Back")),
                );
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

  void acceptNegotiation(String influencerId) {
    negotiationBloc.add(AcceptNegotiation(widget.negotiationId));
    influencerBloc.add(GetInfluencerDetail(influencerId));
  }

  void rejectNegotiation() {
    negotiationBloc.add(RejectNegotiation(widget.negotiationId));
  }
}

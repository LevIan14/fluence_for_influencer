import 'package:fluence_for_influencer/message/bloc/message_bloc.dart';
import 'package:fluence_for_influencer/message/repository/message_repository.dart';
import 'package:fluence_for_influencer/negotiation/bloc/negotiation_bloc.dart';
import 'package:fluence_for_influencer/negotiation/repository/negotiation_repository.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/util/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NegotiationCreatePage extends StatefulWidget {
  final String fromUserName;
  final String chatId;
  final String umkmId;
  final String influencerId;

  const NegotiationCreatePage(
      {Key? key,
      required this.fromUserName,
      required this.chatId,
      required this.umkmId,
      required this.influencerId})
      : super(key: key);

  @override
  State<NegotiationCreatePage> createState() => _NegotiationCreatePageState();
}

class _NegotiationCreatePageState extends State<NegotiationCreatePage> {
  final NegotiationRepository negotiationRepository = NegotiationRepository();
  late final NegotiationBloc negotiationBloc;

  final MessageRepository messageRepository = MessageRepository();
  late final MessageBloc messageBloc;

  late Map<String, DateTime> projectDuration;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _projectTitleController = TextEditingController();
  final TextEditingController _rangeDateController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _projectDescController = TextEditingController();
  String? _projectTitleValidator(String? value) {
    return value!.isEmpty ? "Insert project title" : null;
  }

  String? _rangeDateValidator(String? value) {
    return value!.isEmpty ? "Insert range date" : null;
  }

  String? _amountValidator(String? value) {
    return value!.isEmpty ? "Insert negotiation amount" : null;
  }

  @override
  void initState() {
    super.initState();
    negotiationBloc =
        NegotiationBloc(negotiationRepository: negotiationRepository);
    messageBloc = MessageBloc(messageRepository: messageRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => negotiationBloc),
        BlocProvider(create: (context) => messageBloc),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Create Negotiation'),
          elevation: 0,
          backgroundColor: Constants.primaryColor,
        ),
        body: MultiBlocListener(
          listeners: [
            BlocListener<MessageBloc, MessageState>(
              listener: (context, state) {
                if (state is NewChatAndMessageCreated) {
                  Navigator.pop(context, state.chatId);
                }
              },
            ),
            BlocListener<NegotiationBloc, NegotiationState>(
              listener: (context, state) {
                if (state is CreateNegotiationSuccess) {
                  if (widget.chatId == "") {
                    messageBloc.add(CreateNewChatAndMessage(
                        widget.umkmId,
                        widget.influencerId,
                        "Negotiation Created!",
                        state.negotiationId));
                  } else {
                    messageBloc.add(SendNewNegotiation(
                      widget.chatId,
                      Constants.firebaseAuth.currentUser!.uid,
                      state.negotiationId,
                      "Negotiation Created!",
                    ));
                  }
                }
              },
            )
          ],
          child: BlocBuilder<NegotiationBloc, NegotiationState>(
            builder: (context, state) {
              if (state is NegotiationLoading) {}
              return SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Project Title"),
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
                                  controller: _rangeDateController,
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

                                      _rangeDateController.text =
                                          "$startDate - $endDate";
                                    }
                                  },
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: _rangeDateValidator,
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
                                  controller: _amountController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: _amountValidator,
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
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                negotiationBloc.add(CreateNewNegotiation(
                    _projectTitleController.text.toString(),
                    _projectDescController.text.toString(),
                    _amountController.text.toString(),
                    projectDuration,
                    // _rangeDateController.text.toString(),
                    widget.influencerId,
                    Constants.firebaseAuth.currentUser!.uid));
              }
            },
            child: const Text("Submit"),
          ),
        ),
      ),
    );
  }
}

import 'package:fluence_for_influencer/agreement/bloc/agreement_bloc.dart';
import 'package:fluence_for_influencer/agreement/repository/agreement_repository.dart';
import 'package:fluence_for_influencer/influencer/bloc/influencer_bloc.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/negotiation/bloc/negotiation_bloc.dart';
import 'package:fluence_for_influencer/negotiation/repository/negotiation_repository.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/util/date_utility.dart';
import 'package:fluence_for_influencer/shared/widgets/app_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NegotiationDetailPage extends StatefulWidget {
  final String negotiationId;
  const NegotiationDetailPage({Key? key, required this.negotiationId})
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

  String? _projectDescValidator(String? value) {
    return value!.isEmpty ? "Insert project description" : null;
  }

  @override
  void initState() {
    super.initState();
    influencerBloc = InfluencerBloc(influencerRepository: influencerRepository);

    agreementBloc = AgreementBloc(agreementRepository: agreementRepository);

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
        BlocProvider(create: (context) => agreementBloc)
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
                    "influencer_agreement": state.influencer['note_agreement'],
                    "influencer_agreement_status": "",
                    "umkm_agreement": "",
                    "umkm_agreement_status": "",
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
                _amountController.text =
                    state.negotiationDetails.amount.toString();
                _rangeDateController.text = state.negotiationDetails.rangeDate;

                return SingleChildScrollView(
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 16, right: 16, bottom: 16),
                      child: Column(
                        children: [
                          AppTextfield(
                              field: 'Project Title',
                              // initialValue: state.negotiationDetails.projectTitle,
                              fieldController: _projectTitleController,
                              validator: _projectTitleValidator),
                          AppTextfield(
                            field: "Range Date",
                            // initialValue: state.negotiationDetails.rangeDate,
                            fieldController: _rangeDateController,
                            validator: _rangeDateValidator,
                            onTap: pickDateRange,
                          ),
                          AppTextfield(
                              keyboardType: TextInputType.number,
                              // initialValue:
                              //     state.negotiationDetails.amount.toString(),
                              field: 'Amount',
                              fieldController: _amountController,
                              validator: _amountValidator),
                          AppTextfield(
                              field: 'Project Description',
                              // initialValue:
                              //     state.negotiationDetails.projectDesc ?? "",
                              fieldController: _projectDescController,
                              validator: _projectDescValidator),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              onPressed: () {
                                acceptNegotiation(context);
                                // _authenticateWithEmailAndPassword(context);
                              },
                              child: const Text(
                                "Accept",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  elevation: 0,
                                  side: const BorderSide(
                                      color: Constants.primaryColor),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              onPressed: () {
                                // _authenticateWithEmailAndPassword(context);
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      )),
                );
              }
              return Text(state.toString());
            },
          ),
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
      _rangeDateController.text = "$startDate - $endDate";
    }
  }

  void acceptNegotiation(context) {
    BlocProvider.of<InfluencerBloc>(context)
        .add(GetInfluencerDetail(Constants.firebaseAuth.currentUser!.uid));
  }
}

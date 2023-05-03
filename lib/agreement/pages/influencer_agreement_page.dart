import 'package:fluence_for_influencer/agreement/bloc/agreement_bloc.dart';
import 'package:fluence_for_influencer/agreement/repository/agreement_repository.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class InfluencerAgreementPage extends StatefulWidget {
  final String agreementId;
  const InfluencerAgreementPage({Key? key, required this.agreementId})
      : super(key: key);

  @override
  State<InfluencerAgreementPage> createState() =>
      _InfluencerAgreementPageState();
}

class _InfluencerAgreementPageState extends State<InfluencerAgreementPage> {
  late final AgreementBloc agreementBloc;
  final AgreementRepository agreementRepository = AgreementRepository();

  final TextEditingController _influencerAgreementController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    agreementBloc = AgreementBloc(agreementRepository: agreementRepository);
    agreementBloc.add(GetAgreementDetail(widget.agreementId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => agreementBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Influencer Agreement"),
          backgroundColor: Constants.primaryColor,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<AgreementBloc, AgreementState>(
            listener: (context, state) {
              if (state is AgreementProcessSuccess) {
                navigateAsFirstScreen(context, const MainPage(index: 0));
              }
            },
            builder: (context, state) {
              if (state is AgreementLoaded) {
                _influencerAgreementController.text =
                    state.agreement.influencerAgreement!;
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Notes",
                        style: TextStyle(color: Constants.primaryColor),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: textInputDecoration,
                        controller: _influencerAgreementController,
                        readOnly: state.agreement.influencerAgreementStatus ==
                            "ACCEPTED",
                        validator: (value) => value!.isEmpty
                            ? "Insert influencer agreement"
                            : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        maxLines: null,
                      )
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
        bottomNavigationBar: BlocConsumer<AgreementBloc, AgreementState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is AgreementLoaded) {
              return state.agreement.influencerAgreementStatus == "PENDING" ||
                      state.agreement.influencerAgreementStatus ==
                          "NEED REVISION"
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Constants.primaryColor,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                submitInfluencerNoteAgreement(
                                    _influencerAgreementController.text);
                              }
                            },
                            child: const Text("Submit"),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30))),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                saveNoteInfluencerAgreement(
                                    _influencerAgreementController.text);
                              }
                            },
                            child: const Text("Save Note"),
                          ),
                        ),
                      ]),
                    )
                  : const Padding(padding: EdgeInsets.all(0));
            }
            return Container();
          },
        ),
      ),
    );
  }

  void submitInfluencerNoteAgreement(String umkmAgreement) {
    agreementBloc
        .add(UpdateInfluencerAgreement(widget.agreementId, umkmAgreement));
  }

  void saveNoteInfluencerAgreement(String influencerAgreement) {
    agreementBloc.add(
        SaveNoteInfluencerAgreement(widget.agreementId, influencerAgreement));
  }
}

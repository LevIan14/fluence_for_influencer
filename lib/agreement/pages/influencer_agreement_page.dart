import 'package:fluence_for_influencer/agreement/bloc/agreement_bloc.dart';
import 'package:fluence_for_influencer/agreement/repository/agreement_repository.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluence_for_influencer/shared/widgets/show_alert_dialog.dart';

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
          title: const Text("Persetujuan Influencer"),
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
                    state.agreement.influencerAgreementDraft!;
                return Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Catatan Persetujuan",
                        style: TextStyle(color: Constants.primaryColor),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: textInputDecoration,
                        controller: _influencerAgreementController,
                        readOnly: state.agreement.influencerAgreementStatus ==
                                "ACCEPTED" ||
                            state.agreement.influencerAgreementStatus ==
                                'ON REVIEW',
                        validator: (value) => value!.isEmpty
                            ? "Masukkan catatan persetujuan"
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
                                submitDialog(context,
                                    _influencerAgreementController.text);
                              }
                            },
                            child: const Text("Kirim"),
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
                            child: const Text("Simpan"),
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

  Future<bool> submitDialog(context, umkmAgreement) async {
    Text dialogTitle = const Text("Kirim Persetujuan");
    Text dialogContent =
        const Text("Apakah Anda yakin untuk mengirim catatan persetujuan?");
    TextButton primaryButton = TextButton(
      child: const Text("Kirim"),
      onPressed: () {
        submitInfluencerNoteAgreement(umkmAgreement);
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

  void submitInfluencerNoteAgreement(String umkmAgreement) {
    agreementBloc
        .add(UpdateInfluencerAgreement(widget.agreementId, umkmAgreement));
  }

  void saveNoteInfluencerAgreement(String influencerAgreement) {
    agreementBloc.add(
        SaveNoteInfluencerAgreement(widget.agreementId, influencerAgreement));
  }
}

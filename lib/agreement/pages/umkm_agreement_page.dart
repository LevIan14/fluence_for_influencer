import 'package:fluence_for_influencer/agreement/bloc/agreement_bloc.dart';
import 'package:fluence_for_influencer/agreement/repository/agreement_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UmkmAgreementPage extends StatefulWidget {
  final String agreementId;
  const UmkmAgreementPage({Key? key, required this.agreementId})
      : super(key: key);

  @override
  State<UmkmAgreementPage> createState() => _UmkmAgreementPageState();
}

class _UmkmAgreementPageState extends State<UmkmAgreementPage> {
  late final AgreementBloc agreementBloc;
  final AgreementRepository agreementRepository = AgreementRepository();

  final TextEditingController _influencerNoteController =
      TextEditingController();

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
            appBar: AppBar(title: const Text("Influencer Agreement")),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: BlocConsumer<AgreementBloc, AgreementState>(
                listener: (context, state) {},
                builder: (context, state) {
                  if (state is AgreementLoaded) {
                    _influencerNoteController.text =
                        state.agreement.influencerAgreement!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _influencerNoteController,
                          readOnly: true,
                          maxLines: null,
                        )
                      ],
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
                  return state.agreement.influencerAgreementStatus ==
                          "ON REVIEW"
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child:
                              Column(mainAxisSize: MainAxisSize.min, children: [
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {},
                                child: const Text("Accept"),
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: OutlinedButton(
                                onPressed: () {},
                                child: const Text("Need Revision"),
                              ),
                            ),
                          ]),
                        )
                      : const Padding(padding: EdgeInsets.all(0));
                }
                return Container();
              },
            )));
  }
}

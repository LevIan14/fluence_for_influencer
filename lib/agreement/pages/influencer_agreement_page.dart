import 'package:fluence_for_influencer/agreement/bloc/agreement_bloc.dart';
import 'package:fluence_for_influencer/agreement/repository/agreement_repository.dart';
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

  final TextEditingController _umkmNoteController = TextEditingController();

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
        appBar: AppBar(title: const Text("Umkm Agreement")),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: BlocConsumer<AgreementBloc, AgreementState>(
            listener: (context, state) {},
            builder: (context, state) {
              if (state is AgreementLoaded) {
                _umkmNoteController.text = state.agreement.umkmAgreement!;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _umkmNoteController,
                      readOnly: state.agreement.influencerAgreementStatus ==
                          "ACCEPTED",
                      validator: (value) =>
                          value!.isEmpty ? "Insert umkm agreement" : null,
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
              return state.agreement.umkmAgreementStatus == "PENDING" ||
                      state.agreement.umkmAgreementStatus == "NEED REVISION"
                  ? Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: const Text("Submit"),
                          ),
                        )
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
}

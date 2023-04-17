import 'package:fluence_for_influencer/agreement/bloc/agreement_bloc.dart';
import 'package:fluence_for_influencer/agreement/repository/agreement_repository.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AgreementDetailPage extends StatefulWidget {
  final String agreementId;

  const AgreementDetailPage({Key? key, required this.agreementId})
      : super(key: key);

  @override
  State<AgreementDetailPage> createState() => _AgreementDetailPageState();
}

class _AgreementDetailPageState extends State<AgreementDetailPage> {
  late final AgreementBloc agreementBloc;
  final AgreementRepository agreementRepository = AgreementRepository();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _umkmAgreementController =
      TextEditingController();
  final TextEditingController _influencerAgreementController =
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
        appBar: AppBar(title: const Text('Agreement Detail')),
        body: BlocConsumer<AgreementBloc, AgreementState>(
            listener: (context, state) {
          if (state is AcceptAgreementSuccess) {
            navigateAsFirstScreen(context, const MainPage());
          }
        }, builder: (context, state) {
          if (state is AgreementLoaded) {
            _influencerAgreementController.text =
                state.agreement['influencer_agreement'];

            _umkmAgreementController.text = state.agreement['umkm_agreement'];

            return Column(
              children: [
                SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        child: Column(children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: const Text("UMKM Agreement"),
                          ),
                          TextFormField(
                            enabled: false,
                            controller: _umkmAgreementController,
                            maxLines: null,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide:
                                        const BorderSide(color: Colors.red))),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child:
                                Text(state.agreement['umkm_agreement_status']),
                          )
                        ]),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 16),
                              child: const Text("Influencer Agreement")),
                          TextFormField(
                            controller: _influencerAgreementController,
                            maxLines: null,
                            decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide:
                                        const BorderSide(color: Colors.red)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(16),
                                    borderSide:
                                        const BorderSide(color: Colors.red))),
                          ),
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: Text(
                                state.agreement['influencer_agreement_status']),
                          )
                        ]),
                      ),
                    ]),
                  ),
                ),
                Expanded(child: Container()),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {}, child: const Text("Cancel")),
                      ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              acceptAgreement();
                            }
                          },
                          child: const Text("Accept")),
                    ])
              ],
            );
          }
          return Text(state.toString());
        }),
      ),
    );
  }

  void acceptAgreement() {
    agreementBloc.add(AcceptAgreement(widget.agreementId));
  }
}

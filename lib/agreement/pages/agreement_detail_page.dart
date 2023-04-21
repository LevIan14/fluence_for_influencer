import 'package:fluence_for_influencer/agreement/bloc/agreement_bloc.dart';
import 'package:fluence_for_influencer/agreement/repository/agreement_repository.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/transaction/bloc/transaction_bloc.dart';
import 'package:fluence_for_influencer/transaction/repository/transaction_repository.dart';
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

  late final TransactionBloc transactionBloc;
  final TransactionRepository transactionRepository = TransactionRepository();

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _umkmAgreementController =
      TextEditingController();
  final TextEditingController _influencerAgreementController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    transactionBloc =
        TransactionBloc(transactionRepository: transactionRepository);

    agreementBloc = AgreementBloc(agreementRepository: agreementRepository);
    agreementBloc.add(GetAgreementDetail(widget.agreementId));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => agreementBloc,
          ),
          BlocProvider(
            create: (context) => transactionBloc,
          )
        ],
        child: Scaffold(
          appBar: AppBar(title: const Text('Agreement Detail')),
          body: MultiBlocListener(
              listeners: [
                BlocListener<AgreementBloc, AgreementState>(
                  listener: (context, state) {
                    if (state is AcceptAgreementSuccess) {
                      if (state.agreement['umkm_agreement_status'] ==
                              'ACCEPTED' &&
                          state.agreement['influencer_agreement_status'] ==
                              'ACCEPTED') {
                        final newTransaction = {
                          "negotiation_id": state.agreement['negotiation_id'],
                          "influencer_id": state.agreement['influencer_id'],
                          "umkm_id": state.agreement['umkm_id'],
                          "transaction_status": "WAITING",
                          "agreement_id": widget.agreementId,
                          "review_id": ""
                        };
                        transactionBloc
                            .add(CreateNewTransaction(newTransaction));
                      } else {
                        navigateAsFirstScreen(context, const MainPage());
                      }
                    }
                  },
                ),
                BlocListener<TransactionBloc, TransactionState>(
                  listener: (context, state) {
                    if (state is CreateNewTransactionSuccess) {
                      navigateAsFirstScreen(context, const MainPage());
                    }
                  },
                )
              ],
              child: BlocBuilder<AgreementBloc, AgreementState>(
                builder: (context, state) {
                  if (state is AgreementLoaded) {
                    _influencerAgreementController.text =
                        state.agreement['influencer_agreement'];

                    _umkmAgreementController.text =
                        state.agreement['umkm_agreement'];

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
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: const BorderSide(
                                                color: Colors.red)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: const BorderSide(
                                                color: Colors.red))),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: Text(state
                                        .agreement['umkm_agreement_status']),
                                  )
                                ]),
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 16),
                                child: Column(children: [
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 16),
                                      child:
                                          const Text("Influencer Agreement")),
                                  TextFormField(
                                    controller: _influencerAgreementController,
                                    maxLines: null,
                                    decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: const BorderSide(
                                                color: Colors.red)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(16),
                                            borderSide: const BorderSide(
                                                color: Colors.red))),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 16),
                                    child: Text(state.agreement[
                                        'influencer_agreement_status']),
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
                                  onPressed: () {},
                                  child: const Text("Cancel")),
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
                },
              )),
        ));
  }

  void acceptAgreement() {
    agreementBloc.add(AcceptAgreement(widget.agreementId));
  }
}

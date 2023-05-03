import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluence_for_influencer/agreement/bloc/agreement_bloc.dart';
import 'package:fluence_for_influencer/agreement/repository/agreement_repository.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/text_input.dart';
import 'package:fluence_for_influencer/transaction/bloc/transaction_bloc.dart';
import 'package:fluence_for_influencer/transaction/repository/transaction_repository.dart';
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

  late final TransactionBloc transactionBloc;
  final TransactionRepository transactionRepository = TransactionRepository();

  final TextEditingController _umkmAgreementController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    agreementBloc = AgreementBloc(agreementRepository: agreementRepository);
    agreementBloc.add(GetAgreementDetail(widget.agreementId));
    transactionBloc =
        TransactionBloc(transactionRepository: transactionRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => agreementBloc),
          BlocProvider(create: (context) => transactionBloc)
        ],
        child: MultiBlocListener(
          listeners: [
            BlocListener<TransactionBloc, TransactionState>(
              listener: (context, state) {
                if (state is TransactionProcessSuccess) {
                  navigateAsFirstScreen(context, const MainPage(index: 0));
                }
              },
            ),
            BlocListener<AgreementBloc, AgreementState>(
              listener: (context, state) {
                if (state is AcceptAgreementSuccess) {
                  if (state.agreement.umkmAgreementStatus == 'ACCEPTED' &&
                      state.agreement.influencerAgreementStatus == 'ACCEPTED') {
                    final newTransaction = {
                      "negotiation_id": state.agreement.negotiationId,
                      "influencer_id": state.agreement.influencerId,
                      "umkm_id": state.agreement.umkmId,
                      "transaction_status": "PENDING",
                      "progress": {
                        "content_progress": {"status": "PENDING"},
                        "review_content": {
                          "status": "PENDING",
                          "influencer_note": "",
                          "umkm_note": ""
                        },
                        "upload_progress": {"status": "PENDING"},
                        "review_upload": {
                          "status": "PENDING",
                          "influencer_note": "",
                          "umkm_note": ""
                        }
                      },
                      "agreement_id": widget.agreementId,
                      "review_id": "",
                      "created_at": Timestamp.now()
                    };
                    transactionBloc.add(CreateNewTransaction(newTransaction));
                  } else {
                    navigateAsFirstScreen(context, const MainPage(index: 0));
                  }
                }
                if (state is AgreementProcessSuccess) {
                  navigateAsFirstScreen(context, const MainPage(index: 0));
                }
              },
            )
          ],
          child: Scaffold(
              appBar: AppBar(
                title: const Text("UMKM Agreement"),
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
                      _umkmAgreementController.text =
                          state.agreement.umkmAgreement!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Notes",
                            style: TextStyle(color: Constants.primaryColor),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _umkmAgreementController,
                            readOnly: true,
                            maxLines: null,
                            decoration: textInputDecoration,
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
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          backgroundColor:
                                              Constants.primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                      onPressed: () {
                                        agreementBloc.add(AcceptAgreement(
                                            widget.agreementId));
                                      },
                                      child: const Text("Accept"),
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          elevation: 0,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                      onPressed: () {
                                        agreementBloc.add(NeedRevisionAgreement(
                                            widget.agreementId));
                                      },
                                      child: const Text("Need Revision"),
                                    ),
                                  ),
                                ]),
                          )
                        : const Padding(padding: EdgeInsets.zero);
                  }
                  return Container();
                },
              )),
        ));
  }
}

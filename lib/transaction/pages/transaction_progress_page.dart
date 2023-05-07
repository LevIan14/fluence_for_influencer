import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/transaction/bloc/transaction_bloc.dart';
import 'package:fluence_for_influencer/transaction/model/order_transaction.dart';
import 'package:fluence_for_influencer/transaction/repository/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'progress/content_progress_page.dart';
import 'progress/review_content_page.dart';
import 'progress/review_upload_page.dart';
import 'progress/upload_progress_page.dart';

class TransactionProgressPage extends StatefulWidget {
  final String transactionId;
  final int currentProgress;
  const TransactionProgressPage(
      {Key? key, required this.transactionId, required this.currentProgress})
      : super(key: key);

  @override
  State<TransactionProgressPage> createState() =>
      _TransactionProgressPageState();
}

class _TransactionProgressPageState extends State<TransactionProgressPage> {
  late final TransactionBloc transactionBloc;
  final TransactionRepository transactionRepository = TransactionRepository();
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
    currentStep = widget.currentProgress;
    transactionBloc =
        TransactionBloc(transactionRepository: transactionRepository);
    transactionBloc.add(GetTransactionDetail(widget.transactionId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => transactionBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Status Pengerjaan"),
          backgroundColor: Constants.primaryColor,
        ),
        body: BlocConsumer<TransactionBloc, TransactionState>(
          listener: (context, state) {},
          builder: (context, state) {
            if (state is TransactionLoaded) {
              checkProgress(state.transaction);

              return Stepper(
                  onStepTapped: (step) {
                    if (step <= widget.currentProgress) {
                      setState(() {
                        currentStep = step;
                      });
                    }
                  },
                  currentStep: currentStep,
                  controlsBuilder: (context, details) {
                    return Container();
                  },
                  steps: [
                    Step(
                        title: const Text("Pembuatan Konten"),
                        isActive: currentStep == 0,
                        state: state.transaction.orderProgress.contentProgress
                                    .status ==
                                "DONE"
                            ? StepState.complete
                            : StepState.indexed,
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Anda bisa memulai pembuatan konten sesuai kesepakatan dengan UMKM. Anda bisa menyimpan catatan seperti unggahan konten dalam bentuk tautan dalam halaman detail',
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Constants.primaryColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                onPressed: () {
                                  nextScreen(
                                      context,
                                      ContentProgressPage(
                                          transactionId: widget.transactionId));
                                },
                                child: const Text("Lihat Detail"),
                              ),
                            ),
                          ],
                        )),
                    Step(
                      isActive: currentStep == 1,
                      state: state.transaction.orderProgress.reviewContent
                                  .status ==
                              "DONE"
                          ? StepState.complete
                          : StepState.indexed,
                      title: const Text("Ulas Konten"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Buka untuk melihat catatan ulasan konten',
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Constants.primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              onPressed: () {
                                nextScreen(
                                    context,
                                    ReviewContentPage(
                                        transactionId: widget.transactionId));
                              },
                              child: const Text("Lihat Detail"),
                            ),
                          )
                        ],
                      ),
                    ),
                    Step(
                      isActive: currentStep == 2,
                      state: state.transaction.orderProgress.uploadProgress
                                  .status ==
                              "DONE"
                          ? StepState.complete
                          : StepState.indexed,
                      title: const Text("Proses Unggah"),
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Anda bisa mulai mengunggah konten sesuai kesepakatan dengan UMKM. Anda bisa menyimpan catatan seperti unggahan konten dalam bentuk link dalam halaman detail',
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Constants.primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              onPressed: () {
                                nextScreen(
                                    context,
                                    UploadProgressPage(
                                        transactionId: widget.transactionId));
                              },
                              child: const Text("Lihat Detail"),
                            ),
                          )
                        ],
                      ),
                    ),
                    Step(
                        isActive: currentStep == 3,
                        state: state.transaction.orderProgress.reviewUpload
                                    .status ==
                                "DONE"
                            ? StepState.complete
                            : StepState.indexed,
                        title: const Text("Ulas Unggahan"),
                        content: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Buka untuk melihat catatan ulasan unggahan',
                              textAlign: TextAlign.justify,
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Constants.primaryColor,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                onPressed: () {
                                  nextScreen(
                                      context,
                                      ReviewUploadPage(
                                          transactionId: widget.transactionId));
                                },
                                child: const Text("Lihat Detail"),
                              ),
                            ),
                          ],
                        )),
                    Step(
                        title: const Text("Selesai"),
                        isActive: currentStep == 4,
                        state: state.transaction.transactionStatus == "DONE" &&
                                currentStep == 4
                            ? StepState.complete
                            : StepState.indexed,
                        content: Container())
                  ]);
            }
            return Container();
          },
        ),
      ),
    );
  }

  void checkProgress(OrderTransaction transaction) {
    int index = 0;

    if (transaction.orderProgress.contentProgress.status != "DONE") {
      index = 0;
    } else {
      if (transaction.orderProgress.reviewContent.status != "DONE") {
        index = 1;
      } else {
        if (transaction.orderProgress.uploadProgress.status != "DONE") {
          index = 2;
        } else {
          if (transaction.orderProgress.reviewUpload.status != "DONE") {
            index = 3;
          } else {
            index = 4;
          }
        }
      }
    }

    currentStep = index;
  }
}

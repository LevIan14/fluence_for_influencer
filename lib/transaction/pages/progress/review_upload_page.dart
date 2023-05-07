import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/show_alert_dialog.dart';
import 'package:fluence_for_influencer/shared/widgets/snackbar_widget.dart';
import 'package:fluence_for_influencer/shared/widgets/text_input.dart';
import 'package:fluence_for_influencer/transaction/bloc/transaction_bloc.dart';
import 'package:fluence_for_influencer/transaction/repository/transaction_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewUploadPage extends StatefulWidget {
  final String transactionId;

  const ReviewUploadPage({Key? key, required this.transactionId})
      : super(key: key);

  @override
  State<ReviewUploadPage> createState() => _ReviewUploadPageState();
}

class _ReviewUploadPageState extends State<ReviewUploadPage> {
  late final TransactionBloc transactionBloc;
  final TransactionRepository transactionRepository = TransactionRepository();

  final TextEditingController _contentNoteController = TextEditingController();
  final TextEditingController _reviewNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();
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
          title: const Text("Ulas Unggahan"),
          backgroundColor: Constants.primaryColor,
        ),
        body: BlocConsumer<TransactionBloc, TransactionState>(
          listener: (context, state) {
            if (state is TransactionProcessSuccess) {
              SnackBarWidget.success(context, 'Berhasil melakukan aktivitas');
              navigateAsFirstScreen(context, const MainPage(index: 0));
            }
            if (state is TransactionError) {
              SnackBarWidget.failed(context, state.toString());
            }
          },
          builder: (context, state) {
            if (state is TransactionLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (state is TransactionLoaded) {
              _contentNoteController.text = state
                  .transaction.orderProgress.reviewUpload.influencerNoteDraft;
              _reviewNoteController.text =
                  state.transaction.orderProgress.reviewUpload.umkmNote;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Catatan Unggahan"),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          helperMaxLines: 10,
                          helperText:
                              'Kolom milik Influencer untuk memberi catatan terkait unggahan seperti unggahan dalam bentuk tautan',
                        ),
                        maxLines: null,
                        controller: _contentNoteController,
                        validator: (value) =>
                            value!.isEmpty ? "Masukkan catatan unggahan" : null,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                      ),
                      const SizedBox(height: 16),
                      const Text("Ulasan"),
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: textInputDecoration.copyWith(
                          helperMaxLines: 10,
                          helperText:
                              'Kolom milik UMKM untuk memberi ulasan. Anda bisa menyimpan draft ulasan dengan menekan ikon centang.',
                        ),
                        readOnly: true,
                        maxLines: null,
                        controller: _reviewNoteController,
                      )
                    ],
                  ),
                ),
              );
            }
            return Container();
          },
        ),
        bottomNavigationBar: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoaded) {
              return state.transaction.orderProgress.reviewUpload.status ==
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
                                        borderRadius:
                                            BorderRadius.circular(30))),
                                onPressed: () {
                                  if (_contentNoteController.text.isNotEmpty) {
                                    updateDialog(context, state.transaction);
                                  }
                                },
                                child:
                                    const Text("Selesai Mengunggah Konten"))),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              onPressed: () {
                                transactionBloc.add(SaveNotesReviewUpload(
                                    widget.transactionId,
                                    _contentNoteController.text,
                                    state.transaction.orderProgress));
                              },
                              child: const Text("Simpan")),
                        )
                      ]),
                    )
                  : state.transaction.orderProgress.reviewUpload.status ==
                          'PENDING'
                      ? Padding(
                          padding: const EdgeInsets.all(16),
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Constants.primaryColor,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              onPressed: () {
                                transactionBloc.add(SaveNotesReviewUpload(
                                    widget.transactionId,
                                    _contentNoteController.text,
                                    state.transaction.orderProgress));
                              },
                              child: const Text('Simpan')),
                        )
                      : const Padding(padding: EdgeInsets.all(0));
            }
            return Container();
          },
        ),
      ),
    );
  }

  Future<bool> updateDialog(context, transaction) async {
    Text dialogTitle = const Text("Ubah Status");
    Text dialogContent = const Text("Apakah Anda yakin ingin mengubah status?");
    TextButton primaryButton = TextButton(
      child: const Text("Ya"),
      onPressed: () {
        transactionBloc.add(UpdateStatusReviewUpload(
            widget.transactionId,
            _contentNoteController.text,
            "ON REVIEW",
            transaction.orderProgress));
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
}

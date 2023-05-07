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

class ContentProgressPage extends StatefulWidget {
  final String transactionId;
  const ContentProgressPage({Key? key, required this.transactionId})
      : super(key: key);

  @override
  State<ContentProgressPage> createState() => _ContentProgressPageState();
}

class _ContentProgressPageState extends State<ContentProgressPage> {
  late final TransactionBloc transactionBloc;
  final TransactionRepository transactionRepository = TransactionRepository();

  final TextEditingController _notesController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

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
          title: const Text("Pembuatan Konten"),
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
              _notesController.text = state
                  .transaction.orderProgress.contentProgress.influencerNote;
              return Form(
                key: _formKey,
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Catatan"),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _notesController,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) =>
                                  value!.isEmpty ? "Masukkan catatan" : null,
                              maxLines: null,
                              decoration: textInputDecoration.copyWith(
                                helperMaxLines: 10,
                                helperText:
                                    'Anda bisa memberi catatan seperti tautan konten yang telah dibuat. Anda bisa menyimpan draft catatan dengan menekan tombol Simpan.',
                              ),
                            )
                          ]),
                    )),
              );
            }
            return Container();
          },
        ),
        bottomNavigationBar: BlocBuilder<TransactionBloc, TransactionState>(
          builder: (context, state) {
            if (state is TransactionLoaded) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
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
                              updateDialog(context, state.transaction);
                            }
                          },
                          child: const Text("Selesai Membuat Konten")),
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
                                transactionBloc.add(SaveNotesContentProgress(
                                    widget.transactionId,
                                    _notesController.text,
                                    state.transaction.orderProgress));
                              }
                            },
                            child: const Text("Simpan"))),
                  ],
                ),
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Future<bool> updateDialog(context, transaction) async {
    Text dialogTitle = const Text("Ubah Status");
    Text dialogContent =
        const Text("Apakah Anda yakin ingin mengubah status menjadi selesai?");
    TextButton primaryButton = TextButton(
      child: const Text("Ya"),
      onPressed: () {
        transactionBloc.add(UpdateStatusContentProgress(widget.transactionId,
            _notesController.text, "DONE", transaction.orderProgress));
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

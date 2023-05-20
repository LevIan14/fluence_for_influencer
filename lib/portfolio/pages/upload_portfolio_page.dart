import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:fluence_for_influencer/influencer/bloc/influencer_bloc.dart';
import 'package:fluence_for_influencer/portfolio/bloc/portfolio_bloc.dart';
import 'package:fluence_for_influencer/influencer/pages/profile_page.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/portfolio/repository/portfolio_repository.dart';
import 'package:fluence_for_influencer/shared/app_button.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/show_alert_dialog.dart';
import 'package:fluence_for_influencer/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class InfluencerUploadPortfolioPage extends StatefulWidget {
  const InfluencerUploadPortfolioPage({super.key, required this.img});

  final XFile img;

  @override
  State<InfluencerUploadPortfolioPage> createState() =>
      _InfluencerUploadPortfolioPageState();
}

class _InfluencerUploadPortfolioPageState extends State<InfluencerUploadPortfolioPage> {
  final String influencerId = Constants.firebaseAuth.currentUser!.uid;
  // final TextEditingController titleController = TextEditingController();
  final TextEditingController captionController = TextEditingController();
  late final PortfolioBloc portfolioBloc;
  final PortfolioRepository portfolioRepository = PortfolioRepository();

  @override
  initState() {
    super.initState();
    portfolioBloc = PortfolioBloc(portfolioRepository: portfolioRepository);
  }

  getImgBytes() async {
    Uint8List imgBytes = await File(widget.img.path).readAsBytes();
    return imgBytes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(context),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
            onPressed: () {
              showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) =>
                            showDialogWithCircularProgress(context));
              portfolioBloc.add(UploadInfluencerPortfolio(
                  influencerId, widget.img, captionController.text));
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              )),
              backgroundColor:
                  MaterialStateProperty.all<Color>(Constants.primaryColor),
            ),
            child: const Text('Unggah',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w500))),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Constants.primaryColor,
      elevation: 0,
      title: const Text('Unggah Portfolio'),
    );
  }

  Widget buildBody(BuildContext context) {
    double margin = 10.0;
    return BlocProvider(
        create: (context) => portfolioBloc,
        child: BlocListener<PortfolioBloc, PortfolioState>(
          listener: (context, state) {
            if (state is InfluencerPortfolioUploaded) {
              showDialog(
                  context: context,
                  builder: (context) => createDialog(context));
            }
          },
          child: SingleChildScrollView(
              child: Container(
            height: MediaQuery.of(context).size.height,
            padding:
                EdgeInsets.symmetric(horizontal: margin * 2, vertical: margin),
            child: Column(children: [
              FutureBuilder(
                future: getImgBytes(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    final imgBytes = snapshot.data!;
                    return Container(
                        margin: EdgeInsets.symmetric(vertical: margin / 2),
                        child: AspectRatio(
                          aspectRatio: 3 / 4,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.memory(imgBytes, fit: BoxFit.cover),
                          ),
                        ));
                  }
                  return const SizedBox(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.symmetric(vertical: margin),
                child: TextFormField(
                  autofocus: true,
                  minLines: 1,
                  maxLines: 50,
                  controller: captionController,
                  decoration: const InputDecoration(
                    filled: false,
                    hintText: 'Masukkan keterangan...',
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 10, vertical: 16),
                    constraints: BoxConstraints(maxWidth: 150),
                    labelStyle: TextStyle(color: Colors.black),
                    // Enabled and focused
                    focusedBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    // Enabled and not showing error
                    enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    // Has error but not focus
                    errorBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                    // Has error and focus
                    focusedErrorBorder:
                        OutlineInputBorder(borderSide: BorderSide.none),
                  ),
                ),
              ),
              // Container(
              //   margin: EdgeInsets.symmetric(vertical: margin / 2),
              //   padding: EdgeInsets.symmetric(vertical: margin / 2, horizontal: margin / 2),
              //   decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
              //   child: Text("UPLOAD", style: TextStyle(color: Colors.white)),
              // ),
            ]),
          )),
        ));
  }

  createDialog(BuildContext context) {
    Text dialogTitle = const Text("Portofolio Telah Diunggah");
    Text dialogContent =
        const Text("Portfolio baru ditambahkan pada profil Anda");
    TextButton okayButton = TextButton(
      child: const Text("Kembali ke Beranda"),
      onPressed: () {
        navigateAsFirstScreen(context, const MainPage(index: 2));
      },
    );
    return showAlertDialog(
        context, dialogTitle, dialogContent, okayButton, null);
  }
}

import 'package:fluence_for_influencer/influencer/pages/profile_page.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/models/portfolio.dart';
import 'package:fluence_for_influencer/portfolio/bloc/portfolio_bloc.dart';
import 'package:fluence_for_influencer/portfolio/repository/portfolio_repository.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/show_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditPortfolioPage extends StatefulWidget {
  EditPortfolioPage({super.key, required this.portfolio});

  Portfolio portfolio;

  @override
  State<EditPortfolioPage> createState() => _EditPortfolioPageState();
}

class _EditPortfolioPageState extends State<EditPortfolioPage> {
  late final PortfolioBloc portfolioBloc;
  final PortfolioRepository portfolioRepository = PortfolioRepository();

  final String influencerId = Constants.firebaseAuth.currentUser!.uid;
  late Portfolio editedPortfolio;
  final TextEditingController _captionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    portfolioBloc = PortfolioBloc(portfolioRepository: portfolioRepository);
    editedPortfolio = widget.portfolio;
    if (widget.portfolio.caption != null)
      _captionController.text = widget.portfolio.caption!;
  }

  saveChanges() {
    setState(() {
      editedPortfolio.caption = _captionController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (widget.portfolio.caption == _captionController.text) return true;
          return createWillPopDialog(context);
        },
        child: Scaffold(
          appBar: buildAppBar(context),
          body: buildBody(context),
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
                onPressed: () {
                  saveChanges();
                  portfolioBloc.add(
                      EditInfluencerPortfolio(influencerId, editedPortfolio));
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Constants.primaryColor),
                ),
                child: const Text('Simpan',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w500))),
          ),
        ));
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
        elevation: 0,
        backgroundColor: Constants.primaryColor,
        title: const Text('Ubah Keterangan'));
  }

  Widget buildBody(BuildContext context) {
    double margin = 10.0;
    return BlocProvider(
      create: (context) => portfolioBloc,
      child: BlocListener<PortfolioBloc, PortfolioState>(
        listener: (context, state) {
          if (state is InfluencerPortfolioUpdated) {
            navigateAsFirstScreen(context, const MainPage(index: 1));
          }
        },
        child: SingleChildScrollView(
            child: Container(
          height: MediaQuery.of(context).size.height,
          padding:
              EdgeInsets.symmetric(horizontal: margin * 2, vertical: margin),
          child: Column(children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: margin / 2),
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(widget.portfolio.imageUrl,
                        fit: BoxFit.cover),
                  ),
                )),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.symmetric(vertical: margin),
              child: TextFormField(
                autofocus: true,
                minLines: 1,
                maxLines: 50,
                controller: _captionController,
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
                  errorBorder: OutlineInputBorder(borderSide: BorderSide.none),
                  // Has error and focus
                  focusedErrorBorder:
                      OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
          ]),
        )),
      ),
    );
  }

  Future<bool> createWillPopDialog(context) async {
    Text dialogTitle = const Text("Buang perubahan?");
    Text dialogContent = const Text(
        "Anda akan kehilangan perubahan data jika meninggalkan halaman.");
    TextButton discardButton = TextButton(
      child: const Text("Buang"),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
    TextButton cancelButton = TextButton(
      child: const Text("Lanjut Ubah"),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    final bool resp = await showDialog(
        context: context,
        builder: (context) => showAlertDialog(
            context, dialogTitle, dialogContent, discardButton, cancelButton));
    if (!resp) return false;
    return true;
  }
}

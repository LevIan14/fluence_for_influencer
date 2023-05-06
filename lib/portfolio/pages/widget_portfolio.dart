import 'package:fluence_for_influencer/portfolio/bloc/portfolio_bloc.dart';
import 'package:fluence_for_influencer/portfolio/pages/edit_portfolio_page.dart';
import 'package:fluence_for_influencer/models/portfolio.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:ionicons/ionicons.dart';

class InfluencerPortfolio extends StatelessWidget {
  InfluencerPortfolio(
      {super.key, required this.portfolio, required this.portfolioBloc});

  final Portfolio portfolio;
  final PortfolioBloc portfolioBloc;
  final String influencerId = Constants.firebaseAuth.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    double margin = 10.0;
    return Container(
        decoration: BoxDecoration(
          borderRadius: Constants.defaultBorderRadiusButton,
          color: Colors.white,
        ),
        // width: maxWidth,
        padding: EdgeInsets.symmetric(vertical: margin),
        child: Stack(children: [
          Align(
            alignment: const Alignment(1, 1),
            child: IconButton(
                icon: const Icon(Ionicons.ellipsis_vertical_outline,
                    color: Constants.grayColor),
                iconSize: 22.0,
                onPressed: () {
                  showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15.0)),
                      ),
                      context: context,
                      builder: (context) {
                        TextStyle textStyle = const TextStyle(
                          color: Colors.black87,
                          fontSize: 18.0,
                        );
                        return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15.0)),
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: Icon(Ionicons.pencil_outline,
                                        color: Colors.grey.shade600),
                                    title: Text("Ubah Keterangan",
                                        style: textStyle),
                                    onTap: () async {
                                      Navigator.pop(context);
                                      nextScreen(
                                          context,
                                          EditPortfolioPage(
                                              portfolio: portfolio));
                                      // influencerBloc.add();
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Ionicons.trash_outline,
                                        color: Colors.red),
                                    title: Text("Hapus portfolio",
                                        style: textStyle.copyWith(
                                            color: Colors.red)),
                                    onTap: () async {
                                      portfolioBloc.add(
                                          DeleteInfluencerPortfolio(
                                              influencerId, portfolio));
                                    },
                                  ),
                                ]));
                      });
                }),
          ),
          Container(
            padding: EdgeInsets.symmetric(
                vertical: margin * 2.5, horizontal: margin * 2.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(vertical: margin * 2),
                    child: AspectRatio(
                      aspectRatio: 3 / 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.network(portfolio.imageUrl,
                            fit: BoxFit.cover),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.only(top: margin),
                  child: Text(portfolio.caption!,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(
                          color: Colors.black87, fontSize: 18.0)),
                )
              ],
            ),
          ),
        ]));
  }
}

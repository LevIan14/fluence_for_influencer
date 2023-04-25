import 'package:fluence_for_influencer/models/portfolio.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class InfluencerPortfolio extends StatelessWidget {
  const InfluencerPortfolio({super.key, required this.portfolio});

  final Portfolio portfolio;

  @override
  Widget build(BuildContext context) {
    double margin =  10.0;
    return Container( 
      decoration: BoxDecoration(
        borderRadius: Constants.defaultBorderRadiusButton,
        color: Colors.white,
      ),
      // width: maxWidth,
      padding: EdgeInsets.symmetric(vertical: margin * 2.5, horizontal: margin * 2.5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: margin / 2),
            child: AspectRatio(
              aspectRatio: 3/4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(portfolio.imageUrl, fit: BoxFit.cover),
              ),
            )
          ),
          Container(
            margin: EdgeInsets.only(top: margin),
            child: Text(portfolio.caption!, 
              textAlign: TextAlign.justify,
              style: const TextStyle(color: Colors.black87, fontSize: 18.0)
            ),
          )
        ],
      )
    );
  }
}
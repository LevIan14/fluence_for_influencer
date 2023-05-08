import 'package:auto_localization/auto_localization.dart';
import 'package:fluence_for_influencer/models/influencer.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/util/date_utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

class ProfileMenuInsights extends StatelessWidget {
  const ProfileMenuInsights({super.key, required this.title, required this.influencer});

  final String title;
  final Influencer influencer;


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
            margin: EdgeInsets.only(bottom: margin / 2),
            child: Text(title, 
              style: const TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.w600, fontSize: 20.0)
            ),
          ),
          FutureBuilder(
            future: translate(influencer.topAudienceCity!),
            builder: (context, AsyncSnapshot snapshot) {
              if(snapshot.hasData) return InstagramAudience(context, influencer, snapshot.data);
              return Container();
          }),
          // InstagramAudience(context, influencer),
          InstagramInsight(influencer),
        ],
      )
    );
  }

  Future<List<String>> translate(cities) async {
    List<String> translated = [];
    // var local = await ;
    cities.forEach((city) async {
      String translate = await AutoLocalization.translate(city, startingLanguage: 'en', targetLanguage: 'id');
      translated.add(translate);
      
    });
    return translated;
  }

  Widget InstagramAudience(context, Influencer influencer, List<String> translateCity) {
    double margin = 10.0;
    // List<String> cities = await translate(influencer.topAudienceCity!);
    List<String> cities = translateCity;
    List<Widget> citiesWidget = [];

    cities.forEach((city) {
      citiesWidget.add(
        Container(
          margin: EdgeInsets.symmetric(vertical: margin / 4),
          child: Row(
            children: [
              const Icon(
                Ionicons.location_outline,
                color: Color.fromARGB(129, 162, 0, 32),
                size: 18.0),
              Container(
                margin: EdgeInsets.only(left: margin), 
                child: Text(city,
                      style: TextStyle(
                      color:Constants.primaryColor.withOpacity(0.5),
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0
                    )
                )
                // child: AutoLocalBuilder(
                //   text: cities,
                //   builder: (TranslationWorker tw) {
                //     return Text(tw.get(city),
                //       style: TextStyle(
                //       color:Constants.primaryColor.withOpacity(0.5),
                //       fontWeight: FontWeight.w500,
                //       fontSize: 16.0
                //     )
                //     );
                //   }
                // )
              ),
            ],
          )
        )
      );
    });
    return Container(
      margin: EdgeInsets.symmetric(vertical: margin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            margin: EdgeInsets.symmetric(vertical: margin / 2),
            child: const Text('Kota Audiens Teratas', 
              textAlign: TextAlign.justify,
              style: TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.w500, fontSize: 18.0)
            ),
          ),
          Localizations.override(
            context: context,
            locale: const Locale('id'),
            child: Builder(
              builder: (context) {
                return Column(
                  children: citiesWidget,
                );
              }
            )
          )
          
          // Column(
          //   children: citiesWidget,
          // )
        ],
      ),
    );
  }

  Widget InstagramInsight(Influencer influencer) {
    double margin = 10.0;
    DateTime now = DateTime.now();
    DateTime fourWeeksAgo = now.subtract(const Duration(days: 28));
    DateTime prevNow = fourWeeksAgo.subtract(const Duration(days: 1));
    DateTime prevFourWeeksAgo = prevNow.subtract(const Duration(days: 28));
    String since = DateUtil.insightDate(fourWeeksAgo);
    String until = DateUtil.insightDate(now);
    String prevSince = DateUtil.insightDate(prevFourWeeksAgo);
    String prevUntil = DateUtil.insightDate(prevNow);
    double reachPercent = ((influencer.fourWeekReach! - influencer.previousReach!) / influencer.previousReach!) * 100;
    double impressionPercent = ((influencer.fourWeekImpressions! - influencer.previousImpressions!) / influencer.previousImpressions!) * 100;
    return 
        Container(
          margin: EdgeInsets.symmetric(vertical: margin),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Data Analitik', 
                    style: TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.w600, fontSize: 18.0)
                  ), 
                  Text('$since - $until', 
                    style: TextStyle(color: Constants.primaryColor.withOpacity(0.5), fontWeight: FontWeight.w500, fontSize: 14.0)
                  ), 
                ],
              ), 
              Container(
                margin: EdgeInsets.symmetric(vertical: margin / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: margin / 5),
                      child: Text('Total Jangkauan', 
                        style: TextStyle(color: Constants.primaryColor.withOpacity(0.9), fontWeight: FontWeight.w500, fontSize: 16.0)
                      ),
                    ),
                    Container(
                      // margin: EdgeInsets.symmetric(vertical: margin / 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: margin / 2),
                            child: Text('${influencer.fourWeekReach}', 
                              style: TextStyle(color: Constants.primaryColor, fontSize: 15.0)
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: margin / 2),
                            child: Text(reachPercent < 0 ? '${reachPercent.toStringAsPrecision(2)}%  $prevSince - $prevUntil' : 
                              "+${reachPercent.toStringAsPrecision(2)}%  $prevSince - $prevUntil", 
                              style: TextStyle(color: reachPercent < 0 ? Constants.grayColor : Colors.green.shade400, fontSize: 14.0)
                            )
                          ),
                        ],
                      ),
                    ),
                  ]
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: margin / 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: margin / 5),
                      child: Text('Total Impresi', 
                        style: TextStyle(color: Constants.primaryColor.withOpacity(0.9), fontWeight: FontWeight.w500, fontSize: 16.0)
                      ),
                    ),
                    Container(
                      // margin: EdgeInsets.symmetric(vertical: margin / 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: margin / 2),
                            child: Text('${influencer.fourWeekImpressions}', 
                              style: TextStyle(color: Constants.primaryColor, fontSize: 15.0)
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: margin / 2),
                            child: Text(impressionPercent < 0 ? '${impressionPercent.toStringAsPrecision(2)}%  $prevSince - $prevUntil' : 
                              "+${impressionPercent.toStringAsPrecision(2)}%  $prevSince - $prevUntil", 
                              style: TextStyle(color: impressionPercent < 0 ? Constants.grayColor : Colors.green.shade400, fontSize: 14.0)
                            )
                          ),
                        ],
                      ),
                    ),
                  ]
                ),
              ),
            ],
          )
        );
    //   ],
    // );
  }
}

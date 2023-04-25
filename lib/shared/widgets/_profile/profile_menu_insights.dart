import 'package:fluence_for_influencer/models/influencer.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
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
              style: const TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.w600, fontSize: 22.0)
            ),
          ),
          InstagramAudience(influencer),
          InstagramInsight(influencer),
        ],
      )
    );
  }

  Widget InstagramAudience(Influencer influencer) {
    double margin = 10.0;
    List<String> cities = influencer.topAudienceCity!;
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
            child: const Text('Top Audience City', 
              textAlign: TextAlign.justify,
              style: TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.w500, fontSize: 18.0)
            ),
          ),
          Column(
            children: citiesWidget,
          )
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
    String since = DateFormat.MMMd().format(fourWeeksAgo);
    String until = DateFormat.MMMd().format(now);
    String prevSince = DateFormat.MMMd().format(prevFourWeeksAgo);
    String prevUntil = DateFormat.MMMd().format(prevNow);
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
                  const Text('Insights', 
                    style: TextStyle(color: Constants.primaryColor, fontWeight: FontWeight.w600, fontSize: 20.0)
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
                      child: Text('Total Reach', 
                        style: TextStyle(color: Constants.primaryColor.withOpacity(0.9), fontWeight: FontWeight.w500, fontSize: 18.0)
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
                              style: TextStyle(color: Constants.primaryColor, fontSize: 16.0)
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: margin / 2),
                            child: Text(reachPercent < 0 ? '${reachPercent.toStringAsPrecision(2)}% vs $prevSince - $prevUntil' : 
                              "+${reachPercent.toStringAsPrecision(2)}% $prevSince - $prevUntil", 
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
                      child: Text('Total Impressions', 
                        style: TextStyle(color: Constants.primaryColor.withOpacity(0.9), fontWeight: FontWeight.w500, fontSize: 18.0)
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
                              style: TextStyle(color: Constants.primaryColor, fontSize: 16.0)
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: margin / 2),
                            child: Text(impressionPercent < 0 ? '${impressionPercent.toStringAsPrecision(2)}% vs $prevSince - $prevUntil' : 
                              "+${impressionPercent.toStringAsPrecision(2)}% $prevSince - $prevUntil", 
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

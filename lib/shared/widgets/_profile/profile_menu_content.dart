import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ProfileMenuContent extends StatefulWidget {
  const ProfileMenuContent(
      {super.key, required this.title, required this.content});

  final String title;
  final String content;

  @override
  State<ProfileMenuContent> createState() => _ProfileMenuContentState();
}

class _ProfileMenuContentState extends State<ProfileMenuContent> {
  @override
  Widget build(BuildContext context) {
    double margin = 10.0;
    return Container(
        decoration: BoxDecoration(
          borderRadius: Constants.defaultBorderRadiusButton,
          color: Colors.white,
        ),
        width: double.infinity,
        padding: EdgeInsets.symmetric(
            vertical: margin * 2.5, horizontal: margin * 2.5),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: margin),
              child: Text(widget.title,
                  style: const TextStyle(
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 22.0)),
            ),
            Text(widget.content,
                textAlign: TextAlign.justify,
                style: const TextStyle(
                    color: Constants.primaryColor, fontSize: 18.0))
          ],
        ));
  }
}

import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:flutter/material.dart';

class ProfileMenuButton extends StatefulWidget {
  const ProfileMenuButton({super.key, required this.title, required this.tab, required this.active, required this.onTapMenu});

  final String title;
  final int tab;
  final bool active;
  final Function(dynamic) onTapMenu;

  @override
  State<ProfileMenuButton> createState() => _ProfileMenuButtonState();
}

class _ProfileMenuButtonState extends State<ProfileMenuButton> {
  @override
  Widget build(BuildContext context) {
    Color buttonColor = widget.active == true ? Constants.primaryColor : Constants.secondaryColor;
    Color textColor = widget.active == true ? Colors.white : Constants.grayColor;
    FontWeight textWeight = widget.active == true ? FontWeight.bold : FontWeight.normal;
    return InkWell(
      onTap: () => widget.onTapMenu(widget.tab),
      child: Container(
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: Constants.defaultBorderRadiusButton,
        ),
        padding: Constants.defaultPaddingButton,
        child: Text(widget.title, 
          style: TextStyle(
            color: textColor,
            fontWeight: textWeight,
            fontSize: 16.0,
          ),
        ),
      ),
    );
  }
}
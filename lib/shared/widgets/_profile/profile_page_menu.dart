import 'dart:developer';

import 'package:fluence_for_influencer/models/influencer.dart';
import 'package:flutter/material.dart';

import 'profile_menu_button.dart';

class ProfilePageMenu extends StatefulWidget {
  const ProfilePageMenu({super.key, required this.currentTab, required this.onTapMenu});

  final int currentTab;
  final Function(dynamic) onTapMenu;

  @override
  State<ProfilePageMenu> createState() => _ProfilePageMenuState();
}

class _ProfilePageMenuState extends State<ProfilePageMenu> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ProfileMenuButton(title: 'Description', tab: 0, active: widget.currentTab == 0, onTapMenu: widget.onTapMenu),
        ProfileMenuButton(title: 'Portofolio', tab: 1, active: widget.currentTab == 1, onTapMenu: widget.onTapMenu),
        ProfileMenuButton(title: 'Reviews', tab: 2, active: widget.currentTab == 2, onTapMenu: widget.onTapMenu),
      ],
    );
  }
}
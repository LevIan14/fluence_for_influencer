import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class InfluencerSettingPage extends StatefulWidget {
  const InfluencerSettingPage({super.key});

  @override
  State<InfluencerSettingPage> createState() => _InfluencerSettingPageState();
}

class _InfluencerSettingPageState extends State<InfluencerSettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting Page'),
        backgroundColor: Constants.primaryColor,
      ),
    );
  }
}

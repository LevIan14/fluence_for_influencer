import 'package:fluence_for_influencer/models/portfolio.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class EditPortfolioPage extends StatefulWidget {
  
  EditPortfolioPage({super.key, required this.portfolio});

  Portfolio portfolio;

  @override
  State<EditPortfolioPage> createState() => _EditPortfolioPageState();
}

class _EditPortfolioPageState extends State<EditPortfolioPage> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
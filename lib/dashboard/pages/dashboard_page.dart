import 'package:fluence_for_influencer/agreement/pages/agreement_list_page.dart';
import 'package:fluence_for_influencer/auth/bloc/auth_bloc.dart';
import 'package:fluence_for_influencer/auth/pages/login_page.dart';
import 'package:fluence_for_influencer/negotiation/pages/negotiation_detail_page.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/transaction/pages/transaction_list_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is UnAuthenticated) {
        navigateAsFirstScreen(context, const LoginPage());
      }
    }, builder: (context, state) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
          actions: [
            GestureDetector(
              onTap: () {
                BlocProvider.of<AuthBloc>(context).add(LogoutRequested());
              },
              child: const Icon(Icons.logout),
            )
          ],
        ),
        body: const DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
            appBar: TabBar(
              labelColor: Constants.primaryColor,
              indicatorColor: Constants.primaryColor,
              tabs: [
                Tab(
                  text: "Agreements",
                ),
                Tab(
                  text: "Transactions",
                )
              ],
            ),
            body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                children: [AgreementListPage(), TransactionListPage()]),
          ),
        ),
      );
    });
  }
}

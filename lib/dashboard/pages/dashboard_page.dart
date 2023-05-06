import 'package:fluence_for_influencer/agreement/pages/agreement_list_page.dart';
import 'package:fluence_for_influencer/auth/bloc/auth_bloc.dart';
import 'package:fluence_for_influencer/auth/pages/login_page.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/transaction/pages/transaction_list_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Fluence for Influencers"),
        actions: [
          IconButton(
            icon: const Icon(Ionicons.log_out_outline),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(LogoutRequested());
            },
          ),
        ],
        backgroundColor: Constants.primaryColor,
      ),
      body: BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
        if (state is UnAuthenticated) {
          navigateAsFirstScreen(context, const LoginPage());
        }
      }, builder: (context, state) {
        return const DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Scaffold(
            appBar: TabBar(
              labelColor: Constants.primaryColor,
              indicatorColor: Constants.primaryColor,
              tabs: [
                Tab(
                  text: "Persetujuan",
                ),
                Tab(
                  text: "Transaksi",
                )
              ],
            ),
            body: TabBarView(
                children: [AgreementListPage(), TransactionListPage()]),
          ),
        );
      }),
    );
  }
}

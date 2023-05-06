import 'package:fluence_for_influencer/chat/pages/chat_list_page.dart';
import 'package:fluence_for_influencer/dashboard/pages/dashboard_page.dart';
import 'package:fluence_for_influencer/influencer/pages/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    const DashboardPage(),
    const ChatListPage(),

    InfluencerProfilePage(influencerId: FirebaseAuth.instance.currentUser!.uid),
    // const InfluencerSettingPage(),
  ];
  int currentIndexPage = 0;
  DateTime? currentBackPressTime;

  @override
  void initState() {
    super.initState();
    currentIndexPage = widget.index;
  }

  void onTap(int index) {
    setState(() {
      currentIndexPage = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: Container(child: pages[currentIndexPage]),
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTap,
          currentIndex: currentIndexPage,
          selectedItemColor: Constants.primaryColor,
          unselectedItemColor: Colors.grey.withOpacity(0.5),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
                label: 'Beranda', icon: Icon(Ionicons.home)),
            BottomNavigationBarItem(
                label: 'Pesan', icon: Icon(Ionicons.chatbox)),
            BottomNavigationBarItem(
                label: 'Profil', icon: Icon(Ionicons.person_circle)),
          ],
        ),
      ),
    );
  }

  Future<bool> onWillPop() {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tekan kembali untuk keluar')));
      return Future.value(false);
    }
    return Future.value(true);
  }
}

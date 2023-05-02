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
    InfluencerProfilePage(influencerId: FirebaseAuth.instance.currentUser!.uid),
    // const InfluencerSettingPage(),
    const ChatListPage()
  ];
  int currentIndexPage = 0;

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
    return Scaffold(
      body: Container(child: pages[currentIndexPage]),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTap,
        currentIndex: currentIndexPage,
        selectedItemColor: Constants.primaryColor,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        showUnselectedLabels: true,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(label: 'Home', icon: Icon(Ionicons.home)),
          BottomNavigationBarItem(label: 'Setting', icon: Icon(Icons.settings)),
          BottomNavigationBarItem(label: 'Chat', icon: Icon(Icons.chat)),
        ],
      ),
    );
  }
}

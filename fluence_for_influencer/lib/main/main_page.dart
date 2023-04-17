import 'package:fluence_for_influencer/chat/pages/chat_list_page.dart';
import 'package:fluence_for_influencer/dashboard/pages/dashboard_page.dart';
import 'package:fluence_for_influencer/influencer/pages/influencer_setting_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List pages = [
    const DashboardPage(),
    const InfluencerSettingPage(),
    const ChatListPage()
  ];
  int currentIndexPage = 0;

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
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.grey.withOpacity(0.5),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: const [
          BottomNavigationBarItem(label: 'List', icon: Icon(Icons.chat)),
          BottomNavigationBarItem(
              label: 'Negotiation', icon: Icon(Icons.settings)),
          BottomNavigationBarItem(label: 'Chat', icon: Icon(Icons.chat)),
        ],
      ),
    );
  }
}

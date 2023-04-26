import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluence_for_influencer/chat/bloc/chat_bloc.dart';
import 'package:fluence_for_influencer/influencer/bloc/influencer_bloc.dart';
import 'package:fluence_for_influencer/influencer/pages/edit_profile_page.dart';
import 'package:fluence_for_influencer/influencer/pages/widget_portfolio.dart';
import 'package:fluence_for_influencer/influencer/pages/upload_portfolio_page.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/models/influencer.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/app_profile_avatar.dart';
import 'package:fluence_for_influencer/shared/widgets/_profile/profile_page_menu.dart';
import 'package:fluence_for_influencer/shared/widgets/_profile/profile_menu_content.dart';
import 'package:fluence_for_influencer/shared/widgets/_profile/profile_menu_insights.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key, required this.influencerId});

  final String influencerId;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  late final InfluencerBloc influencerBloc;
  final InfluencerRepository influencerRepository = InfluencerRepository();
  late Influencer influencer;
  int currentTab = 0;
  bool verified = false;

  @override
  void initState() {
    super.initState();
    String influencerId = widget.influencerId;
    influencerBloc = InfluencerBloc(influencerRepository: influencerRepository);
    influencerBloc.add(GetInfluencerDetail(influencerId));
  }

  setInfluencerData(Influencer i) {
    setState(() {
      influencer = i;
      if (i.facebookAccessToken != null && i.instagramUserId != null) {
        log('${i.facebookAccessToken} ${i.instagramUserId}');
        verified = true;
      }
    });
  }

  onChangeTab(tab) {
    setState(() {
      currentTab = tab;
    });
  }

  navigateToUploadPortfolio(img) {
    nextScreen(context, InfluencerUploadPortfolio(img: img));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InfluencerBloc>(create: (context) => influencerBloc),
      ],
      child: BlocConsumer<InfluencerBloc, InfluencerState>(
        listener: (context, state) {
          if (state is InfluencerLoaded) {
            setInfluencerData(state.influencer);
          }
        },
        builder: (context, state) {
          if (state is InfluencerLoaded) {
            return Scaffold(
              appBar: buildAppBar(context),
              body: buildBody(context),
              floatingActionButton: currentTab == 1
                  ? FloatingActionButton(
                      backgroundColor: Color.fromARGB(255, 255, 234, 240),
                      onPressed: () async {
                        String loggedInUser =
                            Constants.firebaseAuth.currentUser!.uid;
                        XFile? img = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (img == null) return;
                        navigateToUploadPortfolio(img);
                      },
                      child: Container(
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(.1),
                              blurRadius: 15.0,
                              spreadRadius: 0.0,
                              offset: const Offset(
                                0.0,
                                5.0,
                              )),
                        ]),
                        child: const Icon(Ionicons.add_outline,
                            color: Constants.primaryColor),
                      ),
                      // const Text("Contact", style: TextSty
                      //le(color: Colors.white))
                    )
                  : null,
            );
          }
          return Scaffold(
              appBar: buildAppBar(context),
              body: Container(
                decoration:
                    const BoxDecoration(color: Constants.backgroundColor),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                child: const CircularProgressIndicator(),
              ));
        },
      ),
    );
  }

  AppBar buildAppBar(context) {
    final Size size = MediaQuery.of(context).size;
    return AppBar(
      iconTheme: const IconThemeData(color: Constants.primaryColor),
      elevation: 0,
      backgroundColor: Constants.backgroundColor,
      actions: [
        IconButton(
          icon: const Icon(Ionicons.settings_outline, size: 27.0),
          tooltip: "Settings",
          onPressed: () {
            showModalBottomSheet<dynamic>(
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15.0)),
                ),
                isScrollControlled: true,
                isDismissible: true,
                context: context,
                builder: (context) {
                  TextStyle textStyle = const TextStyle(
                    color: Colors.black87,
                    fontSize: 18.0,
                  );
                  return Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(Ionicons.pencil,
                              color: Colors.grey.shade600),
                          title: Text("Edit Profile", style: textStyle),
                          onTap: () {
                            Navigator.pop(context);
                            nextScreen(context, const EditProfilePage());
                          },
                        ),
                        ListTile(
                          leading: Icon(Ionicons.key_outline,
                              color: Colors.grey.shade600),
                          title: Text("Change Password", style: textStyle),
                          onTap: () {
                            // nextScreen(context, const EditProfilePage());
                          },
                        ),
                        ListTile(
                          leading: Icon(Ionicons.log_out_outline,
                              color: Colors.grey.shade600),
                          title: Text("Logout", style: textStyle),
                          onTap: () {
                            // nextScreen(context, const EditProfilePage());
                          },
                        )
                      ],
                    ),
                  );
                });
          },
        )
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    double margin = 10.0;
    return SingleChildScrollView(
      child: Container(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        padding: EdgeInsets.symmetric(horizontal: margin * 2),
        decoration: const BoxDecoration(color: Constants.backgroundColor),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            ProfilePageHeader(influencer, verified),
            ProfilePageMenu(currentTab: currentTab, onTapMenu: onChangeTab),
            ProfilePageMenuContent(context, influencer, currentTab, verified),
          ],
        ),
      ),
    );
  }
}

Widget ProfilePageHeader(Influencer influencer, bool verifiedStatus) {
  double margin = 10.0;
  Widget verifiedWidget = verifiedStatus
      ? Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(left: margin / 2),
          child: const Image(
            image: AssetImage('assets/verified.png'),
            height: 28,
            width: 28,
          ),
        )
      : Container();
  Widget followersCountWidget = verifiedStatus
      ? Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(
              // decoration: BoxDecoration(color: Constants.primaryColor),
              margin: EdgeInsets.only(right: margin / 2),
              child: Text("${influencer.followersCount} Followers",
                  style: const TextStyle(
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0)),
            ),
            Container(
                margin: EdgeInsets.only(right: margin / 2),
                child: const Text("·",
                    style: TextStyle(
                      color: Color.fromARGB(129, 162, 0, 32),
                      fontSize: 20.0,
                    ))),
          ],
        )
      : Container();

  return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
    double parentWidth = constraints.maxWidth;
    return Container(
        width: parentWidth,
        margin: EdgeInsets.only(bottom: margin / 2),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppProfileAvatar(
                verticalMargin: margin,
                parentWidth: parentWidth,
                avatarUrl: influencer.avatarUrl),
            Container(
                margin: EdgeInsets.symmetric(vertical: margin),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(influencer.fullname,
                          style: const TextStyle(
                              color: Constants.primaryColor,
                              fontWeight: FontWeight.w700,
                              fontSize: 23.0)),
                      verifiedWidget,
                    ])),
            Container(
              margin: EdgeInsets.only(bottom: margin),
              height: 20.0,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    followersCountWidget,
                    Container(
                      // decoration: BoxDecoration(color: Constants.primaryColor),
                      // margin: EdgeInsets.only(left: margin / 2),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Ionicons.location_outline,
                                color: Color.fromARGB(129, 162, 0, 32),
                                size: 18.0),
                            Container(
                                margin: EdgeInsets.only(left: margin / 3),
                                child: Text(influencer.location,
                                    style: const TextStyle(
                                        color: Color.fromARGB(129, 162, 0, 32),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0)))
                          ]),
                    )
                  ]),
            )
          ],
        ));
  });
}

// Widget ProfileAvatar(double verticalMargin, double parentWidth) {
//   return Container(
//     margin: EdgeInsets.symmetric(vertical: verticalMargin),
//     child:
//         // FutureBuilder(
//         // future: _avatar,
//         // builder: (context, snapshot) {
//         //   if(snapshot.connectionState == ConnectionState.done){
//         // return
//         Container(
//       width: parentWidth * 0.3,
//       height: parentWidth * 0.3,
//       child: CircleAvatar(
//         radius: 14,
//         backgroundImage: NetworkImage(
//           widget.influencer.avatarUrl,
//         ),
//       ),
//     ),
// }
//   if(snapshot.connectionState == ConnectionState.waiting){
//     return Container(
//       width: parentWidth * 0.15,
//       height: parentWidth * 0.15,
//       child: CircularProgressIndicator(),
//     );
//   }
//   return Container();
// },
//   );
// }

Widget ProfilePageMenuContent(BuildContext context, Influencer influencer,
    int currentTab, bool verifiedStatus) {
  List<Widget> rawWidgets = [];
  List<Widget> finalWidgets = [];
  late Widget contentWidget;
  Widget emptyContent = Container(
      child: Container(
    padding: EdgeInsets.symmetric(vertical: 10.0),
    alignment: Alignment.center,
    child: Text("There is no data to show.",
        style: TextStyle(
            color: Constants.grayColor,
            fontSize: 16.0,
            fontStyle: FontStyle.italic)),
  ));
  String content =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Velit sed ullamcorper morbi tincidunt ornare massa. Vulputate sapien nec sagittis aliquam malesuada bibendum arcu vitae elementum. Tellus cras adipiscing enim eu turpis egestas pretium aenean pharetra. Ullamcorper eget nulla facilisi etiam dignissim diam quis enim lobortis. Platea dictumst quisque sagittis purus sit amet volutpat consequat. Nullam eget felis eget nunc lobortis mattis aliquam. At lectus urna duis convallis. Fames ac turpis egestas integer eget aliquet. Morbi non arcu risus quis varius quam quisque.";
  double margin = 15.0;
  if (currentTab == 0) {
    rawWidgets = [
      ProfileMenuContent(title: 'About', content: content),
    ];
    if (verifiedStatus)
      rawWidgets.add(ProfileMenuInsights(
          title: 'Instagram Metrics', influencer: influencer));
  } else if (currentTab == 1) {
    rawWidgets = [];
    if (influencer.portfolio != null && influencer.portfolio!.isNotEmpty) {
      for (var portfolio in influencer.portfolio!) {
        rawWidgets.add(InfluencerPortfolio(portfolio: portfolio));
      }
    } else {
      rawWidgets.add(emptyContent);
    }
  } else if (currentTab == 2) {
    rawWidgets = [
      ProfileMenuContent(title: 'Good!', content: content),
    ];
    // if review == null,
    //  rawWidgets.add(emptyContent);
  }
  for (Widget widget in rawWidgets) {
    finalWidgets.add(Container(
      margin: EdgeInsets.only(bottom: margin),
      child: widget,
    ));
  }
  contentWidget =
      Column(mainAxisSize: MainAxisSize.max, children: finalWidgets);
  return Container(
    // constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
    margin: EdgeInsets.symmetric(vertical: margin),
    child: contentWidget,
  );
}

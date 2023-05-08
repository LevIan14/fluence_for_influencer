
import 'package:fluence_for_influencer/auth/bloc/auth_bloc.dart';
import 'package:fluence_for_influencer/auth/pages/login_page.dart';
import 'package:fluence_for_influencer/category/repository/category_repository.dart';
import 'package:fluence_for_influencer/models/category_type.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/_profile/profile_menu_button.dart';
import 'package:fluence_for_influencer/shared/widgets/_profile/profile_menu_content.dart';
import 'package:fluence_for_influencer/shared/widgets/app_profile_avatar.dart';
import 'package:fluence_for_influencer/umkm/bloc/umkm_bloc.dart';
import 'package:fluence_for_influencer/umkm/model/umkm.dart';
import 'package:fluence_for_influencer/umkm/repository/umkm_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';

class UmkmProfilePage extends StatefulWidget {
  const UmkmProfilePage({super.key, required this.umkmId});
  final String umkmId;

  @override
  State<UmkmProfilePage> createState() => _UmkmProfilePageState();
}

class _UmkmProfilePageState extends State<UmkmProfilePage> {
  late final UmkmBloc umkmBloc;
  final UmkmRepository umkmRepository = UmkmRepository();
  final CategoryRepository categoryRepository = CategoryRepository();

  int currentTab = 0;

  late Umkm umkm;

  @override
  void initState() {
    super.initState();
    umkmBloc = UmkmBloc(
        umkmRepository: umkmRepository, categoryRepository: categoryRepository);
    umkmBloc.add(GetUmkmDetail(widget.umkmId));
  }

  setUmkmData(Umkm u) {
    setState(() {
      umkm = u;
    });
  }

  onChangeTab(tab) {
    // if(tab == 1){
    //   // Tab PORTFOLIO
    //   portfolioBloc.add(GetInfluencerPortfolioList(influencer.userId));
    // }
    setState(() {
      currentTab = tab;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UmkmBloc>(create: (context) => umkmBloc),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is UnAuthenticated) {
                navigateAsFirstScreen(context, const LoginPage());
              }
            },
          )
        ],
        child: BlocConsumer<UmkmBloc, UmkmState>(
          listener: (context, state) {
            if (state is UmkmLoaded) {
              setUmkmData(state.umkm);
            }
          },
          builder: (context, state) {
            if (state is UmkmLoaded) {
              return Scaffold(
                appBar: buildAppBar(context),
                body: buildBody(context),
              );
            }
            return Scaffold(
                appBar: buildAppBar(context),
                body: Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height,
                  child: const CircularProgressIndicator(),
                ));
          },
        ),
      ),
    );
  }

  AppBar buildAppBar(context) {
    final Size size = MediaQuery.of(context).size;
    return AppBar(
      iconTheme: const IconThemeData(color: Constants.primaryColor),
      elevation: 0,
      backgroundColor: Colors.white,
    );
  }

  Widget buildBody(BuildContext context) {
    double margin = 10.0;
    return SingleChildScrollView(
      child: Container(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        padding: EdgeInsets.symmetric(horizontal: margin * 2),
        child: Column(mainAxisSize: MainAxisSize.max, children: [
          buildProfilePageHeader(),
          // buildProfilePageTab(),
          buildProfilePageContent(),
        ]),
      ),
    );
  }

  Widget buildProfilePageHeader() {
    double margin = 10.0;
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
                  avatarUrl: umkm.avatarUrl),
              Container(
                  margin: EdgeInsets.symmetric(vertical: margin),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(umkm.fullname,
                            style: const TextStyle(
                                color: Constants.primaryColor,
                                fontWeight: FontWeight.w700,
                                fontSize: 23.0)),
                      ])),
              Container(
                margin: EdgeInsets.only(bottom: margin),
                height: 20.0,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                  child: Text(umkm.location,
                                      style: const TextStyle(
                                          color:
                                              Color.fromARGB(129, 162, 0, 32),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 16.0)))
                            ]),
                      )
                    ]),
              )
            ],
          ));
    });
  }

  Widget buildProfilePageTab() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ProfileMenuButton(
            title: 'Deskripsi',
            tab: 0,
            active: currentTab == 0,
            onTapMenu: onChangeTab),
      ],
    );
  }

  Widget buildProfilePageContent() {
    Widget emptyContent = Container(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      alignment: Alignment.center,
      child: const Text(Constants.emptyListMessage,
          style: TextStyle(
              color: Constants.grayColor,
              fontSize: 16.0,
              fontStyle: FontStyle.italic)),
    );
    double margin = 15.0;
    if (currentTab == 0) {
      return buildDescriptionWidget(margin);
      // if about == null,
    } else if (currentTab == 1) {
      // return buildPortfolioWidget(margin);
    } else if (currentTab == 2) {
      // return buildReviewWidget(margin);
      // if review == null,
      //  rawWidgets.add(emptyContent);
    }
    return Container();
  }

  Widget buildDescriptionWidget(double margin) {
    List<Widget> finalWidgets = [];
    List<Widget> widgets = [
      ProfileMenuContent(title: 'Tentang Anda', content: umkm.about),
      // ProfileMenuContent(title: 'Category Type', content: influencer.categoryType),
      descriptionCategoryType(),
    ];
    for (var widget in widgets) {
      finalWidgets.add(Container(
        margin: EdgeInsets.only(bottom: margin),
        width: MediaQuery.of(context).size.width,
        child: widget,
      ));
    }
    return Container(
        // constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
        margin: EdgeInsets.symmetric(vertical: margin),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: finalWidgets,
        ));
  }

  Widget descriptionCategoryType() {
    // influencer.categoryType.join(", ");
    double margin = 10.0;
    List<Widget> categoryText = [];
    for (CategoryType category in umkm.categoryType) {
      categoryText.add(Text(category.categoryTypeName,
          textAlign: TextAlign.left,
          style:
              const TextStyle(color: Constants.primaryColor, fontSize: 18.0)));
    }
    if (umkm.customCategory.isNotEmpty) {
      categoryText.add(Text(umkm.customCategory,
          textAlign: TextAlign.left,
          style: const TextStyle(color: Constants.primaryColor, fontSize: 18)));
    }

    return Container(
        decoration: BoxDecoration(
          borderRadius: Constants.defaultBorderRadiusButton,
          color: Colors.white,
        ),
        // width: maxWidth,
        padding: EdgeInsets.symmetric(
            vertical: margin * 2.5, horizontal: margin * 2.5),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: margin),
              child: const Text('Tipe Kategori',
                  style: TextStyle(
                      color: Constants.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 22.0)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categoryText,
            ),
          ],
        ));
  }
}

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluence_for_influencer/category/repository/category_repository.dart';
import 'package:fluence_for_influencer/influencer/bloc/influencer_bloc.dart';
import 'package:fluence_for_influencer/influencer/pages/full_textfield_page.dart';
import 'package:fluence_for_influencer/influencer/pages/upload_portfolio_page.dart';
import 'package:fluence_for_influencer/influencer/pages/widget_portfolio.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/models/category_type.dart';
import 'package:fluence_for_influencer/models/influencer.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/_profile/profile_menu_content.dart';
import 'package:fluence_for_influencer/shared/widgets/_profile/profile_menu_insights.dart';
import 'package:fluence_for_influencer/shared/widgets/_profile/profile_page_menu.dart';
import 'package:fluence_for_influencer/shared/widgets/app_profile_avatar.dart';
import 'package:fluence_for_influencer/shared/widgets/text_input.dart';
import 'package:fluence_for_influencer/category/bloc/category_bloc.dart';
import 'package:fluence_for_influencer/shared/widgets/app_textfield.dart';
import 'widget_directing_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

// enum Gender { Male, Female, Unknown }

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  late final InfluencerBloc influencerBloc;
  late final CategoryBloc categoryBloc;
  final InfluencerRepository influencerRepository = InfluencerRepository();
  final CategoryRepository categoryRepository = CategoryRepository();
  
  String userId = FirebaseAuth.instance.currentUser!.uid;
  bool verified = false;
  
  late Influencer influencer;
  late final List<CategoryType> categories;
  final List<String> genders = ['Male', 'Female', 'Unknown'];

  final TextEditingController _nameController = TextEditingController();
  String? _nameValidator (String? value) {
    return value!.isEmpty ? "Name can not be null." : null;
  }
  final TextEditingController _locationController = TextEditingController();
  String? _locationValidator (String? value) {
    return value!.isEmpty ? "Location can not be null." : null;
  }
  final TextEditingController _aboutController = TextEditingController();
  String? _aboutValidator (String? value) {
    return null;
  }
  final TextEditingController _noteAgreementController = TextEditingController();
  String? _noteAgreementValidator (String? value) {
    return value!.isEmpty ? "Note agreement can not be null." : null;
  }

  // late Gender _selectedGender;
  final TextEditingController _genderController = TextEditingController();
  List<CategoryType> _selectedCategory = [];
  late ImageProvider<Object> _selectedImage;

  @override
  void initState() {
    super.initState();
    influencerBloc = InfluencerBloc(influencerRepository: influencerRepository);
    categoryBloc = CategoryBloc(categoryRepository: categoryRepository);
    influencerBloc.add(GetInfluencerDetail(userId));
    categoryBloc.add(GetCategoryTypeListRequested());
  }

  setInfluencerData(Influencer i) {
    setState(() {
      influencer = i;
      if(i.facebookAccessToken != null && i.instagramUserId != null){
        verified = true;
      } 
      _selectedImage = NetworkImage(i.avatarUrl);
      _nameController.text = i.fullname;
      _genderController.text = i.gender.toString();
      _selectedCategory = i.categoryType as List<CategoryType>;
      _locationController.text = i.location;
      _aboutController.text = i.about;
      _noteAgreementController.text = i.noteAgreement == null ? i.noteAgreement! : "";
    });
  }

  setCategoryTypeChips(List<CategoryType> categoryList) {
    setState(() {
      categories = categoryList;
    });
  }

  onChangeAvatar(XFile img) {
    setState(() {
      _selectedImage = Image.file(File(img.path)).image;
    });
  }

  onChange(String gender){
    setState(() {
      _genderController.text = gender;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InfluencerBloc>(create: (context) => influencerBloc),
        BlocProvider<CategoryBloc>(create: (context) => categoryBloc),
      ],
      child: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if(state is CategoryLoaded) {
            setCategoryTypeChips(state.categoryList);
          }
        },
        child: BlocConsumer<InfluencerBloc, InfluencerState>(
          listener: (context, state) {
            if(state is InfluencerLoaded){
              setInfluencerData(state.influencer!);
            }
          },
          builder: (context, state) {
            if(state is InfluencerLoaded){
              return Scaffold(
                  appBar: buildAppBar(context),
                  body: buildBody(context),
              );
            }
            return Scaffold(
              appBar: buildAppBar(context),
              body: Container(
                decoration: const BoxDecoration(color: Constants.backgroundColor),
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height,
                child: const CircularProgressIndicator(),
              )
            );
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
      backgroundColor: Constants.backgroundColor,
      actions: [
        Container(
          // decoration: BoxDecoration(color: Constants.navyColor),
          // padding: const EdgeInsets.symmetric(vertical: 3.0, horizontal: 7.0),
          margin: const EdgeInsets.only(right: 15.0),
          alignment: Alignment.center,
          child: InkWell(
            onTap:() {
              // save
              // buat bloc save + repository save
              // influencerBloc.add(UploadInfluencerProfileImage(userId, img));
            },
            child: const Text("Save", style: TextStyle(fontSize: 17.0, color: Constants.primaryColor, fontWeight: FontWeight.w500))
          ),
        ),
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    double margin = 10.0;
    return SingleChildScrollView(
      child: Container(
        constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        padding: EdgeInsets.symmetric(horizontal: margin * 2),
        decoration: const BoxDecoration(color: Constants.backgroundColor),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            buildProfileAvatar(influencer),
            AppTextfield(field: "Name", fieldController: _nameController, validator: _nameValidator),
            DirectingTextfield(field: "Gender", fieldController: _genderController, onTap: () { 
              nextScreen(context, FullTextfield());
            }),
            AppTextfield(field: "Location", fieldController: _locationController, validator: _locationValidator),
            buildCategoryTypeChips(categories),
            AppTextfield(field: "About", fieldController: _aboutController, validator: _aboutValidator),
            AppTextfield(field: "Note Agreement", fieldController: _noteAgreementController, validator: _noteAgreementValidator),
          ],
        ),
      ),
    );
  }
  
  Widget buildProfileAvatar(Influencer influencer) {
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
              Container(
                margin: EdgeInsets.symmetric(vertical: margin),
                width: parentWidth * 0.3,
                height: parentWidth * 0.3,
                child:
                  Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: _selectedImage,
                      ),
                      Positioned(
                        bottom: 0,
                        right: -25,
                        child: RawMaterialButton(
                          onPressed: () {
                            showModalBottomSheet(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                              ),
                              context: context, 
                              builder: (context) {
                                TextStyle textStyle = const TextStyle(
                                  color: Colors.black87,
                                  fontSize: 18.0,
                                );
                                return Container(
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: Icon(Ionicons.image_outline, color: Colors.grey.shade600),
                                        title: Text("Choose from library", style: textStyle),
                                        onTap: () async {
                                          // bloc untuk upload influencer image
                                          XFile? img = await ImagePicker().pickImage(source: ImageSource.gallery);
                                          if(img == null) return;
                                          onChangeAvatar(img);
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      ListTile(
                                        leading: Icon(Ionicons.trash_outline, color: Colors.grey.shade600),
                                        title: Text("Remove current profile picture", style: textStyle),
                                        onTap: () {  
                                          // bloc untuk remove
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                            );
                          },
                          elevation: 2.0,
                          fillColor: Color(0xFFF5F6F9),
                          padding: EdgeInsets.all(8.0),
                          shape: CircleBorder(),
                          child: const Icon(Icons.camera_alt_outlined, color: Colors.grey),
                        )
                      ),
                    ]
                  ),
              ),
            ],
          ));
    });
}

  Widget buildCategoryTypeChips(List<CategoryType> categories) {
    List<Widget> widgetChips = [];
    for(CategoryType category in categories) {
      bool selected = _selectedCategory.contains(category);
      Widget chip = FilterChip(
        padding: EdgeInsets.symmetric(vertical: 13.0, horizontal: 13.0),
        labelPadding: EdgeInsets.symmetric(horizontal: 8.0),
        selectedColor: Constants.primaryColor.withOpacity(0.6),
        backgroundColor: Constants.secondaryColor.withOpacity(0.35),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0), 
          side: BorderSide(
            width: 0.5,
            color: selected 
            ? Constants.grayColor.withOpacity(0.5)
            : Constants.secondaryColor
          ), 
        ),
        elevation: selected 
        ? 0.5
        : 0,
        checkmarkColor: selected 
          ? Colors.white 
          : null,
        label: Text(category.categoryTypeName, 
          style: TextStyle(
            fontSize: 14.0, 
            color: selected 
            ? Colors.white
            : Colors.grey.shade700, 
            fontWeight: FontWeight.w400
          )
        ), 
        selected: selected,
        onSelected: (bool value) {
          setState(() {
            if(value) {
              if(!_selectedCategory.contains(category)) {
                _selectedCategory.add(category);
              }
            } else {
              if(_selectedCategory.contains(category)) {
                _selectedCategory.remove(category);
              }
            }
          });
        }
      );
      widgetChips.add(
        Container(
          margin: const EdgeInsets.only(bottom: 5.0),
          child: chip,
        )
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: const Text("Category Type",
          style:
              TextStyle(color: Constants.primaryColor, fontSize: 15),
          textAlign: TextAlign.left)
        ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10.0,
          children: widgetChips,
        ),
      ],
    );
  }
}
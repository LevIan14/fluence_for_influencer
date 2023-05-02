import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluence_for_influencer/auth/bloc/auth_bloc.dart';
import 'package:fluence_for_influencer/auth/repository/auth_repository.dart';
import 'package:fluence_for_influencer/category/repository/category_repository.dart';
import 'package:fluence_for_influencer/influencer/bloc/influencer_bloc.dart';
import 'package:fluence_for_influencer/influencer/pages/full_textfield_page.dart';
import 'package:fluence_for_influencer/portfolio/pages/upload_portfolio_page.dart';
import 'package:fluence_for_influencer/portfolio/pages/widget_portfolio.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/models/category_type.dart';
import 'package:fluence_for_influencer/models/influencer.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/app_profile_avatar.dart';
import 'package:fluence_for_influencer/shared/widgets/show_alert_dialog.dart';
import 'package:fluence_for_influencer/shared/widgets/text_input.dart';
import 'package:fluence_for_influencer/category/bloc/category_bloc.dart';
import 'package:fluence_for_influencer/shared/widgets/app_textfield.dart';
import 'package:flutter/services.dart';
import 'widget_directing_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formSettingsKey = GlobalKey<FormState>();
  late final InfluencerBloc influencerBloc;
  late final CategoryBloc categoryBloc;
  final InfluencerRepository influencerRepository = InfluencerRepository();
  final CategoryRepository categoryRepository = CategoryRepository();
  late final AuthBloc authBloc;
  final AuthRepository authRepository = AuthRepository();

  String userId = FirebaseAuth.instance.currentUser!.uid;
  bool _enableSaveBtn = true;

  late Influencer influencer;
  late final List<dynamic> categories;
  final List<String> genders = ['Male', 'Female', 'Unknown'];

  final TextEditingController _nameController = TextEditingController();
  String? _nameValidator(String? value) {
    return value!.isEmpty ? "Name can not be null." : null;
  }

  final TextEditingController _locationController = TextEditingController();
  String? _locationValidator(String? value) {
    return value!.isEmpty ? "Location can not be null." : null;
  }

  final TextEditingController _lowestFeeController = TextEditingController();
  String? _lowestFeeValidator(String? value) {
    if (value!.isEmpty) return null;
    if (_highestFeeController.value.text.isEmpty) return null;
    return int.parse(value) > int.parse(_highestFeeController.value.text)
        ? 'Lowest fee can not be higher than highest fee'
        : null;
  }

  final TextEditingController _highestFeeController = TextEditingController();
  String? _highestFeeValidator(String? value) {
    if (value!.isEmpty) return null;
    if (_lowestFeeController.value.text.isEmpty) return null;
    return int.parse(value) < int.parse(_lowestFeeController.value.text)
        ? 'Highest fee can not be lower than lowest fee'
        : null;
  }

  final TextEditingController _aboutController = TextEditingController();
  final TextEditingController _noteAgreementController =
      TextEditingController();
  final TextEditingController _genderController = TextEditingController();

  String? _currentAddress;
  Position? _currentPosition;
  List<CategoryType> _selectedCategory = [];
  XFile? _selectedImage;
  late ImageProvider<Object> _selectedImageWidget;
  bool verified = false;

  @override
  void initState() {
    super.initState();
    influencerBloc = InfluencerBloc(
        influencerRepository: influencerRepository,
        categoryRepository: categoryRepository);
    categoryBloc = CategoryBloc(categoryRepository: categoryRepository);
    authBloc = AuthBloc(authRepository: authRepository);
    influencerBloc.add(GetInfluencerDetail(userId));
    categoryBloc.add(GetCategoryTypeListRequested());
  }

  setInfluencerData(Influencer i) {
    setState(() {
      influencer = i;
      if (i.facebookAccessToken != null && i.facebookAccessToken != '' && i.instagramUserId != null && i.instagramUserId != '') {
        verified = true;
      }
      _selectedImageWidget = NetworkImage(i.avatarUrl);
      _nameController.text = i.fullname;
      _genderController.text = i.gender.toString();
      _locationController.text = i.location;
      _selectedCategory = i.categoryType as List<CategoryType>;
      _aboutController.text = i.about;
      _noteAgreementController.text =
          i.noteAgreement != null ? i.noteAgreement! : "";
      _lowestFeeController.text =
          i.lowestFee != null ? i.lowestFee.toString() : "";
      _highestFeeController.text =
          i.highestFee != null ? i.highestFee.toString() : "";
    });
  }

  setCategoryTypeChips(List<CategoryType> categoryList) {
    setState(() {
      categories = categoryList;
    });
  }

  onChangeAvatar(XFile img) {
    setState(() {
      _selectedImage = img;
      _selectedImageWidget = Image.file(File(img.path)).image;
    });
  }

  onDeleteAvatar() {
    setState(() {
      _selectedImage = XFile('');
      _selectedImageWidget = const NetworkImage('https://firebasestorage.googleapis.com/v0/b/fluence-1673609236730.appspot.com/o/dummy-profile-pic.png?alt=media&token=23db1237-3e40-4643-8af0-e63e1583e8ab');
    });
  }

  revokeFacebookAccess() {
    setState(() {
      verified = false;
      influencer.facebookAccessToken = '';
      influencer.instagramUserId = '';
    });
  }

  bool allowToPop() {
    if (influencer.fullname == _nameController.text &&
        influencer.location == _locationController.text &&
        influencer.about == _aboutController.text &&
        influencer.noteAgreement == _noteAgreementController.text &&
        influencer.gender == _genderController.text &&
        influencer.categoryType == _selectedCategory &&
        influencer.lowestFee == int.parse(_lowestFeeController.text) &&
        influencer.highestFee == int.parse(_highestFeeController.text) &&
        _selectedImage == null) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<InfluencerBloc>(create: (context) => influencerBloc),
        BlocProvider<CategoryBloc>(create: (context) => categoryBloc),
        BlocProvider<AuthBloc>(create: (context) => authBloc)
      ],
      child: BlocListener<CategoryBloc, CategoryState>(
        listener: (context, state) {
          if (state is CategoryLoaded) {
            setCategoryTypeChips(state.categoryList);
          }
        },
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if(state is FacebookCredentialSuccess) {
              influencer.facebookAccessToken = state.facebookAccessToken;
              influencer.instagramUserId = state.instagramUserId;
              setState(() {
                verified = true;
              });
            }
          },
          child: BlocConsumer<InfluencerBloc, InfluencerState>(
              listener: (context, state) {
                if (state is InfluencerLoaded) {
                  setInfluencerData(state.influencer);
                }
              },
              builder: (context, state) {
                if (state is InfluencerLoaded) {
                  return WillPopScope(
                    onWillPop: () async {
                      if (allowToPop()) return true;
                      return createWillPopDialog(context);
                    },
                    child: Scaffold(
                      appBar: buildAppBar(context),
                      body: buildBody(context),
                    ),
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
            )
          )
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
              onTap: _enableSaveBtn
                  ? () {
                      // save
                      // buat bloc save + repository save
                      influencer.fullname = _nameController.text;
                      influencer.location = _locationController.text;
                      influencer.about = _aboutController.text;
                      influencer.noteAgreement = _noteAgreementController.text;
                      influencer.gender = _genderController.text;
                      influencer.categoryType = _selectedCategory;
                      influencer.lowestFee =
                          int.parse(_lowestFeeController.text);
                      influencer.highestFee =
                          int.parse(_highestFeeController.text);
                      influencerBloc.add(UpdateInfluencerProfileSettings(
                          influencer, _selectedImage));
                      Navigator.of(context).pop();
                    }
                  : null,
              child: Text("Save",
                  style: TextStyle(
                      fontSize: 17.0,
                      color: _enableSaveBtn
                          ? Constants.primaryColor
                          : Constants.grayColor,
                      fontWeight: FontWeight.w500))),
        ),
      ],
    );
  }

  Widget buildBody(BuildContext context) {
    double margin = 10.0;
    return SingleChildScrollView(
      child: Container(
        constraints:
            BoxConstraints(minHeight: MediaQuery.of(context).size.height),
        padding: EdgeInsets.symmetric(horizontal: margin * 2, vertical: margin),
        decoration: const BoxDecoration(color: Constants.backgroundColor),
        child: Form(
          key: _formSettingsKey,
          onChanged: () {
            setState(() {
              _enableSaveBtn = _formSettingsKey.currentState!.validate();
            });
          },
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              buildProfileAvatar(influencer),
              AppTextfield(
                  field: "Name",
                  fieldController: _nameController,
                  validator: _nameValidator),
              DirectingTextfield(
                  field: "Gender",
                  fieldController: _genderController,
                  onTap: () => showGenderModal()),
              AppTextfield(
                  field: "Location",
                  fieldController: _locationController,
                  validator: _locationValidator,
                  isReadOnly: true,
                  onTap: () async => await _getCurrentPosition()),
              buildCategoryTypeChips(categories),
              DirectingTextfield(
                  field: "About",
                  fieldController: _aboutController,
                  onTap: () async {
                    final changedValue = await nextScreenAndGetValue(
                        context,
                        FullTextfieldPage(
                            field: "About", fieldController: _aboutController));
                    _aboutController.text = changedValue;
                  }),
              DirectingTextfield(
                  field: "Note Agreement",
                  fieldController: _noteAgreementController,
                  onTap: () async {
                    final changedValue = await nextScreenAndGetValue(
                        context,
                        FullTextfieldPage(
                            field: "Note Agreement",
                            fieldController: _noteAgreementController));
                    _noteAgreementController.text = changedValue;
                  }
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch, 
                  children: [
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 10),
                      child: const Text('Fee Range (in Rupiah)',
                        style: TextStyle(color: Constants.primaryColor, fontSize: 15),
                        textAlign: TextAlign.left
                      )
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          // margin: const EdgeInsets.only(right: 15.0),
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width / 2.35
                          ),
                          child: TextFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Lowest Fee',
                              errorStyle: const TextStyle(overflow: TextOverflow.visible),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: _lowestFeeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: _lowestFeeValidator,
                          ),
                        ),
                        Container(
                          // margin: const EdgeInsets.only(left: 5.0),
                          constraints: BoxConstraints(
                            minWidth: MediaQuery.of(context).size.width / 2.35
                          ),
                          child: TextFormField(
                            decoration: textInputDecoration.copyWith(
                              hintText: 'Highest Fee',
                              errorStyle: const TextStyle(overflow: TextOverflow.visible),
                            ),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: _highestFeeController,
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            validator: _highestFeeValidator,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              buildLinkedAccount(),
            ]
          ),
      ),
    ));
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
                child: Stack(
                    clipBehavior: Clip.none,
                    fit: StackFit.expand,
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: _selectedImageWidget,
                      ),
                      Positioned(
                          bottom: 0,
                          right: -25,
                          child: RawMaterialButton(
                            onPressed: () {
                              showModalBottomSheet(
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(15.0)),
                                  ),
                                  context: context,
                                  builder: (context) {
                                    TextStyle textStyle = const TextStyle(
                                      color: Colors.black87,
                                      fontSize: 18.0,
                                    );
                                    return Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15.0)),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            leading: Icon(
                                                Ionicons.image_outline,
                                                color: Colors.grey.shade600),
                                            title: Text("Choose from library",
                                                style: textStyle),
                                            onTap: () async {
                                              // bloc untuk upload influencer image
                                              XFile? img = await ImagePicker()
                                                  .pickImage(
                                                      source:
                                                          ImageSource.gallery);
                                              if (img == null) return;
                                              onChangeAvatar(img);
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(
                                                Ionicons.trash_outline,
                                                color: Colors.red),
                                            title: Text(
                                                "Remove current profile picture",
                                                style: textStyle.copyWith(
                                                    color: Colors.red)),
                                            onTap: () {
                                              onDeleteAvatar();
                                              Navigator.pop(context);
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            elevation: 2.0,
                            fillColor: Color(0xFFF5F6F9),
                            padding: EdgeInsets.all(8.0),
                            shape: CircleBorder(),
                            child: const Icon(Icons.camera_alt_outlined,
                                color: Colors.grey),
                          )),
                    ]),
              ),
            ],
          ));
    });
  }

  Widget buildCategoryTypeChips(List<dynamic> categories) {
    List<Widget> widgetChips = [];
    for (var category in categories) {
      bool selected = _selectedCategory
          .any((element) => element.categoryTypeId == category.categoryTypeId);
      Widget chip = FilterChip(
          padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 13.0),
          labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
          selectedColor: Constants.primaryColor.withOpacity(0.6),
          backgroundColor: Constants.secondaryColor.withOpacity(0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(
                width: 0.5,
                color: selected
                    ? Constants.grayColor.withOpacity(0.5)
                    : Constants.secondaryColor),
          ),
          elevation: selected ? 0.5 : 0,
          checkmarkColor: selected ? Colors.white : null,
          label: Text(category.categoryTypeName,
              style: TextStyle(
                  fontSize: 14.0,
                  color: selected ? Colors.white : Colors.grey.shade700,
                  fontWeight: FontWeight.w400)),
          selected: selected,
          onSelected: (bool value) {
            setState(() {
              if (value) {
                if (!_selectedCategory.contains(category)) {
                  _selectedCategory.add(category);
                }
              } else {
                if (_selectedCategory.contains(category)) {
                  _selectedCategory.remove(category);
                }
              }
            });
          });
      widgetChips.add(Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: chip,
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: const Text("Category Type",
                style: TextStyle(color: Constants.primaryColor, fontSize: 15),
                textAlign: TextAlign.left)),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10.0,
          children: widgetChips,
        ),
      ],
    );
  }

  Widget buildLinkedAccount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch, 
      children: [
        Container(
          margin: const EdgeInsets.only(top: 15.0, bottom: 10.0),
          child: const Text('Linked Accounts',
              style: TextStyle(color: Constants.primaryColor, fontSize: 17, fontWeight: FontWeight.w600),
              textAlign: TextAlign.left)
        ),
        GestureDetector(
          onTap: () {
            if(verified) {
              showModalBottomSheet(
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
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15.0)),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: Icon(Ionicons.pencil_outline, color: Colors.grey.shade600),
                            title: Text("Reconnect to Facebook", style: textStyle),
                            onTap: () {
                              Navigator.pop(context);
                              authBloc.add(FacebookCredentialRequested(influencer.userId));
                            },
                          ),
                          ListTile(
                            leading: const Icon(Ionicons.trash_outline, color: Colors.red),
                            title: Text("Revoke Facebook access", style: textStyle.copyWith(color: Colors.red)),
                            onTap: () {
                              revokeFacebookAccess();
                              Navigator.pop(context);
                            },
                          ),
                        ]
                      )
                    );
                }
              );
            }
            else {
              authBloc.add(FacebookCredentialRequested(influencer.userId));
            }
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Padding(
                        padding: EdgeInsets.only(right: 10.0),
                        child: Image(
                          image: AssetImage('assets/facebook_logo.png'),
                          height: 25,
                          width: 25,
                        ),
                      ),
                      Text('Facebook',
                        style: TextStyle(color: Constants.primaryColor, fontSize: 15),
                        textAlign: TextAlign.left
                      ),
                    ]
                  )
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(verified ? 'Connected' : 'Not connected', style: const TextStyle(color: Constants.grayColor, fontSize: 15.0)),
                      const Padding(
                        padding: EdgeInsets.only(left: 10.0),
                        child: Icon(Ionicons.chevron_forward_outline, color: Constants.grayColor),
                      ),
                    ]
                  )
                ),
              ],
            )
          ),
        ),

      ]
    );
  }

  void showGenderModal() {
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
        ),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          TextStyle textStyle = const TextStyle(
            color: Colors.black87,
            fontSize: 18.0,
          );
          List<Widget> radios = [];
          for (var gender in genders) {
            radios.add(RadioListTile(
                title: Text(gender, style: textStyle),
                value: gender,
                groupValue: _genderController.text,
                onChanged: (value) {
                  setState(() {
                    _genderController.text = value.toString();
                  });
                  Navigator.pop(context);
                }));
          }
          ;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: radios,
            ),
          );
        });
  }

  _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }

    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> _getCurrentPosition() async {
    final hasPermission = await _handleLocationPermission();
    if (!hasPermission) return;
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      setState(() => _currentPosition = position);
      _getAddressFromLatLng(_currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<void> _getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            _currentPosition!.latitude, _currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        // _currentAddress =
        //     '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
        _currentAddress = place.subAdministrativeArea;
        log(_currentAddress.toString());
        _locationController.text = _currentAddress!;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> createWillPopDialog(context) async {
    Text dialogTitle = const Text("Discard changes?");
    Text dialogContent =
        const Text("If you go back now, you will lose your changes.");
    TextButton discardButton = TextButton(
      child: Text("Discard changes"),
      onPressed: () {
        Navigator.pop(context, true);
      },
    );
    TextButton cancelButton = TextButton(
      child: Text("Continue editing"),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    final bool resp = await showDialog(
        context: context,
        builder: (context) => showAlertDialog(
            context, dialogTitle, dialogContent, discardButton, cancelButton));
    if (!resp) return false;
    return true;
  }
}

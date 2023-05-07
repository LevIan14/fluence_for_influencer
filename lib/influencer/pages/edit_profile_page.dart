import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluence_for_influencer/auth/bloc/auth_bloc.dart';
import 'package:fluence_for_influencer/auth/repository/auth_repository.dart';
import 'package:fluence_for_influencer/category/bloc/category_bloc.dart';
import 'package:fluence_for_influencer/category/repository/category_repository.dart';
import 'package:fluence_for_influencer/influencer/bloc/influencer_bloc.dart';
import 'package:fluence_for_influencer/influencer/pages/full_textfield_page.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/models/category_type.dart';
import 'package:fluence_for_influencer/models/influencer.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/app_textfield.dart';
import 'package:fluence_for_influencer/shared/widgets/select_type_page.dart';
import 'package:fluence_for_influencer/shared/widgets/show_alert_dialog.dart';
import 'package:fluence_for_influencer/shared/widgets/snackbar_widget.dart';
import 'package:fluence_for_influencer/shared/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';
import 'package:fluence_for_influencer/shared/widgets/widgets.dart';

import 'widget_directing_textfield.dart';

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
  late final List<CategoryType> categories;
  final List<String> genders = ['Pria', 'Wanita', 'Tidak Diketahui'];

  final TextEditingController _nameController = TextEditingController();
  String? _nameValidator(String? value) {
    return value!.isEmpty ? "Masukkan nama" : null;
  }

  final TextEditingController _locationController = TextEditingController();
  String? _locationValidator(String? value) {
    return value!.isEmpty ? "Masukkan lokasi" : null;
  }

  final TextEditingController _lowestFeeController = TextEditingController();
  String? _lowestFeeValidator(String? value) {
    if (value!.isEmpty) return "Masukkan harga terendah";
    if (_highestFeeController.value.text.isEmpty) return null;
    return int.parse(value) > int.parse(_highestFeeController.value.text)
        ? 'Harga tidak valid'
        : null;
  }

  final TextEditingController _highestFeeController = TextEditingController();
  String? _highestFeeValidator(String? value) {
    if (value!.isEmpty) return "Masukkan harga tertinggi";
    if (_lowestFeeController.value.text.isEmpty) return null;
    return int.parse(value) < int.parse(_lowestFeeController.value.text)
        ? 'Harga tidak valid'
        : null;
  }

  final TextEditingController _bankAccountController = TextEditingController();
  String? _bankAccountValidator(String? value) {
    if (value!.isEmpty) return "Pilih akun bank";
    return null;
  }

  final TextEditingController _bankAccountNameController =
      TextEditingController();
  String? _bankAccountNameValidator(String? value) {
    if (value!.isEmpty) return "Masukkan nama pemilik rekening";
    return null;
  }

  final TextEditingController _bankAccountNumberController =
      TextEditingController();
  String? _bankAccountNumberValidator(String? value) {
    if (value!.isEmpty) return "Masukkan nomor rekening";
    return null;
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
      if (i.facebookAccessToken != null &&
          i.facebookAccessToken != '' &&
          i.instagramUserId != null &&
          i.instagramUserId != '') {
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
      _bankAccountController.text = i.bankAccount;
      _bankAccountNameController.text = i.bankAccountName;
      _bankAccountNumberController.text = i.bankAccountNumber;

      if (i.customCategory.isNotEmpty) {
        CategoryType othersCategoryType = CategoryType("", i.customCategory);
        _selectedCategory.add(othersCategoryType);
      }
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
      _selectedImageWidget = const NetworkImage(
          'https://firebasestorage.googleapis.com/v0/b/fluence-1673609236730.appspot.com/o/dummy-profile-pic.png?alt=media&token=23db1237-3e40-4643-8af0-e63e1583e8ab');
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
        influencer.bankAccount == _bankAccountController.text &&
        influencer.bankAccountName == _bankAccountNameController.text &&
        influencer.bankAccountNumber == _bankAccountNumberController.text &&
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
            if (state is CategoryError) {
              SnackBarWidget.failed(context, state.error);
            }
          },
          child: BlocListener<AuthBloc, AuthState>(
              listener: (context, state) {
                if (state is FacebookCredentialSuccess) {
                  influencer.facebookAccessToken = state.facebookAccessToken;
                  influencer.instagramUserId = state.instagramUserId;
                  setState(() {
                    verified = true;
                  });
                }
                if (state is AuthError) {
                  SnackBarWidget.failed(context, state.error);
                }
              },
              child: BlocConsumer<InfluencerBloc, InfluencerState>(
                listener: (context, state) {
                  if (state is UpdateInfluencerProfileSuccess) {
                    Navigator.pop(context);
                    SnackBarWidget.success(context, 'Berhasil menyimpan data');
                    navigateAsFirstScreen(context, const MainPage(index: 2));
                  }
                  if (state is InfluencerLoaded) {
                    setInfluencerData(state.influencer);
                  }
                  if (state is InfluencerError) {
                    SnackBarWidget.failed(context, state.toString());
                  }
                },
                builder: (context, state) {
                  if (state is InfluencerLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
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
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height,
                        child: const CircularProgressIndicator(),
                      ));
                },
              ))),
    );
  }

  AppBar buildAppBar(context) {
    final Size size = MediaQuery.of(context).size;
    return AppBar(
      iconTheme: const IconThemeData(color: Constants.primaryColor),
      elevation: 0,
      backgroundColor: Colors.white,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 15.0),
          alignment: Alignment.center,
          child: InkWell(
              onTap: _enableSaveBtn
                  ? () {
                      saveDialog(context);
                    }
                  : null,
              child: Text("Simpan",
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
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formSettingsKey,
        onChanged: () {
          setState(() {
            _enableSaveBtn = _formSettingsKey.currentState!.validate();
          });
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          buildProfileAvatar(influencer),
          AppTextfield(
              field: "Nama",
              fieldController: _nameController,
              validator: _nameValidator),
          DirectingTextfield(
              field: "Jenis Kelamin",
              fieldController: _genderController,
              onTap: () => showGenderModal()),
          const SizedBox(height: 16),
          const Text('Lokasi'),
          const SizedBox(height: 8),
          TextFormField(
            controller: _locationController,
            validator: _locationValidator,
            decoration: textInputDecoration.copyWith(
                hintText: "Tekan ikon untuk akses lokasi",
                suffixIcon: IconButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) =>
                          showDialogWithCircularProgress(context),
                    );
                    await _getCurrentPosition();
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(Icons.location_on_rounded),
                  color: Constants.primaryColor,
                )),
          ),
          const SizedBox(height: 16),
          buildCategoryTypeChips(_selectedCategory),
          DirectingTextfield(
              field: "Tentang Anda",
              fieldController: _aboutController,
              onTap: () async {
                final changedValue = await nextScreenAndGetValue(
                    context,
                    FullTextfieldPage(
                        field: "Tentang Anda",
                        fieldController: _aboutController));
                _aboutController.text = changedValue;
              }),
          DirectingTextfield(
              field: "Catatan Persetujuan",
              fieldController: _noteAgreementController,
              onTap: () async {
                final changedValue = await nextScreenAndGetValue(
                    context,
                    FullTextfieldPage(
                        field: "Catatan Persetujuan",
                        fieldController: _noteAgreementController));
                _noteAgreementController.text = changedValue;
              }),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: const Text('Rentang Harga (Dalam Rupiah)',
                        style: TextStyle(
                            color: Constants.primaryColor, fontSize: 15),
                        textAlign: TextAlign.left)),
                Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Harga Terendah',
                      errorStyle:
                          const TextStyle(overflow: TextOverflow.visible),
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
                  margin: const EdgeInsets.only(bottom: 16),
                  child: TextFormField(
                    decoration: textInputDecoration.copyWith(
                      hintText: 'Harga Tertinggi',
                      errorStyle:
                          const TextStyle(overflow: TextOverflow.visible),
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
                DirectingTextfield(
                    field: "Akun Bank",
                    fieldController: _bankAccountController,
                    onTap: () => showBankNameModalBottom()),
                AppTextfield(
                    field: "Nama Pemilik Rekening",
                    fieldController: _bankAccountNameController,
                    validator: _bankAccountNameValidator),
                AppTextfield(
                    field: "Nomor Rekening",
                    fieldController: _bankAccountNumberController,
                    validator: _bankAccountNumberValidator),
              ],
            ),
          ),
          buildLinkedAccount(),
        ]),
      ),
    ));
  }

  void showBankNameModalBottom() {
    List<Widget> bankNameRadios = [];
    List<String> bankList = [
      'BCA',
      'BRI',
      'BNI',
      'BTN',
      'Bank Permata',
      'Bank Jakarta'
    ];
    for (String bank in bankList) {
      bankNameRadios.add(RadioListTile(
          title: Text(bank,
              style: const TextStyle(color: Colors.black87, fontSize: 18)),
          value: bank,
          groupValue: _bankAccountController.text,
          onChanged: (value) {
            _bankAccountController.text = value.toString();
            Navigator.pop(context);
          }));
    }

    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child:
              Column(mainAxisSize: MainAxisSize.min, children: bankNameRadios),
        );
      },
    );
  }

  Widget buildProfileAvatar(Influencer influencer) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      double parentWidth = constraints.maxWidth;
      return Container(
          width: parentWidth,
          margin: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
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
                                            title: Text("Pilih dari galeri",
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
                                            title: Text("Hapus gambar profil",
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
                            fillColor: const Color(0xFFF5F6F9),
                            padding: const EdgeInsets.all(8.0),
                            shape: const CircleBorder(),
                            child: const Icon(Icons.camera_alt_outlined,
                                color: Colors.grey),
                          )),
                    ]),
              ),
            ],
          ));
    });
  }

  Widget buildCategoryTypeChips(List<CategoryType> categories) {
    List<Widget> widgetChips = [];
    for (CategoryType category in categories) {
      Widget chip = Chip(
        padding: const EdgeInsets.symmetric(vertical: 13.0, horizontal: 13.0),
        labelPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        backgroundColor: Constants.primaryColor.withOpacity(0.6),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
            side: BorderSide(
                width: 0.5, color: Constants.grayColor.withOpacity(0.5))),
        elevation: 0.5,
        label: Text(category.categoryTypeName,
            style: const TextStyle(
                fontSize: 14.0,
                color: Colors.white,
                fontWeight: FontWeight.w400)),
      );
      widgetChips.add(Container(
        margin: const EdgeInsets.only(bottom: 5.0),
        child: chip,
      ));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Tipe Kategori",
                      style: TextStyle(
                          color: Constants.primaryColor, fontSize: 15),
                      textAlign: TextAlign.left),
                  GestureDetector(
                    child: const Icon(Icons.arrow_forward_ios_outlined,
                        color: Constants.primaryColor, size: 16),
                    onTap: () async {
                      List<CategoryType> selected = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectTypePage(
                                    selectedCategoryTypeList: _selectedCategory,
                                  )));
                      setState(() {
                        _selectedCategory = selected;
                      });
                    },
                  ),
                ])),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 10.0,
          children: widgetChips,
        ),
      ],
    );
  }

  Widget buildLinkedAccount() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
          margin: const EdgeInsets.only(top: 15.0, bottom: 10.0),
          child: const Text('Linked Accounts',
              style: TextStyle(
                  color: Constants.primaryColor,
                  fontSize: 17,
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.left)),
      GestureDetector(
        onTap: () {
          if (verified) {
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
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0)),
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        ListTile(
                          leading: Icon(Ionicons.pencil_outline,
                              color: Colors.grey.shade600),
                          title:
                              Text("Reconnect to Facebook", style: textStyle),
                          onTap: () {
                            Navigator.pop(context);
                            authBloc.add(
                                FacebookCredentialRequested(influencer.userId));
                          },
                        ),
                        ListTile(
                          leading: const Icon(Ionicons.trash_outline,
                              color: Colors.red),
                          title: Text("Revoke Facebook access",
                              style: textStyle.copyWith(color: Colors.red)),
                          onTap: () {
                            revokeFacebookAccess();
                            Navigator.pop(context);
                          },
                        ),
                      ]));
                });
          } else {
            authBloc.add(FacebookCredentialRequested(influencer.userId));
          }
        },
        child: Container(
            margin: const EdgeInsets.symmetric(vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
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
                              style: TextStyle(
                                  color: Constants.primaryColor, fontSize: 15),
                              textAlign: TextAlign.left),
                        ])),
                Container(
                    margin: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(verified ? 'Connected' : 'Not connected',
                              style: const TextStyle(
                                  color: Constants.grayColor, fontSize: 15.0)),
                          const Padding(
                            padding: EdgeInsets.only(left: 10.0),
                            child: Icon(Ionicons.chevron_forward_outline,
                                color: Constants.grayColor),
                          ),
                        ])),
              ],
            )),
      ),
    ]);
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
      SnackBarWidget.failed(
          context, 'Akses lokasi dinonaktifkan. Harap aktifkan akses');
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
        _currentAddress = place.subAdministrativeArea;
        _locationController.text = _currentAddress!;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }

  Future<bool> saveDialog(context) async {
    Text dialogTitle = const Text("Simpan Perubahan");
    Text dialogContent =
        const Text("Apa Anda yakin untuk menyimpan perubahan?");
    TextButton primaryButton = TextButton(
      child: const Text("Simpan"),
      onPressed: () {
        influencer.fullname = _nameController.text;
        influencer.location = _locationController.text;
        influencer.about = _aboutController.text;
        influencer.noteAgreement = _noteAgreementController.text;
        influencer.gender = _genderController.text;
        influencer.categoryType = _selectedCategory;
        influencer.bankAccount = _bankAccountController.text;
        influencer.bankAccountName = _bankAccountNameController.text;
        influencer.bankAccountNumber = _bankAccountNumberController.text;
        influencer.lowestFee = int.parse(_lowestFeeController.text);
        influencer.highestFee = int.parse(_highestFeeController.text);
        influencerBloc
            .add(UpdateInfluencerProfileSettings(influencer, _selectedImage));
      },
    );
    TextButton secondaryButton = TextButton(
      child: const Text("Batal"),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    final bool resp = await showDialog(
        context: context,
        builder: (context) => showAlertDialog(context, dialogTitle,
            dialogContent, primaryButton, secondaryButton));
    if (!resp) return false;
    return true;
  }

  Future<bool> createWillPopDialog(context) async {
    Text dialogTitle = const Text("Buang perubahan?");
    Text dialogContent = const Text(
        "Anda akan kehilangan perubahan data jika meninggalkan halaman.");
    TextButton discardButton = TextButton(
      child: const Text("Buang"),
      onPressed: () {
        Navigator.pop(context, true);
        Navigator.pop(context);
      },
    );
    TextButton cancelButton = TextButton(
      child: const Text("Lanjut Ubah"),
      onPressed: () {
        Navigator.pop(context, false);
      },
    );
    final bool resp = await showDialog(
        context: context,
        builder: (context) => showAlertDialog(
            context, dialogTitle, dialogContent, discardButton, cancelButton));
    if (!resp) return Future.value(false);
    return Future.value(false);
  }
}

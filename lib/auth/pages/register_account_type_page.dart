import 'package:fluence_for_influencer/auth/bloc/auth_bloc.dart';
import 'package:fluence_for_influencer/auth/pages/login_page.dart';
import 'package:fluence_for_influencer/auth/pages/terms_and_condition_page.dart';
import 'package:fluence_for_influencer/auth/pages/verify_email_page.dart';
import 'package:fluence_for_influencer/models/category_type.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/select_type_page.dart';
import 'package:fluence_for_influencer/shared/widgets/text_input.dart';
import 'package:fluence_for_influencer/shared/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ionicons/ionicons.dart';

class RegisterAccountTypePage extends StatefulWidget {
  final String fullName;
  final String email;
  final String password;
  final String id;

  const RegisterAccountTypePage(
      {Key? key,
      required this.fullName,
      required this.email,
      required this.password,
      required this.id})
      : super(key: key);

  @override
  State<RegisterAccountTypePage> createState() =>
      _RegisterAccountTypePageState();
}

class _RegisterAccountTypePageState extends State<RegisterAccountTypePage> {
  final _registerFormKey = GlobalKey<FormState>();
  final _bankAccountController = TextEditingController();
  final _bankAccountNameController = TextEditingController();
  final _bankAccountNumberController = TextEditingController();
  final _genderController = TextEditingController();
  final _locationController = TextEditingController();

  String? _currentAddress;
  Position? _currentPosition;

  List<CategoryType> selectedCategoryType = List.empty();
  CategoryType othersCategoryType = CategoryType("", "");

  @override
  void dispose() {
    _bankAccountController.dispose();
    _bankAccountNameController.dispose();
    _bankAccountNumberController.dispose();
    _genderController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is NeedVerify) {
            navigateAsFirstScreen(context, const VerifyEmailPage());
            return;
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is GoogleLoginRequestedSuccess) {
            return loadPage();
          }
          if (state is UnAuthenticated) {
            return loadPage();
          }
          return Container();
        },
      ),
    );
  }

  Widget loadPage() {
    return SafeArea(
      child: Center(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Form(
              key: _registerFormKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Akun Bank'),
                            const SizedBox(height: 8),
                            TextFormField(
                              onTap: () => showBankNameModalBottom(),
                              readOnly: true,
                              controller: _bankAccountController,
                              decoration: textInputDecoration.copyWith(
                                  suffixIcon: const Icon(
                                      Ionicons.chevron_forward_outline,
                                      color: Constants.grayColor)),
                              validator: (value) =>
                                  value!.isEmpty ? "Pilih akun bank" : null,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(height: 16),
                            const Text('Nama Pemilik Rekening'),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _bankAccountNameController,
                              decoration: textInputDecoration,
                              validator: (value) => value!.isEmpty
                                  ? "Masukkan nama pemilik rekening"
                                  : null,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(height: 16),
                            const Text('Nomor Rekening'),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _bankAccountNumberController,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: textInputDecoration,
                              validator: (value) => value!.isEmpty
                                  ? "Masukkan nomor rekening"
                                  : null,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(15.0)),
                                    ),
                                    context: context,
                                    builder: (context) {
                                      return const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: Text(
                                            "Ini digunakan untuk mengidentifikasi akun Anda saat mentransfer dana atau menyiapkan setoran langsung.\n\nHarap perhatikan bahwa Anda tidak boleh membagikan nomor rekening bank Anda dengan siapa pun yang tidak Anda percayai, karena dapat digunakan untuk menarik dana dari rekening Anda."),
                                      );
                                    },
                                  );
                                },
                                child: const Text(
                                  'Mengapa kami membutuhkan data rekening?',
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Constants.primaryColor,
                                      decoration: TextDecoration.underline),
                                )),
                            const SizedBox(height: 16),
                            const Text('Jenis Kelamin'),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _genderController,
                              decoration: textInputDecoration.copyWith(
                                  suffixIcon: const Icon(
                                      Ionicons.chevron_forward_outline,
                                      color: Constants.grayColor)),
                              validator: (value) =>
                                  value!.isEmpty ? "Pilih jenis kelamin" : null,
                              readOnly: true,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              onTap: () => showGenderModal(),
                            ),
                            const SizedBox(height: 16),
                            const Text("Lokasi",
                                style:
                                    TextStyle(color: Constants.primaryColor)),
                            const SizedBox(height: 8),
                            TextFormField(
                              controller: _locationController,
                              validator: (value) =>
                                  value!.isEmpty ? "Masukkan lokasi" : null,
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: textInputDecoration.copyWith(
                                  hintText: "Tekan ikon untuk akses lokasi",
                                  suffixIcon: IconButton(
                                      onPressed: () async {
                                        showDialog(
                                          context: context,
                                          barrierDismissible: false,
                                          builder: (context) =>
                                              showDialogWithCircularProgress(
                                                  context),
                                        );
                                        await _getCurrentPosition();
                                        Navigator.of(context).pop();
                                      },
                                      icon:
                                          const Icon(Icons.location_on_rounded),
                                      color: Constants.primaryColor)),
                            )
                          ]),
                    ),
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Tipe Kategori",
                                    style: TextStyle(
                                        color: Constants.primaryColor)),
                                GestureDetector(
                                  child: const Icon(
                                      Icons.arrow_forward_ios_outlined,
                                      color: Constants.primaryColor,
                                      size: 16),
                                  onTap: () async {
                                    List<CategoryType> selected =
                                        await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SelectTypePage(
                                                      selectedCategoryTypeList:
                                                          selectedCategoryType,
                                                    )));
                                    setState(() {
                                      if (selected.last.categoryTypeName
                                              .isNotEmpty &&
                                          selected
                                              .last.categoryTypeId.isEmpty) {
                                        othersCategoryType = selected.last;
                                      } else {
                                        othersCategoryType =
                                            CategoryType("", "");
                                      }
                                      selectedCategoryType = selected;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            selectedCategoryType.isEmpty
                                ? GestureDetector(
                                    onTap: () async {
                                      List<CategoryType> selected =
                                          await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      SelectTypePage(
                                                        selectedCategoryTypeList:
                                                            selectedCategoryType,
                                                      )));
                                      setState(() {
                                        if (selected.last.categoryTypeName
                                                .isNotEmpty &&
                                            selected
                                                .last.categoryTypeId.isEmpty) {
                                          othersCategoryType = selected.last;
                                        } else {
                                          othersCategoryType =
                                              CategoryType("", "");
                                        }
                                        selectedCategoryType = selected;
                                      });
                                    },
                                    child: const SizedBox(
                                      height: 50,
                                      child: Center(
                                          child: Text(
                                        "Tekan untuk memilih",
                                        style: TextStyle(
                                            color: Constants.grayColor),
                                      )),
                                    ),
                                  )
                                : buildCategoryTypeChips(selectedCategoryType),
                            const SizedBox(height: 16),
                            Text.rich(
                              TextSpan(
                                  text:
                                      'Dengan melanjutkan, Anda setuju dengan ',
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: 'syarat dan ketentuan layanan',
                                        style: const TextStyle(
                                          color: Constants.maroonColor,
                                          decoration: TextDecoration.underline,
                                        ),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            nextScreen(context,
                                                const TermsAndConditionPage());
                                          }),
                                  ]),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).primaryColor,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30))),
                                  onPressed: () {
                                    bool isFilled = _registerFormKey
                                        .currentState!
                                        .validate();

                                    if (selectedCategoryType.isEmpty ||
                                        !isFilled) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor: Colors.red[300],
                                              content: const Text(
                                                'Pilih tipe kategori',
                                              )));
                                    } else {
                                      _createAccountWithEmailAndPassword(
                                          context);
                                    }
                                  },
                                  child: const Text(
                                    "Kirim",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  )),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              alignment: Alignment.center,
                              child: Text.rich(TextSpan(
                                  text: "Sudah memiliki akun? ",
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 14),
                                  children: <TextSpan>[
                                    TextSpan(
                                        text: "Masuk disini",
                                        style: const TextStyle(
                                            color: Constants.maroonColor,
                                            decoration:
                                                TextDecoration.underline),
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            navigateAsFirstScreen(
                                                context, const LoginPage());
                                          })
                                  ])),
                            )
                          ]),
                    ),
                  ])),
        ),
      )),
    );
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

  void showGenderModal() {
    List<String> genders = ['Pria', 'Wanita', 'Tidak Diketahui'];
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

  void _createAccountWithEmailAndPassword(BuildContext context) {
    List<String> categoryTypeIdList = [];

    for (CategoryType element in selectedCategoryType) {
      if (element.categoryTypeId.isNotEmpty) {
        categoryTypeIdList.add(element.categoryTypeId);
      }
    }

    if (widget.password.isEmpty) {
      BlocProvider.of<AuthBloc>(context).add(GoogleLoginRegisterRequested(
          widget.email,
          widget.fullName,
          _bankAccountController.text,
          _bankAccountNameController.text,
          _bankAccountNumberController.text,
          _genderController.text,
          _locationController.text,
          categoryTypeIdList,
          othersCategoryType.categoryTypeName,
          widget.id));
    } else {
      BlocProvider.of<AuthBloc>(context).add(RegisterRequested(
          widget.email,
          widget.password,
          widget.fullName,
          _bankAccountController.text,
          _bankAccountNameController.text,
          _bankAccountNumberController.text,
          _genderController.text,
          _locationController.text,
          categoryTypeIdList,
          othersCategoryType.categoryTypeName));
    }
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
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 10.0,
      children: widgetChips,
    );
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
        _currentAddress = place.subAdministrativeArea;
        _locationController.text = _currentAddress!;
      });
    }).catchError((e) {
      debugPrint(e);
    });
  }
}

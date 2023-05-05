import 'package:fluence_for_influencer/auth/bloc/auth_bloc.dart';
import 'package:fluence_for_influencer/auth/pages/login_page.dart';
import 'package:fluence_for_influencer/auth/pages/verify_email_page.dart';
import 'package:fluence_for_influencer/models/category_type.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/select_type_page.dart';
import 'package:fluence_for_influencer/shared/widgets/text_input.dart';
import 'package:fluence_for_influencer/shared/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

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
  final _genderController = TextEditingController();
  final _locationController = TextEditingController();

  String? _currentAddress;
  Position? _currentPosition;

  List<CategoryType> selectedCategoryType = List.empty();

  @override
  void dispose() {
    _bankAccountController.dispose();
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
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
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
      child: Container(
        color: Constants.backgroundColor,
        child: Center(
            child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            child: Form(
                key: _registerFormKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Bank Account'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _bankAccountController,
                                decoration: textInputDecoration,
                                validator: (value) => value!.isEmpty
                                    ? "Insert your bank account"
                                    : null,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                  onTap: () {},
                                  child: const Text('Why we need this data')),
                              const SizedBox(height: 16),
                              const Text('Gender'),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _genderController,
                                decoration: textInputDecoration,
                                validator: (value) => value!.isEmpty
                                    ? "Choose your gender"
                                    : null,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                onTap: () {
                                  // bottom sheet modal
                                },
                              ),
                              const Text("Location",
                                  style:
                                      TextStyle(color: Constants.primaryColor)),
                              const SizedBox(height: 8),
                              TextFormField(
                                controller: _locationController,
                                validator: (value) => value!.isEmpty
                                    ? "Insert your location"
                                    : null,
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                decoration: textInputDecoration.copyWith(
                                    hintText: "Tap icon to get your location",
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
                                        icon: const Icon(
                                            Icons.location_on_rounded),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text("Category Type",
                                      style: TextStyle(
                                          color: Constants.primaryColor)),
                                  GestureDetector(
                                    child: const Icon(
                                        Icons.arrow_forward_ios_outlined,
                                        color: Constants.primaryColor,
                                        size: 16),
                                    onTap: () async {
                                      dynamic selected = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const SelectTypePage()));
                                      setState(() {
                                        selectedCategoryType = selected;
                                      });
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              selectedCategoryType.isEmpty
                                  ? GestureDetector(
                                      onTap: () async {
                                        dynamic selected = await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const SelectTypePage()));
                                        setState(() {
                                          selectedCategoryType = selected;
                                        });
                                      },
                                      child: const SizedBox(
                                        height: 50,
                                        child: Center(
                                            child: Text(
                                          "Tap to choose your type",
                                          style: TextStyle(
                                              color: Constants.grayColor),
                                        )),
                                      ),
                                    )
                                  : buildCategoryTypeChips(
                                      selectedCategoryType),
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
                                      if (selectedCategoryType.isNotEmpty &&
                                          _locationController.text.isNotEmpty) {
                                        _createAccountWithEmailAndPassword(
                                            context);
                                      }
                                    },
                                    child: const Text(
                                      "Submit",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16),
                                    )),
                              ),
                              const SizedBox(height: 12),
                              Container(
                                alignment: Alignment.center,
                                child: Text.rich(TextSpan(
                                    text: "Already have an account? ",
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 14),
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: "Login now",
                                          style: const TextStyle(
                                              color: Constants.primaryColor,
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
      ),
    );
  }

  void _createAccountWithEmailAndPassword(BuildContext context) {
    List<String> categoryTypeIdList = [];

    for (var element in selectedCategoryType) {
      categoryTypeIdList.add(element.categoryTypeId);
    }

    if (widget.password.isEmpty) {
      BlocProvider.of<AuthBloc>(context).add(GoogleLoginRegisterRequested(
          widget.email,
          widget.fullName,
          _locationController.text,
          categoryTypeIdList,
          widget.id));
    } else {
      BlocProvider.of<AuthBloc>(context).add(RegisterRequested(
          widget.email,
          widget.password,
          widget.fullName,
          _locationController.text,
          categoryTypeIdList));
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

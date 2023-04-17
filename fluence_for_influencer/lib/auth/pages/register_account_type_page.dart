import 'package:fluence_for_influencer/auth/bloc/auth_bloc.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/app_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterAccountTypePage extends StatefulWidget {
  const RegisterAccountTypePage({super.key});

  @override
  State<RegisterAccountTypePage> createState() =>
      _RegisterAccountTypePageState();
}

class _RegisterAccountTypePageState extends State<RegisterAccountTypePage> {
  final _registerFormKey = GlobalKey<FormState>();
  String selectedAccountType = "UMKM";
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  dynamic _nameValidator(String? value) {
    return value!.length < 6 ? "Name must be at least 6 characters" : null;
  }

  dynamic _locationValidator(String? value) {
    return value!.length < 6 ? "Location must be at least 6 characters" : null;
  }

  List<String> selectedCategoryType = List.empty();

  // API: get category type

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void onChangeAccountType(String accountType) {
    setState(() {
      selectedAccountType = accountType;
    });
  }

  void onClickCategoryType(String categoryType) {
    setState(() {
      selectedCategoryType.add(categoryType);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Theme.of(context).primaryColor),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            nextScreenReplace(context, const MainPage());
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        builder: (context, state) {
          if (state is Loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is UnAuthenticated) {
            return SafeArea(
              child: SingleChildScrollView(
                  child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                child: Form(
                  key: _registerFormKey,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints boxConstraints) {
                    double width = boxConstraints.maxWidth;
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          const Text(
                            textAlign: TextAlign.center,
                            "Welcome to Fluence!",
                            style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                                color: Constants.primaryColor),
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            textAlign: TextAlign.center,
                            "Please choose your preferred account type.",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                                color: Constants.grayColor),
                          ),
                          Container(
                              margin: const EdgeInsets.symmetric(
                                  vertical: Constants.defaultPadding),
                              decoration: BoxDecoration(
                                borderRadius:
                                    Constants.defaultBorderRadiusButton,
                                color:
                                    Constants.secondaryColor.withOpacity(0.3),
                              ),
                              child: LayoutBuilder(builder:
                                  (BuildContext context,
                                      BoxConstraints boxConstraints) {
                                double width = boxConstraints.maxWidth * 0.9;
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AccountTypeTab(
                                        'UMKM',
                                        selectedAccountType == 'UMKM',
                                        width / 2),
                                    AccountTypeTab(
                                        'Influencer',
                                        selectedAccountType == 'Influencer',
                                        width / 2),
                                  ],
                                );
                              })),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              textfieldContainer(TextInputType.text, 'Name',
                                  _nameController, _nameValidator),
                              textfieldContainer(TextInputType.text, 'Location',
                                  _locationController, _locationValidator),
                            ],
                          )
                        ]);
                  }),
                ),
              )),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget textfieldContainer(TextInputType keyboardType, String field,
      TextEditingController fieldController, Function(String?) validator,
      {bool isObscure = false}) {
    return Container(
        margin:
            const EdgeInsets.symmetric(vertical: Constants.defaultPadding / 2),
        child: AppTextfield(
            isObscure: isObscure,
            keyboardType: keyboardType,
            field: field,
            fieldController: fieldController,
            validator: validator));
  }

  Widget AccountTypeTab(String text, bool isActive, double width) {
    BoxDecoration boxDecor = isActive == true
        ? BoxDecoration(
            color: Colors.white,
            borderRadius: Constants.defaultBorderRadiusButton,
          )
        : BoxDecoration(
            borderRadius: Constants.defaultBorderRadiusButton,
          );
    TextStyle textStyle = isActive == true
        ? TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Constants.primaryColor.withOpacity(0.8),
          )
        : TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Constants.primaryColor.withOpacity(0.5));
    return InkWell(
      onTap: () => onChangeAccountType(text),
      child: Container(
        width: width,
        height: 40,
        margin: const EdgeInsets.all(Constants.defaultPadding / 2.5),
        padding: const EdgeInsets.all(Constants.defaultPadding / 2),
        decoration: boxDecor,
        child: Text(
          text,
          style: textStyle,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget TagsContainer(
      String field, List<String> tags, List<String> selectedTags) {
    List<Widget> tagWidgets = [];
    // tagWidgets.add(Tag('Food', selectedTags.contains('Food'), onClickCategoryType('Food')));

    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Text(field,
              style: TextStyle(color: Constants.primaryColor, fontSize: 15),
              textAlign: TextAlign.left)),
      Row(
        children: [],
      )
    ]);
  }

  Widget Tag(String type, bool isActive, Function(String?) onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Constants.secondaryColor,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: EdgeInsets.symmetric(horizontal: 5),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Text(type,
          style: TextStyle(color: Colors.black26, fontWeight: FontWeight.w400)),
    );
  }
}

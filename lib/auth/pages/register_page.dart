import 'package:fluence_for_influencer/auth/bloc/auth_bloc.dart';
import 'package:fluence_for_influencer/auth/pages/login_page.dart';
import 'package:fluence_for_influencer/auth/pages/register_account_type_page.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/text_input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _fullnameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            nextScreenReplace(context, const MainPage(index: 0));
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
              child: Container(
                color: Constants.backgroundColor,
                child: Center(
                  child: SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Form(
                      key: _registerFormKey,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            const Text(
                              textAlign: TextAlign.center,
                              "Register",
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryColor),
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Full Name",
                                          style: TextStyle(
                                              color: Constants.primaryColor),
                                        ),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                            controller: _fullnameController,
                                            validator: (value) {
                                              return value!.isEmpty
                                                  ? "Please enter your name"
                                                  : null;
                                            },
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            decoration:
                                                textInputDecoration.copyWith(
                                              prefixIcon: const Icon(
                                                Icons.person_rounded,
                                                color: Constants.primaryColor,
                                              ),
                                            ))
                                      ]),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Email",
                                            style: TextStyle(
                                                color: Constants.primaryColor)),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                            controller: _emailController,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            validator: (value) {
                                              return RegExp(
                                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                                      .hasMatch(value!)
                                                  ? null
                                                  : "Please enter a valid email";
                                            },
                                            decoration:
                                                textInputDecoration.copyWith(
                                                    prefixIcon: const Icon(
                                              Icons.email,
                                              color: Constants.primaryColor,
                                            )))
                                      ]),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Password",
                                            style: TextStyle(
                                                color: Constants.primaryColor)),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          decoration:
                                              textInputDecoration.copyWith(
                                            prefixIcon: const Icon(Icons.lock,
                                                color: Constants.primaryColor),
                                          ),
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller: _passwordController,
                                          keyboardType: TextInputType.text,
                                          obscureText: true,
                                          validator: (value) {
                                            return value!.length < 6
                                                ? "Password must be at least 6 characters"
                                                : null;
                                          },
                                          onChanged: (value) {},
                                        )
                                      ]),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text("Confirm Password",
                                            style: TextStyle(
                                                color: Constants.primaryColor)),
                                        const SizedBox(height: 8),
                                        TextFormField(
                                          decoration:
                                              textInputDecoration.copyWith(
                                            prefixIcon: const Icon(Icons.lock,
                                                color: Constants.primaryColor),
                                          ),
                                          autovalidateMode: AutovalidateMode
                                              .onUserInteraction,
                                          controller:
                                              _confirmPasswordController,
                                          keyboardType: TextInputType.text,
                                          obscureText: true,
                                          validator: (value) {
                                            if (value!.length < 6) {
                                              return "Password must be at least 6 characters";
                                            } else if (value !=
                                                _passwordController.text) {
                                              return "Password not match";
                                            } else {
                                              return null;
                                            }
                                          },
                                        )
                                      ]),
                                ),
                              ],
                            ),
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
                                    // _createAccountWithEmailAndPassword(context);
                                    if (_registerFormKey.currentState!
                                        .validate()) {
                                      nextScreen(
                                          context,
                                          RegisterAccountTypePage(
                                              fullName:
                                                  _fullnameController.text,
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                              id: ""));
                                    }
                                  },
                                  child: const Text(
                                    "Next",
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
                  )),
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  // void _createAccountWithEmailAndPassword(BuildContext context) {
  //   if (_registerFormKey.currentState!.validate()) {
  //     BlocProvider.of<AuthBloc>(context).add(
  //       RegisterRequested(
  //         _emailController.text,
  //         _passwordController.text,
  //       ),
  //     );
  //   }
  // }

  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleLoginRequested(),
    );
  }
}

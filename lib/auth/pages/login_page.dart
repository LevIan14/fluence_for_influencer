import 'package:fluence_for_influencer/auth/bloc/auth_bloc.dart';
import 'package:fluence_for_influencer/auth/pages/forgot_password_page.dart';
import 'package:fluence_for_influencer/auth/pages/register_account_type_page.dart';
import 'package:fluence_for_influencer/auth/pages/register_page.dart';
import 'package:fluence_for_influencer/auth/pages/verify_email_page.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/text_input.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: ((context, state) {
          if (state is GoogleLoginRequestedSuccess) {
            nextScreen(
                context,
                RegisterAccountTypePage(
                    fullName: state.fullname,
                    email: state.email,
                    password: "",
                    id: state.id));
            return;
          }
          if (state is NeedVerify) {
            nextScreen(context, const VerifyEmailPage());
            return;
          }
          if (state is Authenticated) {
            nextScreenReplace(context, const MainPage(index: 0));
            return;
          }

          if (state is AuthError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.error)));
            return;
          }
        }),
        builder: (context, state) {
          if (state is Loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is UnAuthenticated) {
            return SafeArea(
              child: Container(
                color: Constants.backgroundColor,
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      child: Form(
                        key: _loginFormKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            const Text(
                              "Fluence for Influencers",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.primaryColor),
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                const Text(
                                  'Email',
                                  style: TextStyle(
                                      color: Constants.primaryColor,
                                      fontSize: 15),
                                ),
                                const SizedBox(height: 10),
                                TextFormField(
                                  decoration: textInputDecoration.copyWith(
                                      prefixIcon: Icon(Icons.email,
                                          color:
                                              Theme.of(context).primaryColor)),
                                  keyboardType: TextInputType.emailAddress,
                                  controller: _emailController,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  validator: (value) {
                                    return RegExp(
                                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                            .hasMatch(value!)
                                        ? null
                                        : "Please enter a valid email";
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                const Text(
                                  'Password',
                                  style: TextStyle(
                                      color: Constants.primaryColor,
                                      fontSize: 15),
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                    obscureText: true,
                                    decoration: textInputDecoration.copyWith(
                                        prefixIcon: Icon(Icons.lock,
                                            color: Theme.of(context)
                                                .primaryColor)),
                                    controller: _passwordController,
                                    keyboardType: TextInputType.text,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (value) {
                                      return value!.length < 6
                                          ? "Password must be at least 6 characters"
                                          : null;
                                    }),
                              ],
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                                onTap: () {
                                  nextScreen(
                                      context, const ForgotPasswordPage());
                                },
                                child: const Text("Forgot password?")),
                            const SizedBox(height: 16),
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
                                  _authenticateWithEmailAndPassword(context);
                                },
                                child: const Text(
                                  "Sign In",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: const [
                                Expanded(child: Divider(endIndent: 12)),
                                Text(
                                  "Or sign in with",
                                ),
                                Expanded(child: Divider(indent: 12))
                              ],
                            ),
                            const SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      _authenticateWithGoogle(context);
                                    },
                                    icon: const Image(
                                      image:
                                          AssetImage('assets/google_logo.png'),
                                      height: 30,
                                      width: 30,
                                    )),
                                IconButton(
                                    onPressed: () {
                                      _authenticateWithFacebook(context);
                                    },
                                    icon: const Image(
                                      image: AssetImage(
                                          'assets/facebook_logo.png'),
                                      height: 30,
                                      width: 30,
                                    )),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              alignment: Alignment.center,
                              child: Text.rich(TextSpan(
                                text: "Don't have an account? ",
                                style: const TextStyle(
                                    color: Constants.primaryColor,
                                    fontSize: 14),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: "Register here",
                                      style: const TextStyle(
                                          color: Constants.maroonColor,
                                          decoration: TextDecoration.underline),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          nextScreen(
                                              context, const RegisterPage());
                                        }),
                                ],
                              )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return Text(state.toString());
        },
      ),
    );
  }

  void _authenticateWithEmailAndPassword(context) {
    if (_loginFormKey.currentState!.validate()) {
      BlocProvider.of<AuthBloc>(context).add(
        LoginRequested(_emailController.text, _passwordController.text),
      );
    }
  }

  void _authenticateWithGoogle(context) {
    BlocProvider.of<AuthBloc>(context).add(
      GoogleLoginRequested(),
    );
  }

  void _authenticateWithFacebook(context) {
    BlocProvider.of<AuthBloc>(context).add(
      FacebookLoginRequested(),
    );
  }
}

import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluence_for_influencer/auth/bloc/auth_bloc.dart';
import 'package:fluence_for_influencer/auth/pages/login_page.dart';
import 'package:fluence_for_influencer/auth/pages/verify_email_page.dart';
import 'package:fluence_for_influencer/auth/repository/auth_repository.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
  );
  runApp(const FluenceForInfluencer());
}

class FluenceForInfluencer extends StatefulWidget {
  const FluenceForInfluencer({super.key});

  @override
  State<FluenceForInfluencer> createState() => _FluenceAppState();
}

class _FluenceAppState extends State<FluenceForInfluencer> {
  late final AuthBloc authBloc;
  final AuthRepository authRepository = AuthRepository();
  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc(authRepository: authRepository);
    authBloc.add(CheckIsUserLoggedIn());
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => authBloc)],
      child: MaterialApp(
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate
          ],
          supportedLocales: const [
            Locale('id'),
          ],
          theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSeed(seedColor: Constants.primaryColor),
              primaryColor: Constants.primaryColor,
              scaffoldBackgroundColor: Colors.white,
              fontFamily: 'Montserrat'),
          debugShowCheckedModeBanner: false,
          home: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red[300],
                ));
              }
            },
            builder: (context, state) {
              if (state is Authenticated) {
                return const MainPage(index: 0);
              }
              if (state is NeedVerify) {
                return const VerifyEmailPage();
              }
              if (state is UnAuthenticated) {
                return const LoginPage();
              }
              return const LoginPage();
            },
          )),
    );
  }
}

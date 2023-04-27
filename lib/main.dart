import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:fluence_for_influencer/auth/bloc/auth_bloc.dart';
import 'package:fluence_for_influencer/main/main_page.dart';
import 'package:fluence_for_influencer/auth/pages/login_page.dart';
import 'package:fluence_for_influencer/auth/repository/auth_repository.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    androidProvider: AndroidProvider.debug,
  );
  runApp(const FluenceForInfluencer());
}

class FluenceForInfluencer extends StatelessWidget {
  const FluenceForInfluencer({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (context) => AuthRepository(),
        )
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
                authRepository: RepositoryProvider.of<AuthRepository>(context)),
          )
        ],
        child: MaterialApp(
          theme: ThemeData(
              colorScheme:
                  ColorScheme.fromSeed(seedColor: Constants.primaryColor),
              primaryColor: Constants.primaryColor,
              scaffoldBackgroundColor: Colors.white),
          debugShowCheckedModeBanner: false,
          home: StreamBuilder(
            stream: Constants.firebaseAuth.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                final bool isLoggedIn = snapshot.hasData;
                return isLoggedIn ? const MainPage(index: 0) : const LoginPage();
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
    );
  }
}

import 'package:fluence_for_influencer/auth/bloc/auth_bloc.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({super.key});

  @override
  State<VerifyEmailPage> createState() => VerifyEmailPageState();
}

class VerifyEmailPageState extends State<VerifyEmailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is VerifyEmailReqestSuccess) {
            Navigator.of(context).pop();
            BlocProvider.of<AuthBloc>(context).add(TriggerUnAuthenticated());
            return;
          }
          if (state is AuthError) {
            Navigator.of(context).pop();
            return;
          }
        },
        builder: (context, state) {
          return Container(
            color: Constants.backgroundColor,
            child: Center(
              child: SingleChildScrollView(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    const Text("Please verify your email first to login!"),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: Constants.primaryColor,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          onPressed: () {
                            showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) =>
                                    showDialogWithCircularProgress(context));
                            BlocProvider.of<AuthBloc>(context)
                                .add(VerifyEmailReqested());
                          },
                          child: const Text("Resend Email Verification!")),
                    )
                  ],
                ),
              )),
            ),
          );
        },
      ),
    );
  }
}

import 'package:fluence_for_influencer/auth/bloc/auth_bloc.dart';
import 'package:fluence_for_influencer/auth/pages/login_page.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/navigation_helper.dart';
import 'package:fluence_for_influencer/shared/widgets/snackbar_widget.dart';
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
            SnackBarWidget.success(
                context, 'Berhasil mengirim email verifikasi');
            Navigator.of(context).pop();
            return;
          }
          if (state is AuthError) {
            SnackBarWidget.failed(context, state.error);
            Navigator.of(context).pop();
            return;
          }
        },
        builder: (context, state) {
          return const Center(
              child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                "Harap verifikasi email Anda untuk masuk!\n\nKami telah mengirimkan email verifikasi ke email Anda.",
                textAlign: TextAlign.center,
              ),
            ),
          ));
        },
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                  child: const Text("Kirim Ulang")),
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  onPressed: () {
                    navigateAsFirstScreen(context, const LoginPage());
                    context.read<AuthBloc>().add(LogoutRequested());
                  },
                  child: const Text("Kembali Ke Login")),
            ),
          ],
        ),
      ),
    );
  }
}

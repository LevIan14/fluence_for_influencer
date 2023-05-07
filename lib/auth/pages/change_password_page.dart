import 'package:fluence_for_influencer/auth/bloc/auth_bloc.dart';
import 'package:fluence_for_influencer/auth/repository/auth_repository.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
import 'package:fluence_for_influencer/shared/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late final AuthBloc authBloc;
  final AuthRepository authRepository = AuthRepository();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();

  bool _oldPasswordInvisible = true;
  bool _newPasswordInvisible = true;
  bool _confirmNewPasswordInvisible = true;

  @override
  void initState() {
    super.initState();
    authBloc = AuthBloc(authRepository: authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => authBloc,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Ubah Password'),
            backgroundColor: Constants.primaryColor,
          ),
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is ChangePasswordSuccess) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: const Text('Berhasil mengganti password'),
                  backgroundColor: Colors.green[300],
                ));
              }
              if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(state.error),
                  backgroundColor: Colors.red[300],
                ));
              }
            },
            builder: (context, state) {
              return Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Password Lama'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _oldPasswordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: textInputDecoration.copyWith(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _oldPasswordInvisible =
                                        !_oldPasswordInvisible;
                                  });
                                },
                                icon: Icon(
                                  _oldPasswordInvisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Constants.primaryColor,
                                ))),
                        obscureText: _oldPasswordInvisible,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      const Text('Password Baru'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _newPasswordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Panjang password setidaknya 6 karakter";
                          } else if (value !=
                              _confirmNewPasswordController.text) {
                            return "Password tidak sama";
                          } else {
                            return null;
                          }
                        },
                        decoration: textInputDecoration.copyWith(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _newPasswordInvisible =
                                        !_newPasswordInvisible;
                                  });
                                },
                                icon: Icon(
                                  _newPasswordInvisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Constants.primaryColor,
                                ))),
                        obscureText: _newPasswordInvisible,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      const Text('Konfirmasi Password Baru'),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _newPasswordController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Panjang password setidaknya 6 karakter";
                          } else if (value != _newPasswordController.text) {
                            return "Password tidak sama";
                          } else {
                            return null;
                          }
                        },
                        decoration: textInputDecoration.copyWith(
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _confirmNewPasswordInvisible =
                                        !_confirmNewPasswordInvisible;
                                  });
                                },
                                icon: Icon(
                                  _confirmNewPasswordInvisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Constants.primaryColor,
                                ))),
                        obscureText: _confirmNewPasswordInvisible,
                        keyboardType: TextInputType.emailAddress,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: Constants.primaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      authBloc.add(ChangePasswordRequested(
                          _oldPasswordController.text,
                          _newPasswordController.text));
                    }
                  },
                  child: const Text('Kirim'))),
        ));
  }
}

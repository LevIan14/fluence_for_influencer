import 'package:fluence_for_influencer/auth/bloc/auth_bloc.dart';
import 'package:fluence_for_influencer/auth/repository/auth_repository.dart';
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
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => authBloc,
        child: Scaffold(
          appBar: AppBar(title: const Text('Change Password')),
          body: BlocConsumer<AuthBloc, AuthState>(
            listener: (context, state) {},
            builder: (context, state) {
              return Container();
            },
          ),
        ));
  }
}

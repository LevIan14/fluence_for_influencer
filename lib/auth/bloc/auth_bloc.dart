import 'package:equatable/equatable.dart';
import 'package:fluence_for_influencer/auth/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(UnAuthenticated()) {
    on<LoginRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.loginWithEmailAndPassword(
            email: event.email, password: event.password);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.registerUserWithEmailAndPassword(
            email: event.email, password: event.password);
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<GoogleLoginRequested>(((event, emit) async {
      emit(Loading());
      try {
        await authRepository.loginWithGoogle();
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    }));

    on<FacebookLoginRequested>(((event, emit) async {
      emit(Loading());
      try {
        await authRepository.loginWithFacebook();
        emit(Authenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    }));

    on<LogoutRequested>((event, emit) async {
      emit(Loading());
      await authRepository.logout();
      emit(UnAuthenticated());
    });
  }
}

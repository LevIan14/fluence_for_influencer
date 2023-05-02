import 'package:equatable/equatable.dart';
import 'package:fluence_for_influencer/auth/repository/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(UnAuthenticated()) {
    on<TriggerUnAuthenticated>((event, emit) {
      emit(UnAuthenticated());
    });

    on<LoginRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.loginWithEmailAndPassword(
            email: event.email, password: event.password);
        bool isVerified = await authRepository.checkIsEmailVerified();
        if (isVerified) {
          emit(Authenticated());
        } else {
          emit(NeedVerify());
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<VerifyEmailReqested>((event, emit) async {
      try {
        await authRepository.sendEmailVerification();
        emit(VerifyEmailReqestSuccess());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<RegisterRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.registerUserWithEmailAndPassword(event.email,
            event.password, event.fullname, event.location, event.categoryList);
        await authRepository.sendEmailVerification();
        emit(NeedVerify());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<GoogleLoginRequested>(((event, emit) async {
      emit(Loading());
      try {
        dynamic user = await authRepository.loginWithGoogle();
        if (user['exist']) {
          emit(Authenticated());
        } else {
          emit(GoogleLoginRequestedSuccess(
              user['fullname'], user['email'], user['id']));
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    }));
    on<FacebookCredentialRequested>(((event, emit) async {
      emit(Loading());
      try {
        Map<String, dynamic>? res = await authRepository.connectToFacebook(event.influencerId);
        if(res != null){
          emit(FacebookCredentialSuccess(res['id'], res['facebook_access_token'], res['instagram_user_id']));
        } 
        else {
          emit(FacebookCredentialRejected());
        } 
      } catch (e) {
        emit(FacebookCredentialError(e.toString()));
        emit(FacebookCredentialRejected());
      }
    }));

    on<ForgotPasswordRequested>((event, emit) async {
      try {
        await authRepository.forgotPassword(event.email);
        emit(ForgotPasswordRequestSuccess());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(Loading());
      await authRepository.logout();
      emit(UnAuthenticated());
    });
  }
}

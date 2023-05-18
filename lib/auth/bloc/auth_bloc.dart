import 'package:equatable/equatable.dart';
import 'package:fluence_for_influencer/auth/repository/auth_repository.dart';
import 'package:fluence_for_influencer/shared/constants.dart';
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
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<CheckIsUserLoggedIn>((event, emit) async {
      try {
        emit(Loading());
        bool isLoggedIn = await authRepository.checkIsUserLoggedIn();
        if (isLoggedIn && Constants.firebaseAuth.currentUser!.emailVerified) {
          emit(Authenticated());
        } else if (isLoggedIn &&
            !(Constants.firebaseAuth.currentUser!.emailVerified)) {
          emit(NeedVerify());
        } else {
          emit(UnAuthenticated());
        }
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<CheckEmailIsUsed>((event, emit) async {
      try {
        emit(Loading());
        await authRepository.checkEmailIsUsed(event.email);
        emit(EmailUnused());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
      emit(UnAuthenticated());
    });

    on<ChangePasswordRequested>((event, emit) async {
      try {
        await authRepository.changePassword(
            event.oldPassword, event.newPassword);
        emit(ChangePasswordSuccess());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(Authenticated());
      }
    });

    on<VerifyEmailReqested>((event, emit) async {
      try {
        await authRepository.sendEmailVerification();
        emit(VerifyEmailReqestSuccess());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
      emit(NeedVerify());
    });

    on<RegisterRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.registerUserWithEmailAndPassword(
            event.email,
            event.password,
            event.fullname,
            event.bankAccount,
            event.bankAccountName,
            event.bankAccountNumber,
            event.gender,
            event.location,
            event.categoryList,
            event.customCategory);
        await authRepository.sendEmailVerification();
        emit(NeedVerify());
      } catch (e) {
        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    });

    on<GoogleLoginRegisterRequested>((event, emit) async {
      emit(Loading());
      try {
        await authRepository.registerUserWithGoogleLogin(
            event.email,
            event.fullname,
            event.bankAccount,
            event.bankAccountName,
            event.bankAccountNumber,
            event.gender,
            event.location,
            event.categoryList,
            event.customCategory,
            event.id);
        emit(Authenticated());
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
          emit(UnAuthenticated());
        }
      } catch (e) {
        print(e.toString());

        emit(AuthError(e.toString()));
        emit(UnAuthenticated());
      }
    }));
    on<FacebookCredentialRequested>(((event, emit) async {
      emit(Loading());
      try {
        Map<String, dynamic>? res =
            await authRepository.connectToFacebook(event.influencerId);
        if (res != null) {
          emit(FacebookCredentialSuccess(
              res['facebook_access_token'], res['instagram_user_id']));
        } else {
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
      emit(UnAuthenticated());
    });

    on<LogoutRequested>((event, emit) async {
      emit(Loading());
      await authRepository.logout();
      emit(UnAuthenticated());
    });
  }
}

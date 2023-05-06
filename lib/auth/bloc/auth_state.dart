part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends AuthState {}

class EmailUnused extends AuthState {}

class NeedVerify extends AuthState {}

class VerifyEmailReqestSuccess extends AuthState {}

class ForgotPasswordRequestSuccess extends AuthState {}

class Authenticated extends AuthState {}

class ChangePasswordSuccess extends AuthState {}

class UnAuthenticated extends AuthState {}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);

  @override
  List<Object?> get props => [error];
}

class GoogleLoginRequestedSuccess extends AuthState {
  final String fullname;
  final String email;
  final String id;

  GoogleLoginRequestedSuccess(this.fullname, this.email, this.id);

  @override
  List<Object> get props => [fullname, email, id];
}

class FacebookCredentialSuccess extends AuthState {
  final String? influencerId;
  final String? facebookAccessToken;
  final String? instagramUserId;

  FacebookCredentialSuccess(
      this.influencerId, this.facebookAccessToken, this.instagramUserId);

  @override
  List<Object?> get props =>
      [influencerId, facebookAccessToken, instagramUserId];
}

class FacebookCredentialError extends AuthState {
  final String error;

  FacebookCredentialError(this.error);

  @override
  List<Object?> get props => [error];
}

class FacebookCredentialRejected extends AuthState {
  @override
  List<Object?> get props => [];
}

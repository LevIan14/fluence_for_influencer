part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class Loading extends AuthState {}

class NeedVerify extends AuthState {}

class VerifyEmailReqestSuccess extends AuthState {}

class ForgotPasswordRequestSuccess extends AuthState {}

class Authenticated extends AuthState {}

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

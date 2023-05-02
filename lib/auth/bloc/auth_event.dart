part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);
}

class RegisterRequested extends AuthEvent {
  final String email;
  final String password;
  final String fullname;
  final String location;
  final List<String> categoryList;

  RegisterRequested(this.email, this.password, this.fullname, this.location,
      this.categoryList);
}

class GoogleLoginRegisterRequested extends AuthEvent {
  final String email;
  final String fullname;
  final String location;
  final List<String> categoryList;
  final String id;

  GoogleLoginRegisterRequested(
      this.email, this.fullname, this.location, this.categoryList, this.id);

  @override
  List<Object> get props => [email, fullname, location, categoryList, id];
}

class GoogleLoginRequested extends AuthEvent {}

class FacebookLoginRequested extends AuthEvent {}

class LogoutRequested extends AuthEvent {}

class VerifyEmailReqested extends AuthEvent {}

class TriggerUnAuthenticated extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  ForgotPasswordRequested(this.email);

  @override
  List<Object> get props => [email];
}

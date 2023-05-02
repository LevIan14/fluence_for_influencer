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

  RegisterRequested(this.email, this.password);
}

class GoogleLoginRequested extends AuthEvent {}

class FacebookCredentialRequested extends AuthEvent {
  final String influencerId;

  FacebookCredentialRequested(this.influencerId);
}

class LogoutRequested extends AuthEvent {}

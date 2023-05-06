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
  final String bankAccount;
  final String bankAccountName;
  final String bankAccountNumber;
  final String gender;
  final String location;
  final List<String> categoryList;

  RegisterRequested(
      this.email,
      this.password,
      this.fullname,
      this.bankAccount,
      this.bankAccountName,
      this.bankAccountNumber,
      this.gender,
      this.location,
      this.categoryList);
}

class ChangePasswordRequested extends AuthEvent {
  final String oldPassword;
  final String newPassword;
  ChangePasswordRequested(this.oldPassword, this.newPassword);
}

class CheckEmailIsUsed extends AuthEvent {
  final String email;
  CheckEmailIsUsed(this.email);
}

class CheckIsUserLoggedIn extends AuthEvent {}

class GoogleLoginRegisterRequested extends AuthEvent {
  final String email;
  final String fullname;
  final String location;
  final String bankAccount;
  final String bankAccountName;
  final String bankAccountNumber;
  final String gender;
  final List<String> categoryList;
  final String id;

  GoogleLoginRegisterRequested(
      this.email,
      this.fullname,
      this.location,
      this.bankAccount,
      this.bankAccountName,
      this.bankAccountNumber,
      this.gender,
      this.categoryList,
      this.id);
}

class GoogleLoginRequested extends AuthEvent {}

class FacebookCredentialRequested extends AuthEvent {
  final String influencerId;

  FacebookCredentialRequested(this.influencerId);
}

class LogoutRequested extends AuthEvent {}

class VerifyEmailReqested extends AuthEvent {}

class TriggerUnAuthenticated extends AuthEvent {}

class ForgotPasswordRequested extends AuthEvent {
  final String email;

  ForgotPasswordRequested(this.email);

  @override
  List<Object> get props => [email];
}

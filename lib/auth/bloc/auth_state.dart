part of 'auth_bloc.dart';

abstract class AuthState extends Equatable {}

class Loading extends AuthState {
  @override
  List<Object?> get props => [];
}

class Authenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class UnAuthenticated extends AuthState {
  @override
  List<Object?> get props => [];
}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);

  @override
  List<Object?> get props => [error];
}

class FacebookCredentialSuccess extends AuthState {
  final String? influencerId;
  final String? facebookAccessToken;
  final String? instagramUserId;

  FacebookCredentialSuccess(this.influencerId, this.facebookAccessToken, this.instagramUserId);

  @override
  List<Object?> get props => [influencerId, facebookAccessToken, instagramUserId];
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


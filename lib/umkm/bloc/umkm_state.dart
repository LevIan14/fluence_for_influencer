part of 'umkm_bloc.dart';

abstract class UmkmState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UmkmInitial extends UmkmState {}

class UmkmNameLoading extends UmkmState {}

class UmkmNameLoaded extends UmkmState {
  final String umkmName;
  final String profileImageUmkmUrl;

  UmkmNameLoaded(this.umkmName, this.profileImageUmkmUrl);

  @override
  List<Object> get props => [umkmName, profileImageUmkmUrl];
}

class UmkmError extends UmkmState {
  final String error;

  UmkmError(this.error);

  @override
  List<Object?> get props => [error];
}

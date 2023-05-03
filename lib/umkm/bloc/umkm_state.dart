part of 'umkm_bloc.dart';

abstract class UmkmState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UmkmInitial extends UmkmState {}

class UmkmLoaded extends UmkmState {
  final Umkm umkm;
  UmkmLoaded(this.umkm);

  @override
  List<Object?> get props => [];
}

class UmkmLoading extends UmkmState {}

class UmkmError extends UmkmState {
  final String error;

  UmkmError(this.error);

  @override
  List<Object?> get props => [error];
}

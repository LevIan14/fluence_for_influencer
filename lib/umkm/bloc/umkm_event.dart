part of 'umkm_bloc.dart';

abstract class UmkmEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetUmkmName extends UmkmEvent {
  final String umkmId;

  GetUmkmName(this.umkmId);

  @override
  List<Object> get props => [umkmId];
}

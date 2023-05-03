part of 'umkm_bloc.dart';

abstract class UmkmEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetUmkmDetail extends UmkmEvent {
  final String umkmId;

  GetUmkmDetail(this.umkmId);

  @override
  List<Object> get props => [umkmId];
}

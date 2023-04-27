part of 'umkm_bloc.dart';

abstract class UmkmEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetUmkmNameAndImage extends UmkmEvent {
  final String umkmId;

  GetUmkmNameAndImage(this.umkmId);

  @override
  List<Object> get props => [umkmId];
}

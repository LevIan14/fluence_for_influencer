import 'package:equatable/equatable.dart';
import 'package:fluence_for_influencer/umkm/repository/umkm_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'umkm_event.dart';
part 'umkm_state.dart';

class UmkmBloc extends Bloc<UmkmEvent, UmkmState> {
  final UmkmRepository umkmRepository;

  UmkmBloc({required this.umkmRepository}) : super(UmkmInitial()) {
    on<GetUmkmNameAndImage>((event, emit) async {
      try {
        emit(UmkmNameLoading());
        final dynamic umkm = await umkmRepository.getUmkmDetail(event.umkmId);
        emit(UmkmNameLoaded(umkm['fullname'], umkm['avatar_url']));
      } catch (e) {
        emit(UmkmError(e.toString()));
      }
    });
  }
}

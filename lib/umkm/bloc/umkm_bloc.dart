import 'package:equatable/equatable.dart';
import 'package:fluence_for_influencer/influencer/repository/influencer_repository.dart';
import 'package:fluence_for_influencer/umkm/repository/umkm_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'umkm_event.dart';
part 'umkm_state.dart';

class UmkmBloc extends Bloc<UmkmEvent, UmkmState> {
  final UmkmRepository umkmRepository;

  UmkmBloc({required this.umkmRepository}) : super(UmkmInitial()) {
    on<GetUmkmName>((event, emit) async {
      try {
        emit(UmkmNameLoading());
        final String umkmName = await umkmRepository.getUmkmName(event.umkmId);
        emit(UmkmNameLoaded(umkmName));
      } catch (e) {
        emit(UmkmError(e.toString()));
      }
    });
  }
}

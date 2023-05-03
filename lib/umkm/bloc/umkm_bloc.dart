import 'package:equatable/equatable.dart';
import 'package:fluence_for_influencer/category/repository/category_repository.dart';
import 'package:fluence_for_influencer/models/category_type.dart';
import 'package:fluence_for_influencer/umkm/model/umkm.dart';
import 'package:fluence_for_influencer/umkm/repository/umkm_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'umkm_event.dart';
part 'umkm_state.dart';

class UmkmBloc extends Bloc<UmkmEvent, UmkmState> {
  final UmkmRepository umkmRepository;
  final CategoryRepository categoryRepository;

  UmkmBloc({required this.umkmRepository, required this.categoryRepository})
      : super(UmkmInitial()) {
    on<GetUmkmDetail>((event, emit) async {
      try {
        emit(UmkmLoading());
        late Umkm umkm;
        umkm = await umkmRepository.getUmkmDetail(event.umkmId);
        List<CategoryType> categoryTypeList =
            await categoryRepository.getCategoryTypeList();
        List<CategoryType> umkmCategoryList = [];
        for (var category in umkm.categoryType) {
          CategoryType element = categoryTypeList
              .firstWhere((element) => element.categoryTypeId == category);
          umkmCategoryList.add(element);
        }
        umkm.categoryType = umkmCategoryList;
        emit(UmkmLoaded(umkm));
      } catch (e) {
        emit(UmkmError(e.toString()));
      }
    });
  }
}

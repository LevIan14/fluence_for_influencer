// import 'dart:developer';

// import 'package:equatable/equatable.dart';
// import 'package:fluence_for_influencer/models/category_type.dart';
// import 'package:fluence_for_influencer/category/repository/category_repository.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// part 'category_event.dart';
// part 'category_state.dart';

// class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {

//   final CategoryRepository categoryRepository;
  
//   CategoryBloc({required this.categoryRepository}) : super(CategoryInitial()) {
//     // on<GetCategoryTypeListRequested>((event, emit) async {
//       emit(CategoryLoading());
//       try {
//         List<CategoryType> categoryList = await categoryRepository.getCategoryTypeList();
//         emit(CategoryLoaded(categoryList));
//       } catch (e) {
//         emit(CategoryError(e.toString()));
//       }
//   });
  
//   }

// }
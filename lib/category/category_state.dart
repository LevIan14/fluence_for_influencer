part of 'category_bloc.dart';

abstract class CategoryState extends Equatable {}

class CategoryInitial extends CategoryState {
  CategoryInitial();

  @override
  List<Object> get props => [];
}

class CategoryLoading extends CategoryState {
  CategoryLoading();

  @override
  List<Object> get props => [];
}

class CategoryLoaded extends CategoryState {
  final List<CategoryType> categoryList;
  CategoryLoaded(this.categoryList);
  
  @override
  List<Object> get props => categoryList;
}

class CategoryError extends CategoryState {
  final String error;
  CategoryError(this.error);

   @override
  List<Object> get props => [error];
}


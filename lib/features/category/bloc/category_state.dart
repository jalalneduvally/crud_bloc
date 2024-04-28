part of 'category_bloc.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

class CategoryLoadingState extends CategoryState{}

class ReadCategoryState extends CategoryState {
  final List<CategoryModel> categories;
  ReadCategoryState({required this.categories});
}

class CategoryError extends CategoryState {
  final String error;
  CategoryError({required this.error});
}
class AddCategoryLoading extends CategoryState{
  bool loading;
  AddCategoryLoading({required this.loading});
}
class UpdateCategoryLoading extends CategoryState{
  bool loading;
  UpdateCategoryLoading({required this.loading});
}
// class DropDownUpdated extends CategoryState{
//   final String selectedValue;
//   DropDownUpdated(this.selectedValue);
// }
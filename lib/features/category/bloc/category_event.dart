part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}

class FetchCategories extends CategoryEvent {}

class AddCategoryEvent extends CategoryEvent {
  final String name;
  final bool active;
  final BuildContext context;
  AddCategoryEvent({required this.context,
    required this.name,required this.active});
}

class UpdateCategoryEvent extends CategoryEvent {
  final CategoryModel category;
  final String name;
  final bool active;
  final BuildContext context;
  UpdateCategoryEvent({required this.context, required this.name,
    required this.active,required this.category});
}

// class DropDownChanged extends CategoryEvent{
//   final String selectedValue;
//   DropDownChanged(this.selectedValue);
// }
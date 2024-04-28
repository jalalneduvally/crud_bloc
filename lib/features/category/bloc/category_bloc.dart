import 'package:bloc/bloc.dart';
import 'package:crud_bloc/models/category_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

import '../repository/category_repository.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository categoryRepository;
  CategoryBloc(this.categoryRepository) : super(CategoryInitial()) {
    on<AddCategoryEvent>((event, emit)async{
      emit(AddCategoryLoading(loading: true));
      await categoryRepository.addCategory(name:event.name, active: event.active).then((value){
        // emit(AddProductLoading(loading: false));
        Future.delayed( const Duration(milliseconds: 500),(){
          Navigator.pop(event.context);
        });
      }).onError((error, stackTrace){
        emit(AddCategoryLoading(loading: false));
      });
    });

    // on<DropDownChanged>((event, emit)async {
    //   emit(DropDownUpdated(event.selectedValue));
    // });

    on<FetchCategories>((event, emit)async{
      emit(CategoryLoadingState());
      try{
        await  emit.forEach(categoryRepository.getCategories(), onData: (List<CategoryModel> categories){
          return ReadCategoryState(categories: categories);
        });
      }catch(e,s){
        print(e);
        print(s);
        emit(CategoryError(error: e.toString()));
      }
    });

    on<UpdateCategoryEvent>((event, emit)async{
      emit(UpdateCategoryLoading(loading: true));

      await categoryRepository.updateCategory(name: event.name, active: event.active,
          category: event.category).then((value){
        // emit(UpdateProductLoading(loading: false));
        Future.delayed( const Duration(milliseconds: 500),(){
          Navigator.pop(event.context);
        });
      }).onError((error, stackTrace) {
        emit(UpdateCategoryLoading(loading: false));
      });
    });
  }
}

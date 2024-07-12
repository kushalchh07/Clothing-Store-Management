import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:nepstyle_management_system/models/category_model.dart';
import 'package:nepstyle_management_system/services/crud_services.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<CategoryLoadEvent>(_categoryLoadEvent);
    on<CategoryAddButtonTappedEvent>(_categoryAddButtonTappedEvent);
    on<CategoryUpdateButtonTappedEvent>(_categoryUpdateButtonTappedEvent);
    on<CategoryDeleteButtonTappedEvent>(_categoryDeleteButtonTappedEvent);
  }
  CrudServices _crudServices = CrudServices();
  FutureOr<void> _categoryLoadEvent(
      CategoryLoadEvent event, Emitter<CategoryState> emit) async {
    try {
      await _crudServices.getCategory().then((value) {
        emit(CategoryLoaded(category: value));
      });
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  FutureOr<void> _categoryAddButtonTappedEvent(
      CategoryAddButtonTappedEvent event, Emitter<CategoryState> emit) async {
    try {
      await _crudServices.addCategory(
          event.id, event.categoryName, event.quantity);
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  FutureOr<void> _categoryUpdateButtonTappedEvent(
      CategoryUpdateButtonTappedEvent event,
      Emitter<CategoryState> emit) async {
    try {
      await _crudServices.updateCategory(
          event.id, event.categoryName, event.quantity);
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }

  FutureOr<void> _categoryDeleteButtonTappedEvent(
      CategoryDeleteButtonTappedEvent event,
      Emitter<CategoryState> emit) async {
    try {
      await _crudServices.deleteCategory(event.id);
    } catch (e) {
      emit(CategoryError(message: e.toString()));
    }
  }
}

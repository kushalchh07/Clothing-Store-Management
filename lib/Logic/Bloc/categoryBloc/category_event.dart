part of 'category_bloc.dart';

@immutable
sealed class CategoryEvent {}

class CategoryLoadEvent extends CategoryEvent {}

class CategoryAddButtonTappedEvent extends CategoryEvent {
  CategoryAddButtonTappedEvent({
    required this.categoryName,
    required this.quantity,
    required this.id,
  });
  final String categoryName;
  final String quantity;
  final String id;
}

class CategoryUpdateButtonTappedEvent extends CategoryEvent {
  CategoryUpdateButtonTappedEvent({
    required this.id,
    required this.categoryName,
    required this.quantity,
  });
  final String id;
  final String categoryName;
  final String quantity;
}

class CategoryDeleteButtonTappedEvent extends CategoryEvent {
  CategoryDeleteButtonTappedEvent({
    required this.id,
  });
  final String id;
}

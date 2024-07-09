part of 'order_bloc.dart';

@immutable
sealed class OrderState {}

final class OrderInitial extends OrderState {}
final class OrderLoadingState extends OrderState {}

final class OrderLoadSuccessState extends OrderState {
  final List<OrderModel> orders;
  OrderLoadSuccessState({required this.orders});
}

final class OrderLoadErrorState extends OrderState {}

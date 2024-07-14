part of 'dashboard_bloc.dart';

@immutable
sealed class DashboardState {}

final class DashboardInitial extends DashboardState {}

final class DashboardLoadingState extends DashboardInitial {}

final class DashboardLoadedState extends DashboardInitial {
  final int categorycount;
  // final int purchasecount;
  // final int salescount;
  // final int ordercount;
  final int suppliercount;
  final int customercount;
  final int productcount;
  DashboardLoadedState(
      {required this.categorycount,
      // required this.purchasecount,
      // required this.salescount,
      required this.productcount,
      // required this.ordercount,
      required this.suppliercount,
      required this.customercount});
}

final class DashboardErrorState extends DashboardInitial {}

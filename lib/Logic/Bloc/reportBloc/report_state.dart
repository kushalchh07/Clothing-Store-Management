part of 'report_bloc.dart';

@immutable
sealed class ReportState {}

final class ReportInitial extends ReportState {}
final class ReportLoading extends ReportState {}  

final class ReportLoaded extends ReportState {  
  final List<StockDataModel> report;
  ReportLoaded({required this.report});
}
final class ReportError extends ReportState {
  final String message;
  ReportError({required this.message});
}

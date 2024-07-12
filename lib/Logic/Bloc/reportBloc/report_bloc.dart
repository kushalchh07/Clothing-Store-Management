import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'report_event.dart';
part 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  ReportBloc() : super(ReportInitial()) {
    on<ReportEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}

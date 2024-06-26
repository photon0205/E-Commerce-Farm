import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  FilterBloc() : super(FilterInitial()) {
    on<FilterSetEvent>((event, emit) {
      List<String> strList = event.filterCat!;
      emit(FilterSet(strList,event.from,event.to));
    });
    on<FilterResetEvent>((event, emit) => emit(FilterInitial()));
  }
}

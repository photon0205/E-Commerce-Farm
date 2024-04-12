import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'sort_by_event.dart';
part 'sort_by_state.dart';

class SortByBloc extends Bloc<SortByEvent, SortByState> {
  SortByBloc() : super(SortByInitial()) {
    on<SortByRating>((event, emit) {
      emit(SortedByRating(event.str));
    });
    on<SortByPrice>((event, emit) {
      emit(SortedByPrice(event.str));
    });
    on<SortEnded>((event, emit) {
      emit(SortByInitial());
    });
  }
}

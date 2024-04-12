import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(SearchInitial()) {
    on<SearchStart>((event, emit) {
      emit(Searched());
    });
    on<SearchEnd>((event, emit) {
      emit(SearchInitial());
    });
  }
}

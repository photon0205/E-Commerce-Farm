import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_view_event.dart';
part 'home_view_state.dart';

class HomeViewBloc extends Bloc<HomeViewEvent, HomeViewState> {
  HomeViewBloc() : super(HomeViewInitial()) {
    on<SearchBarEvent>((event, emit) {
      emit(SearchBarState());
    });
    on<CategoryEvent>((event, emit) {
      emit(CategoryPageState(event.category));
    });
    on<HomePageEvent>((event, emit) {
      emit(HomeViewInitial());
    });
  }
}

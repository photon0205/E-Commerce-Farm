import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeNavigate>((event, emit) {
      emit(Home_Page());
    });
    on<ProfileNavigate>((event, emit) {
      emit(ProfilePage());
    });
    on<AddProductNavigate>((event, emit) {
      emit(AddProductPage());
    });
  }
}

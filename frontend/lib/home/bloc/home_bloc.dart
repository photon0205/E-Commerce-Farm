import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<HomeNavigate>((event, emit) {
      emit(HomePageState());
    });
    on<SHGNavigate>((event, emit) {
      emit(SHGPageState());
    });
    on<ExploreNavigate>((event, emit) {
      emit(ExplorePageState());
    });
    on<ProfileNavigate>((event, emit) {
      emit(ProfilePageState());
    });
  }
}

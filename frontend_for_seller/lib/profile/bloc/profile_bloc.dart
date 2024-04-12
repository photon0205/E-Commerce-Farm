import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<BackToProfilePage>((event, emit) {
      emit(ProfileInitial());
    });
    on<GotoOrdersPage>((event, emit) {
      emit(OrdersPageState());
    });
    on<GotoProfileEdit>((event, emit) {
      emit(ProfileEditPageState());
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEditEvent>((event, emit) {
      emit(ProfileEdit());
    });
    on<HistoryEvent>((event, emit) {
      emit(History());
    });
    on<WishlistEvent>((event, emit) {
      emit(Wishlist());
    });
    on<HelpEvent>((event, emit) {
      emit(Help());
    });
    on<RateEvent>((event, emit) {
      emit(Rate());
    });
    on<FeedbackEvent>((event, emit) {
      emit(Feedback());
    });
    on<BackEvent>((event, emit) {
      emit(ProfileInitial());
    });
  }
}

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'profile_edit_event.dart';
part 'profile_edit_state.dart';

class ProfileEditBloc extends Bloc<ProfileEditEvent, ProfileEditState> {
  ProfileEditBloc() : super(ProfileEditInitial()) {
    on<ProfileDataChanged>((event, emit) {
      emit(DetailsEditted(
          event.name, event.gender, event.dob, event.mobileNumber));
    });
    on<UpdationStarts>(
      (event, emit) {
        emit(Loading());
      },
    );
    on<UpdationComplete>(
      (event, emit) {
        emit(ProfileDataSubmitted());
      },
    );
  }
}

part of 'profile_edit_bloc.dart';

abstract class ProfileEditState extends Equatable {
  const ProfileEditState();

  @override
  List<Object> get props => [];
}

class ProfileEditInitial extends ProfileEditState {}

class ProfileErrorState extends ProfileEditState {
  final String error;

  const ProfileErrorState(this.error);
}

class ProfileLoadingState extends ProfileEditState {}

class ProfileUpdatedState extends ProfileEditState {}

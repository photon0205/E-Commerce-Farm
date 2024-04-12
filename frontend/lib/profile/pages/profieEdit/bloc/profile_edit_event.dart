part of 'profile_edit_bloc.dart';

abstract class ProfileEditEvent extends Equatable {
  const ProfileEditEvent();

  @override
  List<Object> get props => [];
}

class ProfilePicUpload extends ProfileEditEvent {}

class ProfileDataChanged extends ProfileEditEvent {
  final String name;
  final String gender;
  final String dob;
  final String mobileNumber;

  const ProfileDataChanged(this.name, this.gender, this.dob, this.mobileNumber);
}

class UpdationStarts extends ProfileEditEvent {}
class UpdationComplete extends ProfileEditEvent {}

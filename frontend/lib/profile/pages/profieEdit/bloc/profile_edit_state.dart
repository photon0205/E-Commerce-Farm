part of 'profile_edit_bloc.dart';

abstract class ProfileEditState extends Equatable {
  const ProfileEditState();
  
  @override
  List<Object> get props => [];
}

class ProfileEditInitial extends ProfileEditState {}

class ProfilePicUploaded extends ProfileEditState {}

class DetailsEditted extends ProfileEditState {
  final String name;
  final String gender;
  final String dob;
  final String mobileNumber;

  const DetailsEditted(this.name, this.gender, this.dob, this.mobileNumber);

}

class Loading extends ProfileEditState {}

class ProfileDataSubmitted extends ProfileEditState {}

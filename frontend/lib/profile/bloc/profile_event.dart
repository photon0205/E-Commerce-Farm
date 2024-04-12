part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}
class BackEvent extends ProfileEvent {
  
}

class ProfileEditEvent extends ProfileEvent {
  
}

class HistoryEvent extends ProfileEvent {

}

class WishlistEvent extends ProfileEvent {

}

class HelpEvent extends ProfileEvent {

}

class RateEvent extends ProfileEvent {

}

class FeedbackEvent extends ProfileEvent {

}

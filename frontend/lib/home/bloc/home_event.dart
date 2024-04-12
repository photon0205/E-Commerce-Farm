part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class HomeNavigate extends HomeEvent {
  
}

class SHGNavigate extends HomeEvent {

}


class ExploreNavigate extends HomeEvent {

}

class ProfileNavigate extends HomeEvent {

}

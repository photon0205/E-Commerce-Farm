part of 'home_view_bloc.dart';

abstract class HomeViewEvent extends Equatable {
  const HomeViewEvent();

  @override
  List<Object> get props => [];
}

class SearchBarEvent extends HomeViewEvent {}

class CategoryEvent extends HomeViewEvent {
  final String category;

  const CategoryEvent(this.category);
}

class HomePageEvent extends HomeViewEvent {}

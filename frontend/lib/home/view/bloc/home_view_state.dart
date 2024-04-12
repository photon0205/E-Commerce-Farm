part of 'home_view_bloc.dart';

abstract class HomeViewState extends Equatable {
  const HomeViewState();

  @override
  List<Object> get props => [];
}

class HomeViewInitial extends HomeViewState {}

class CategoryPageState extends HomeViewState {
  final String category;

  const CategoryPageState(this.category);
}

class SearchBarState extends HomeViewState {}

part of 'sort_by_bloc.dart';

abstract class SortByState extends Equatable {
  const SortByState();

  @override
  List<Object> get props => [];
}

class SortByInitial extends SortByState {}

class SortedByRating extends SortByState {
  final String str;

  const SortedByRating(this.str);
}

class SortedByPrice extends SortByState {
  final String str;

  const SortedByPrice(this.str);
}

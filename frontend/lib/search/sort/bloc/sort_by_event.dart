part of 'sort_by_bloc.dart';

abstract class SortByEvent extends Equatable {
  const SortByEvent();

  @override
  List<Object> get props => [];
}

class SortByRating extends SortByEvent {
  final String str;

  const SortByRating(this.str);
}

class SortByPrice extends SortByEvent {
  final String str;

  const SortByPrice(this.str);
}

class SortEnded extends SortByEvent {}

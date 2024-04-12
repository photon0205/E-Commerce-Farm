part of 'filter_bloc.dart';

abstract class FilterEvent extends Equatable {
  const FilterEvent();

  @override
  List<Object> get props => [];
}

class FilterSetEvent extends FilterEvent {
  final List<String>? filterCat;
  final String from;
  final String to;

  const FilterSetEvent(this.filterCat, this.from, this.to);
}

class FilterResetEvent extends FilterEvent {}

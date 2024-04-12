part of 'filter_bloc.dart';

abstract class FilterState extends Equatable {
  const FilterState();

  @override
  List<Object> get props => [];
}

class FilterInitial extends FilterState {}

class FilterSet extends FilterState {
  final List<String> filterCat;
  final String from;
  final String to;

  const FilterSet(this.filterCat, this.from, this.to);
}

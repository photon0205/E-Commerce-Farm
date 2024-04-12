import 'package:equatable/equatable.dart';

class Category extends Equatable {
  const Category( 
      {required this.headline,
      required this.subCategories,
      this.description,
      required this.title,
      required this.url});
  final String title;
  final String headline;
  final String url;
  final String? description;
  final List<String?> subCategories;

  String get headline_ => headline;
  String get description_ => description ?? "";
  String get title_ => title;
  String get url_ => url;

  @override
  List<Object?> get props => [title, headline, description];
}

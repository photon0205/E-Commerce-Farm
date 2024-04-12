import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

/// {@template UserI}
/// UserI model
///
/// [UserI.empty] represents an unauthenticated UserI.
/// {@endtemplate}
class UserI extends Equatable {
  UserI.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : id = doc.id,
        email = doc.data()!['email'] as String,
        name = doc.data()!['name'] as String;

  /// {@macro UserI}
  const UserI({
    required this.id,
    this.email,
    this.name,
  });

  /// The current UserI's email address.
  final String? email;

  /// The current UserI's id.
  final String id;

  /// The current UserI's name (display name).
  final String? name;

  /// Empty UserI which represents an unauthenticated UserI.
  static const empty = UserI(id: '');

  /// Convenience getter to determine whether the current UserI is empty.
  bool get isEmpty => this == UserI.empty;

  /// Convenience getter to determine whether the current UserI is not empty.
  bool get isNotEmpty => this != UserI.empty;

  @override
  List<Object?> get props => [email, id, name];

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'id': id,
    };
  }
}

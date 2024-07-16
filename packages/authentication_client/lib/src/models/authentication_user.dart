import 'package:equatable/equatable.dart';

/// User model
///
/// [AuthUser.anonymous] represents an unauthenticated user.
class AuthUser extends Equatable {
  /// {@macro authentication_user}
  const AuthUser({
    required this.id,
    this.email,
    this.name,
  });

  /// The current user's id.
  final String id;

  /// The current user's email address.
  final String? email;

  /// The current user's name (display name).
  final String? name;

  /// Whether the current user is anonymous.
  bool get isAnonymous => this == anonymous;

  /// Anonymous user which represents an unauthenticated user.
  static const anonymous = AuthUser(id: '');

  @override
  List<Object?> get props => [id, email, name];
}

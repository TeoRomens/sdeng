part of 'user_profile_bloc.dart';

enum UserProfileStatus {
  initial,
  togglingNotifications,
  togglingNotificationsFailed,
  togglingNotificationsSucceeded,
  userUpdated,
}

class UserProfileState extends Equatable {
  const UserProfileState({
    required this.status,
    required this.user,
    this.notificationsEnabled = false,
  });

  const UserProfileState.initial()
    : this(
        status: UserProfileStatus.initial,
        user: AuthUser.anonymous,
      );

  final UserProfileStatus status;
  final bool notificationsEnabled;
  final AuthUser user;

  @override
  List<Object?> get props => [status, user];

  UserProfileState copyWith({
    UserProfileStatus? status,
    bool? notificationsEnabled,
    AuthUser? user,
  }) =>
      UserProfileState(
        status: status ?? this.status,
        notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
        user: user ?? this.user,
      );
}

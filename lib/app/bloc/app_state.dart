part of 'app_bloc.dart';

/// Enum representing the status of the application.
///
/// This enum defines the possible states the app can be in:
/// - [AppStatus.ready]: The app is initialized and ready.
/// - [AppStatus.authenticated]: The user is authenticated.
/// - [AppStatus.unauthenticated]: The user is not authenticated.
enum AppStatus {
  ready(),
  authenticated(),
  unauthenticated();

  /// Checks if the current status indicates that the user is logged in.
  bool get isLoggedIn => this == AppStatus.authenticated;
}

/// The state of the application.
///
/// This class holds the current state of the app, including the [AppStatus],
/// the authenticated [User], and other relevant information such as
/// [SdengUser], [homeValues], and [showProfileOverlay].
///
/// The state can be copied with modified values using the [copyWith] method.
class AppState extends Equatable {
  /// Constructs an [AppState] with the given parameters.
  ///
  /// - [status]: The current [AppStatus] of the application.
  /// - [user]: The currently authenticated [User].
  /// - [sdengUser]: Additional user information stored as [SdengUser].
  /// - [homeValues]: A map of dynamic values relevant to the home screen.
  /// - [showProfileOverlay]: A boolean indicating if the profile overlay should be shown.
  const AppState({
    required this.status,
    this.user,
    this.sdengUser,
    this.homeValues,
    this.showProfileOverlay = false,
  });

  /// Constructs an [AppState] for an authenticated user.
  ///
  /// - [user]: The authenticated [User].
  const AppState.authenticated(User user)
      : this(
    status: AppStatus.authenticated,
    user: user,
  );

  /// Constructs an [AppState] for an unauthenticated user.
  const AppState.unauthenticated()
      : this(
    status: AppStatus.unauthenticated,
  );

  /// The current status of the app.
  final AppStatus status;

  /// The currently authenticated user, if any.
  final User? user;

  /// Additional user information, if available.
  final SdengUser? sdengUser;

  /// A map of values relevant to the home screen.
  final Map<String, dynamic>? homeValues;

  /// A flag indicating if the profile overlay should be shown.
  final bool showProfileOverlay;

  @override
  List<Object?> get props => [
    status,
    user,
    sdengUser,
    homeValues,
    showProfileOverlay,
  ];

  /// Returns a copy of this [AppState] with the given fields updated.
  ///
  /// - [status]: The new status of the application.
  /// - [user]: The new authenticated user.
  /// - [sdengUser]: The new additional user information.
  /// - [homeValues]: The new map of values relevant to the home screen.
  /// - [showProfileOverlay]: The new value for the profile overlay visibility.
  AppState copyWith({
    AppStatus? status,
    User? user,
    SdengUser? sdengUser,
    Map<String, dynamic>? homeValues,
    bool? showProfileOverlay,
  }) {
    return AppState(
      status: status ?? this.status,
      user: user ?? this.user,
      sdengUser: sdengUser ?? this.sdengUser,
      homeValues: homeValues ?? this.homeValues,
      showProfileOverlay: showProfileOverlay ?? this.showProfileOverlay,
    );
  }
}

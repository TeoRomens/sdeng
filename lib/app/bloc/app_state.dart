part of 'app_bloc.dart';

enum AppStatus {
  ready(),
  authenticated(),
  unauthenticated();

  bool get isLoggedIn =>
      this == AppStatus.authenticated;
}

class AppState extends Equatable {
  const AppState({
    required this.status,
    this.user,
    this.sdengUser,
    this.homeValues,
    this.showProfileOverlay = false,
  });

  const AppState.authenticated(
    User user,
  ) : this(
        status: AppStatus.authenticated,
        user: user,
      );

  const AppState.unauthenticated() : this(
      status: AppStatus.unauthenticated,
  );

  final AppStatus status;
  final User? user;
  final SdengUser? sdengUser;
  final Map<String, dynamic>? homeValues;
  final bool showProfileOverlay;

  @override
  List<Object?> get props => [
    status,
    user,
    sdengUser,
    homeValues,
    showProfileOverlay,
  ];

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
      showProfileOverlay: showProfileOverlay ?? this.showProfileOverlay
    );
  }
}

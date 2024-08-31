import 'dart:async';

import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart';

part 'app_state.dart';

/// The [AppBloc] is responsible for managing the state of the application.
///
/// It handles user authentication and updates the app state accordingly.
/// It listens to user changes from the [UserRepository] and updates the state
/// based on whether the user is authenticated or not.
class AppBloc extends Cubit<AppState> {
  /// Constructs an [AppBloc] with the given [userRepository] and [user].
  ///
  /// If the [user] is `null`, the initial state is unauthenticated.
  /// Otherwise, the initial state is authenticated.
  AppBloc({
    required UserRepository userRepository,
    required User? user,
  })  : _userRepository = userRepository,
        super(
        user == null
            ? const AppState.unauthenticated()
            : AppState.authenticated(user),
      ) {
    _userSubscription = _userRepository.user.listen(onUserChanged);
  }

  final UserRepository _userRepository;
  late final StreamSubscription<User?> _userSubscription;

  /// Called whenever the user changes.
  ///
  /// If the [user] is `null`, the state is updated to unauthenticated.
  /// If the [user] is not `null`, the state is updated to authenticated,
  /// and additional user data and home values are fetched from the repository.
  ///
  /// If certain fields in [sdengUser] are missing, the profile overlay is shown.
  Future<void> onUserChanged(User? user) async {
    if (user == null) {
      return emit(const AppState.unauthenticated());
    }
    else {
      emit(AppState.authenticated(user));
      final sdengUser = await _userRepository.getUserData(user.id);
      final homeValues = await _userRepository.getHomeValues(user.id);
      emit(AppState.authenticated(user).copyWith(
        sdengUser: sdengUser,
        homeValues: homeValues,
        status: AppStatus.ready,
      ));

      if (sdengUser.societyAddress == null ||
          sdengUser.societyEmail == null ||
          sdengUser.societyName == null ||
          sdengUser.societyPhone == null ||
          sdengUser.societyPiva == null) {
        // Wait for the home screen to build the listeners
        await Future.delayed(const Duration(milliseconds: 250));
        emit(state.copyWith(
          showProfileOverlay: true,
        ));
      }
    }
  }

  /// Logs the user out and updates the state to unauthenticated.
  ///
  /// The user's data is cleared from the [UserRepository] before logging out.
  void onLogoutRequested() {
    _userRepository.sdengUser = null;
    unawaited(_userRepository.logOut());
    emit(const AppState.unauthenticated());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}

import 'dart:async';

import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart';

part 'app_state.dart';

class AppBloc extends Cubit<AppState> {
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

  late StreamSubscription<User?> _userSubscription;

  Future<void> onUserChanged(User? user) async {
    switch (state.status) {
      case AppStatus.ready:
      case AppStatus.authenticated:
      case AppStatus.unauthenticated: {
        if(user == null) {
          return emit(const AppState.unauthenticated());
        }
        else {
          emit(AppState.authenticated(user));
          final sdengUser = await _userRepository.getUserData(user.id);
          final homeValues = await _userRepository.getHomeValues(user.id);
          emit(state.copyWith(
            sdengUser: sdengUser,
            homeValues: homeValues,
            status: AppStatus.ready,
          ));
          if (sdengUser.societyAddress == null ||
              sdengUser.societyEmail == null ||
              sdengUser.societyName == null ||
              sdengUser.societyPhone == null ||
              sdengUser.societyPiva == null
          ) {
            // Wait the home screen to build the listeners
            await Future.delayed(const Duration(milliseconds: 250));
            emit(state.copyWith(showProfileOverlay: true,));
          }
        }
      }
    }
  }

  void onLogoutRequested() {
    unawaited(_userRepository.logOut());
    emit(const AppState.unauthenticated());
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }
}

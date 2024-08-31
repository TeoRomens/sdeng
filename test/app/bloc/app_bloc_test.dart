import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_sdeng_api/api.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdeng/app/bloc/app_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:user_repository/user_repository.dart';

class MockUserRepository extends Mock implements UserRepository {}

class MockSdengUser extends Mock implements SdengUser {}

class MockUser extends Mock implements User {}

void main() {
  group('AppBloc', () {
    late UserRepository userRepository;

    setUp(() {
      userRepository = MockUserRepository();

      when(() => userRepository.user).thenAnswer((_) => const Stream.empty());
    });

    test('initial state is unauthenticated when user is null', () {
      expect(
        AppBloc(
          userRepository: userRepository,
          user: null,
        ).state.status,
        equals(AppStatus.unauthenticated),
      );
    });

    group('AppUserChanged', () {
      late User user;
      late SdengUser sdengUser;

      setUp(() {
        user = MockUser();
        sdengUser = MockSdengUser();

        when(() => user.id).thenReturn('id');
        when(() => userRepository.user).thenAnswer((_) => Stream.value(user));
        when(() => userRepository.getUserData(user.id)).thenAnswer((_) async => sdengUser);
        when(() => userRepository.getHomeValues(user.id)).thenAnswer((_) async => {'key': 'value'});
      });

      blocTest<AppBloc, AppState>(
        'emits nothing when state is unauthenticated and user is null',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
                (_) => const Stream.empty(),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          user: null,
        ),
        seed: () => const AppState.unauthenticated(),
        expect: () => <AppState>[],
      );

      blocTest<AppBloc, AppState>(
        'emits authenticated, ready with SdengUser and HomeValues when user changes',
        setUp: () {
          when(() => userRepository.user).thenAnswer(
                (_) => Stream.value(user),
          );
          when(() => user.id).thenReturn('id');
          when(() => userRepository.getUserData(user.id)).thenAnswer((_) async => sdengUser);
          when(() => userRepository.getHomeValues(user.id)).thenAnswer((_) async => {'key': 'value'});
        },
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        act: (bloc) => bloc.onUserChanged(user),
        expect: () => [
          AppState.authenticated(user),
          AppState.authenticated(user).copyWith(
            sdengUser: sdengUser,
            homeValues: {'key': 'value'},
            status: AppStatus.ready,
          ),
        ],
      );

      blocTest<AppBloc, AppState>(
        'emits authenticated, ready, showProfileOverlay when user changes and SdengUser is incomplete',
        setUp: () {
          when(() => sdengUser.societyName).thenReturn(null); // Incomplete SdengUser
          when(() => userRepository.user).thenAnswer(
                (_) => Stream.value(user),
          );
        },
        build: () => AppBloc(
          userRepository: userRepository,
          user: user,
        ),
        act: (bloc) => bloc.onUserChanged(user),
        expect: () => [
          AppState.authenticated(user),
          AppState.authenticated(user).copyWith(
            sdengUser: sdengUser,
            homeValues: {'key': 'value'},
            status: AppStatus.ready,
          ),
          AppState.authenticated(user).copyWith(
            sdengUser: sdengUser,
            homeValues: {'key': 'value'},
            status: AppStatus.ready,
            showProfileOverlay: true,
          ),
        ],
      );

      blocTest<AppBloc, AppState>(
        'emits state with showProfileOverlay true when SdengUser has missing fields',
        build: () {
          final incompleteSdengUser = MockSdengUser();
          when(() => incompleteSdengUser.societyAddress).thenReturn(null);
          when(() => userRepository.getUserData(any())).thenAnswer((_) async => incompleteSdengUser);
          when(() => userRepository.getHomeValues(any())).thenAnswer((_) async => {'key': 'value'});
          return AppBloc(userRepository: userRepository, user: null);
        },
        act: (bloc) => bloc.onUserChanged(user),
        wait: const Duration(milliseconds: 300),
        expect: () => [
          AppState.authenticated(user),
          AppState.authenticated(user).copyWith(
            sdengUser: any(named: 'sdengUser'),
            homeValues: {'key': 'value'},
            status: AppStatus.ready,
          ),
          AppState.authenticated(user).copyWith(
            sdengUser: any(named: 'sdengUser'),
            homeValues: {'key': 'value'},
            status: AppStatus.ready,
            showProfileOverlay: true,
          ),
        ],
      );

      blocTest<AppBloc, AppState>(
        'emits unauthenticated when onLogoutRequested is called',
        build: () {
          when(() => user.id).thenReturn('id');
          return AppBloc(userRepository: userRepository, user: user);
        },
        act: (bloc) => bloc.onLogoutRequested(),
        expect: () => [
          const AppState.unauthenticated(),
        ],
        verify: (_) {
          verify(() => userRepository.logOut()).called(1);
        },
      );
    });
  });
}
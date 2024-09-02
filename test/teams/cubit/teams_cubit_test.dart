import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sdeng/teams/cubit/teams_cubit.dart';
import 'package:teams_repository/teams_repository.dart';

class MockTeamsRepository extends Mock implements TeamsRepository {}

void main() {
  group('TeamsCubit', () {
    late TeamsRepository teamsRepository;
    late TeamsCubit teamsCubit;

    setUp(() {
      teamsRepository = MockTeamsRepository();
      teamsCubit = TeamsCubit(teamsRepository: teamsRepository);
    });

    tearDown(() {
      teamsCubit.close();
    });

    test('initial state is correct', () {
      expect(teamsCubit.state, equals(const TeamsState.initial()));
    });

    group('getTeams', () {
      final teams = [
        Team(id: '1', name: 'Team 1'),
        Team(id: '2', name: 'Team 2'),
      ];

      blocTest<TeamsCubit, TeamsState>(
        'emits [loading, populated] when successful',
        setUp: () {
          when(() => teamsRepository.getTeams())
              .thenAnswer((_) async => teams);
          when(() => teamsRepository.countAthletesInTeam(id: any(named: 'id')))
              .thenAnswer((_) async => 5);
        },
        build: () => teamsCubit,
        act: (cubit) => cubit.getTeams(),
        expect: () => [
          const TeamsState(status: TeamsStatus.loading),
          TeamsState(
            status: TeamsStatus.populated,
            teams: [
              Team(id: '1', name: 'Team 1', numAthletes: 5),
              Team(id: '2', name: 'Team 2', numAthletes: 5),
            ],
            numAthletes: 10,
          ),
        ],
        verify: (_) {
          verify(() => teamsRepository.getTeams()).called(1);
          verify(() => teamsRepository.countAthletesInTeam(id: '1')).called(1);
          verify(() => teamsRepository.countAthletesInTeam(id: '2')).called(1);
        },
      );

      blocTest<TeamsCubit, TeamsState>(
        'emits [loading, failure] when unsuccessful',
        setUp: () {
          when(() => teamsRepository.getTeams())
              .thenThrow(Exception('Failed to get teams'));
        },
        build: () => teamsCubit,
        act: (cubit) => cubit.getTeams(),
        expect: () => [
          const TeamsState(status: TeamsStatus.loading),
          const TeamsState(status: TeamsStatus.failure, error: 'Error loading teams.'),
        ],
        verify: (_) {
          verify(() => teamsRepository.getTeams()).called(1);
        },
      );
    });

    group('addTeam', () {
      final newTeam = Team(id: '3', name: 'New Team');

      blocTest<TeamsCubit, TeamsState>(
        'emits [loading, populated] with updated teams list when successful',
        setUp: () {
          when(() => teamsRepository.addTeam(name: any(named: 'name')))
              .thenAnswer((_) async => newTeam);
        },
        build: () => teamsCubit,
        seed: () => TeamsState(status: TeamsStatus.populated, teams: [Team(id: '1', name: 'Existing Team')]),
        act: (cubit) => cubit.addTeam(name: 'New Team'),
        expect: () => [
          TeamsState(
            status: TeamsStatus.loading,
            teams: [Team(id: '1', name: 'Existing Team')],
          ),
          TeamsState(
            status: TeamsStatus.populated,
            teams: [
              Team(id: '1', name: 'Existing Team'),
              newTeam,
            ],
          ),
        ],
        verify: (_) {
          verify(() => teamsRepository.addTeam(name: 'New Team')).called(1);
        },
      );

      blocTest<TeamsCubit, TeamsState>(
        'emits [loading, failure] when unsuccessful',
        setUp: () {
          when(() => teamsRepository.addTeam(name: any(named: 'name')))
              .thenThrow(Exception('Failed to add team'));
        },
        build: () => teamsCubit,
        act: (cubit) => cubit.addTeam(name: 'New Team'),
        expect: () => [
          const TeamsState(status: TeamsStatus.loading),
          const TeamsState(status: TeamsStatus.failure),
        ],
        verify: (_) {
          verify(() => teamsRepository.addTeam(name: 'New Team')).called(1);
        },
      );
    });
  });
}
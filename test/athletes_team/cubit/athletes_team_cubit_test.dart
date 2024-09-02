import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:teams_repository/teams_repository.dart';
import 'package:sdeng/athletes_team/cubit/athletes_cubit.dart';

class MockAthletesRepository extends Mock implements AthletesRepository {}
class MockTeamsRepository extends Mock implements TeamsRepository {}

void main() {
  late AthletesRepository mockAthletesRepository;
  late TeamsRepository mockTeamsRepository;
  late AthletesCubit athletesCubit;
  late Team testTeam;
  late List<Athlete> testAthletes;

  setUp(() {
    mockAthletesRepository = MockAthletesRepository();
    mockTeamsRepository = MockTeamsRepository();
    testTeam = Team(id: '1', name: 'Team A', numAthletes: 2);
    testAthletes = [
      const Athlete(id: '1', teamId: '1', fullName: 'Athlete 1', taxCode: ''),
      const Athlete(id: '2', teamId: '1', fullName: 'Athlete 2', taxCode: ''),
    ];

    athletesCubit = AthletesCubit(
      athletesRepository: mockAthletesRepository,
      teamsRepository: mockTeamsRepository,
      team: testTeam,
    );
  });

  group('AthletesCubit', () {
    test('initial state is AthletesState.initial()', () {
      expect(athletesCubit.state, AthletesState.initial(team: testTeam));
    });

    blocTest<AthletesCubit, AthletesState>(
      'emits [loading, populated] when getAthletesFromTeam succeeds',
      build: () {
        when(() => mockAthletesRepository.getAthletesFromTeamId(teamId: any(named: 'teamId')))
            .thenAnswer((_) async => testAthletes);
        return athletesCubit;
      },
      act: (cubit) => cubit.getAthletesFromTeam('1'),
      expect: () => [
        AthletesState(team: testTeam, status: AthletesStatus.loading),
        AthletesState(team: testTeam, status: AthletesStatus.populated,
          athletes: testAthletes,
        ),
      ],
      verify: (_) {
        verify(() => mockAthletesRepository.getAthletesFromTeamId(teamId: '1')).called(1);
      },
    );

    blocTest<AthletesCubit, AthletesState>(
      'emits [loading, failure] when getAthletesFromTeam fails',
      build: () {
        when(() => mockAthletesRepository.getAthletesFromTeamId(teamId: any(named: 'teamId')))
            .thenThrow(Exception('Failed to fetch athletes'));
        return athletesCubit;
      },
      act: (cubit) => cubit.getAthletesFromTeam('1'),
      expect: () => [
        AthletesState(team: testTeam, status: AthletesStatus.loading),
        AthletesState(team: testTeam, status: AthletesStatus.failure,
          error: 'Error loading athletes.',
        ),
      ],
      verify: (_) {
        verify(() => mockAthletesRepository.getAthletesFromTeamId(teamId: '1')).called(1);
      },
    );

    blocTest<AthletesCubit, AthletesState>(
      'emits [loading, populated] when deleteAthlete succeeds',
      build: () {
        when(() => mockAthletesRepository.deleteAthlete(id: any(named: 'id')))
            .thenAnswer((_) async {});
        return athletesCubit..emit(
          AthletesState(team: testTeam,
            status: AthletesStatus.populated,
            athletes: testAthletes,
          ),
        );
      },
      act: (cubit) => cubit.deleteAthlete('1'),
      expect: () => [
        AthletesState(team: testTeam,
          status: AthletesStatus.loading,
          athletes: testAthletes,
        ),
        AthletesState(team: testTeam,
          status: AthletesStatus.populated,
          athletes: [testAthletes[1]],
        ),
      ],
      verify: (_) {
        verify(() => mockAthletesRepository.deleteAthlete(id: '1')).called(1);
      },
    );

    blocTest<AthletesCubit, AthletesState>(
      'emits [loading, failure] when deleteAthlete fails',
      build: () {
        when(() => mockAthletesRepository.deleteAthlete(id: any(named: 'id')))
            .thenThrow(Exception('Failed to delete athlete'));
        return athletesCubit..emit(
          AthletesState(team: testTeam,
            status: AthletesStatus.populated,
            athletes: testAthletes,
          ),
        );
      },
      act: (cubit) => cubit.deleteAthlete('1'),
      expect: () => [
        AthletesState(team: testTeam,
          status: AthletesStatus.loading,
          athletes: testAthletes,
        ),
        AthletesState(team: testTeam,
          status: AthletesStatus.failure,
          athletes: testAthletes,
        ),
      ],
      verify: (_) {
        verify(() => mockAthletesRepository.deleteAthlete(id: '1')).called(1);
      },
    );

    blocTest<AthletesCubit, AthletesState>(
      'emits [loading, failure, populated] when deleteTeam fails due to existing athletes',
      build: () => athletesCubit..emit(
        AthletesState.initial(team: testTeam).copyWith(
          status: AthletesStatus.populated,
          athletes: testAthletes,
        ),
      ),
      act: (cubit) => cubit.deleteTeam('1'),
      expect: () => [
        AthletesState(team: testTeam,
          status: AthletesStatus.loading,
          athletes: testAthletes,
        ),
        AthletesState(team: testTeam,
          status: AthletesStatus.failure,
          athletes: testAthletes,
          error: 'Error deleting team. Delete all athletes before deleting.',
        ),
        AthletesState(team: testTeam,
          status: AthletesStatus.populated,
          athletes: testAthletes,
          error: 'You must empty the team before deleting it',
        ),
      ],
    );

    blocTest<AthletesCubit, AthletesState>(
      'emits [loading, teamDeleted] when deleteTeam succeeds with no athletes',
      build: () {
        when(() => mockTeamsRepository.deleteTeam(id: any(named: 'id')))
            .thenAnswer((_) async {});
        return athletesCubit..emit(
          AthletesState(team: testTeam,
            status: AthletesStatus.populated,
            athletes: [],
          ),
        );
      },
      act: (cubit) => cubit.deleteTeam('1'),
      expect: () => [
        AthletesState(team: testTeam,
          status: AthletesStatus.loading,
          athletes: const [],
        ),
        AthletesState(team: testTeam,
          status: AthletesStatus.teamDeleted,
        ),
      ],
      verify: (_) {
        verify(() => mockTeamsRepository.deleteTeam(id: '1')).called(1);
      },
    );

    blocTest<AthletesCubit, AthletesState>(
      'emits [loading, failure] when deleteTeam fails unexpectedly',
      build: () {
        when(() => mockTeamsRepository.deleteTeam(id: any(named: 'id')))
            .thenThrow(Exception('Failed to delete team'));
        return athletesCubit..emit(
          AthletesState.initial(team: testTeam).copyWith(
            status: AthletesStatus.populated,
            athletes: [],
          ),
        );
      },
      act: (cubit) => cubit.deleteTeam('1'),
      expect: () => [
        AthletesState(team: testTeam,
          status: AthletesStatus.loading,
          athletes: [],
        ),
        AthletesState(team: testTeam,
          status: AthletesStatus.failure,
          error: 'Error deleting team.',
        ),
      ],
      verify: (_) {
        verify(() => mockTeamsRepository.deleteTeam(id: '1')).called(1);
      },
    );
  });
}

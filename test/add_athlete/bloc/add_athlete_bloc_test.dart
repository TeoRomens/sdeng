import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:sdeng/add_athlete/cubit/add_athlete_cubit.dart';

class MockAthletesRepository extends Mock implements AthletesRepository {}

class MockAthlete extends Mock implements Athlete {}

void main() {
  late AddAthleteCubit addAthleteCubit;
  late MockAthletesRepository mockAthletesRepository;
  late MockAthlete mockAthlete;

  setUp(() {
    mockAthletesRepository = MockAthletesRepository();
    addAthleteCubit = AddAthleteCubit(
      teamId: 'team-123',
      athletesRepository: mockAthletesRepository,
    );
    mockAthlete = MockAthlete();
  });

  tearDown(() {
    addAthleteCubit.close();
  });

  group('AddAthleteCubit', () {
    test('initial state is correct', () {
      expect(
        addAthleteCubit.state,
        const AddAthleteState(teamId: 'team-123'),
      );
    });

    blocTest<AddAthleteCubit, AddAthleteState>(
      'emits [inProgress, success] when addAthlete succeeds',
      build: () => addAthleteCubit,
      setUp: () {
        when(
              () => mockAthletesRepository.addAthlete(
            teamId: any(named: 'teamId'),
            name: any(named: 'name'),
            surname: any(named: 'surname'),
            taxCode: any(named: 'taxCode'),
            email: any(named: 'email'),
            phone: any(named: 'phone'),
            address: any(named: 'address'),
            birthdate: any(named: 'birthdate'),
          ),
        ).thenAnswer((_) async => mockAthlete);
      },
      act: (cubit) => cubit.addAthlete(
        name: 'John',
        surname: 'Doe',
        taxId: '1234567890',
        email: 'john.doe@example.com',
        phone: '123-456-7890',
        address: '123 Main St',
        birthdate: DateTime(1990, 1, 1),
      ),
      expect: () => [
        const AddAthleteState(teamId: 'team-123', status: FormzSubmissionStatus.inProgress),
        const AddAthleteState(teamId: 'team-123', status: FormzSubmissionStatus.success),
      ],
      verify: (_) {
        verify(
              () => mockAthletesRepository.addAthlete(
            teamId: 'team-123',
            name: 'John',
            surname: 'Doe',
            taxCode: '1234567890',
            email: 'john.doe@example.com',
            phone: '123-456-7890',
            address: '123 Main St',
            birthdate: DateTime(1990, 1, 1),
          ),
        ).called(1);
      },
    );

    blocTest<AddAthleteCubit, AddAthleteState>(
      'emits [inProgress, failure] when addAthlete fails',
      build: () => addAthleteCubit,
      setUp: () {
        when(
              () => mockAthletesRepository.addAthlete(
            teamId: any(named: 'teamId'),
            name: any(named: 'name'),
            surname: any(named: 'surname'),
            taxCode: any(named: 'taxCode'),
            email: any(named: 'email'),
            phone: any(named: 'phone'),
            address: any(named: 'address'),
            birthdate: any(named: 'birthdate'),
          ),
        ).thenThrow(Exception('Athlete addition failed'));
      },
      act: (cubit) => cubit.addAthlete(
        name: 'John',
        surname: 'Doe',
        taxId: '1234567890',
        email: 'john.doe@example.com',
        phone: '123-456-7890',
        address: '123 Main St',
        birthdate: DateTime(1990, 1, 1),
      ),
      expect: () => [
        AddAthleteState(teamId: 'team-123', status: FormzSubmissionStatus.inProgress),
        AddAthleteState(
          teamId: 'team-123',
          status: FormzSubmissionStatus.failure,
          error: 'Error adding athlete, please retry later.',
        ),
      ],
      verify: (_) {
        verify(
              () => mockAthletesRepository.addAthlete(
            teamId: 'team-123',
            name: 'John',
            surname: 'Doe',
            taxCode: '1234567890',
            email: 'john.doe@example.com',
            phone: '123-456-7890',
            address: '123 Main St',
            birthdate: DateTime(1990, 1, 1),
          ),
        ).called(1);
      },
    );

    blocTest<AddAthleteCubit, AddAthleteState>(
      'emits correct state with error message when exception occurs',
      build: () => addAthleteCubit,
      setUp: () {
        when(
              () => mockAthletesRepository.addAthlete(
            teamId: any(named: 'teamId'),
            name: any(named: 'name'),
            surname: any(named: 'surname'),
            taxCode: any(named: 'taxCode'),
            email: any(named: 'email'),
            phone: any(named: 'phone'),
            address: any(named: 'address'),
            birthdate: any(named: 'birthdate'),
          ),
        ).thenThrow(Exception('Athlete addition failed'));
      },
      act: (cubit) => cubit.addAthlete(
        name: 'Jane',
        surname: 'Doe',
        taxId: '9876543210',
        email: 'jane.doe@example.com',
        phone: '098-765-4321',
        address: '456 Elm St',
        birthdate: DateTime(1992, 2, 2),
      ),
      expect: () => [
        AddAthleteState(teamId: 'team-123', status: FormzSubmissionStatus.inProgress),
        AddAthleteState(
          teamId: 'team-123',
          status: FormzSubmissionStatus.failure,
          error: 'Error adding athlete, please retry later.',
        ),
      ],
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:sdeng/repositories/athletes_repository.dart';
import 'package:sdeng/repositories/parents_repository.dart';
import 'package:sdeng/repositories/payments_repository.dart';
import 'package:sdeng/repositories/storage_repository.dart';
import 'package:sdeng/repositories/teams_repository.dart';
import 'package:sdeng/ui/add_athlete/bloc/add_athlete_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:bloc_test/bloc_test.dart';

class MockAthletesRepository extends Mock implements AthletesRepository {}
class MockTeamsRepository extends Mock implements TeamsRepository {}
class MockPaymentsRepository extends Mock implements PaymentsRepository {}
class MockParentsRepository extends Mock implements ParentsRepository {}
class MockStorageRepository extends Mock implements StorageRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AddAthleteBloc', () {
    MockAthletesRepository athletesRepository = MockAthletesRepository();
    MockTeamsRepository teamsRepository = MockTeamsRepository();
    MockPaymentsRepository paymentsRepository = MockPaymentsRepository();
    MockParentsRepository parentsRepository = MockParentsRepository();
    MockStorageRepository storageRepository = MockStorageRepository();

    final getIt = GetIt.I;
    getIt.registerSingleton<TeamsRepository>(teamsRepository);
    getIt.registerSingleton<AthletesRepository>(athletesRepository);
    getIt.registerSingleton<StorageRepository>(storageRepository);
    getIt.registerSingleton<PaymentsRepository>(paymentsRepository);
    getIt.registerSingleton<ParentsRepository>(parentsRepository);

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when nameChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.nameChanged('John Doe'),
      expect: () => [const AddAthleteState(name: 'John Doe')],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when surnameChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.surnameChanged('Smith'),
      expect: () => [const AddAthleteState(surname: 'Smith')],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when numberChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.numberChanged('42'),
      expect: () => [const AddAthleteState(number: 42)],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when birthDayChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.birthDayChanged(DateTime(1990, 5, 15)),
      expect: () => [AddAthleteState(birthDay: DateTime(1990, 5, 15))],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when bornCityChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.bornCityChanged('New York'),
      expect: () => [const AddAthleteState(bornCity: 'New York')],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when addressChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.addressChanged('123 Main St'),
      expect: () => [const AddAthleteState(address: '123 Main St')],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when cityChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.cityChanged('Los Angeles'),
      expect: () => [const AddAthleteState(city: 'Los Angeles')],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when taxIdChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.taxIdChanged('123456789'),
      expect: () => [const AddAthleteState(taxId: '123456789')],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when phoneChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.phoneChanged('555-1234'),
      expect: () => [const AddAthleteState(phone: '555-1234')],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when emailChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.emailChanged('john@example.com'),
      expect: () => [const AddAthleteState(email: 'john@example.com')],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when heightChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.heightChanged('175'),
      expect: () => [const AddAthleteState(secondaRata: 175)],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when weightChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.weightChanged('70'),
      expect: () => [const AddAthleteState(secondaRata: 70)],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when expiringDateChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.expiringDateChanged(DateTime(2023, 12, 31)),
      expect: () => [AddAthleteState(expiringDate: DateTime(2023, 12, 31))],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when rataSwitchChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.rataSwitchChanged(true),
      expect: () => [const AddAthleteState(rataUnica: true)],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when primaRataChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.primaRataChanged('200'),
      expect: () => [const AddAthleteState(primaRata: 200)],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when secondaRataChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.secondaRataChanged('150'),
      expect: () => [const AddAthleteState(secondaRata: 150)],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when parentName is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.parentName('Alice'),
      expect: () => [const AddAthleteState(parentName: 'Alice')],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when parentSurname is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.parentSurname('Smith'),
      expect: () => [const AddAthleteState(parentSurname: 'Smith')],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when parentPhone is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.parentPhone('555-5678'),
      expect: () => [const AddAthleteState(parentPhone: '555-5678')],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when parentEmail is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.parentEmail('alice@example.com'),
      expect: () => [const AddAthleteState(parentEmail: 'alice@example.com')],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when parentTaxId is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.parentTaxId('987654321'),
      expect: () => [const AddAthleteState(parentTaxId: '987654321')],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when submitted is called and form is complete',
      build: () => AddAthleteBloc(),
      act: (bloc) {
        bloc.nameChanged('John Doe');
        bloc.surnameChanged('Smith');
        bloc.submitted('teamId');
      },
      expect: () => [
        const AddAthleteState(status: Status.submitting),
        const AddAthleteState(status: Status.success)
      ],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when submitted is called and form is incomplete',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.submitted('teamId'),
      expect: () => [
        const AddAthleteState(status: Status.submitting),
        const AddAthleteState(errorMessage: 'Complete all the fields', status: Status.failure)
      ],
    );

    blocTest<AddAthleteBloc, AddAthleteState>(
      'emits [AddAthleteState] when stepChanged is called',
      build: () => AddAthleteBloc(),
      act: (bloc) => bloc.stepChanged(1),
      expect: () => [const AddAthleteState(currentStep: 1)],
    );

  });
}

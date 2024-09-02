import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:documents_repository/documents_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medicals_repository/medicals_repository.dart';
import 'package:mocktail/mocktail.dart';
import 'package:payments_repository/payments_repository.dart';
import 'package:sdeng/athlete/cubit/athlete_cubit.dart';
import 'package:user_repository/user_repository.dart';

class MockAthletesRepository extends Mock implements AthletesRepository {}
class MockMedicalsRepository extends Mock implements MedicalsRepository {}
class MockPaymentsRepository extends Mock implements PaymentsRepository {}
class MockDocumentsRepository extends Mock implements DocumentsRepository {}
class MockUserRepository extends Mock implements UserRepository {}

class MockParent extends Mock implements Parent {}
class MockMedical extends Mock implements Medical {}
class MockPaymentFormula extends Mock implements PaymentFormula {}
class MockSdengUser extends Mock implements SdengUser {}

void main() {
  late MockAthletesRepository athletesRepository;
  late MockMedicalsRepository medicalsRepository;
  late MockPaymentsRepository paymentsRepository;
  late MockDocumentsRepository documentsRepository;
  late MockUserRepository userRepository;
  late AthleteCubit athleteCubit;
  late Parent parent;
  late Medical medical;
  late PaymentFormula paymentFormula;

  const athleteId = '1';
  const athlete = Athlete(id: athleteId, teamId: '1', fullName: 'Athlete 1',taxCode: '' );
  const sdengUser = SdengUser(id: 'id');

  setUpAll(() {
    registerFallbackValue(athlete);
    registerFallbackValue(sdengUser);
  });

  setUp(() {
    athletesRepository = MockAthletesRepository();
    medicalsRepository = MockMedicalsRepository();
    paymentsRepository = MockPaymentsRepository();
    documentsRepository = MockDocumentsRepository();
    userRepository = MockUserRepository();

    parent = MockParent();
    medical = MockMedical();
    paymentFormula = MockPaymentFormula();

    athleteCubit = AthleteCubit(
      athletesRepository: athletesRepository,
      medicalsRepository: medicalsRepository,
      paymentsRepository: paymentsRepository,
      documentsRepository: documentsRepository,
      userRepository: userRepository,
      athleteId: athleteId,
      athlete: athlete,
    );
  });

  group('AthleteCubit', () {
    test('initial state is correct', () {
      expect(athleteCubit.state, const AthleteState.initial(athleteId: athleteId, athlete: athlete));
    });

    blocTest<AthleteCubit, AthleteState>(
      'emits [loading, loaded] when initLoading succeeds',
      setUp: () {
        when(() => athletesRepository.getAthleteFromId(athleteId)).thenAnswer((_) async => athlete);
        when(() => athletesRepository.getParentFromAthleteId(athleteId)).thenAnswer((_) async => parent);
        when(() => medicalsRepository.getMedicalFromAthleteId(athleteId)).thenAnswer((_) async => medical);
        when(() => paymentsRepository.getPaymentsFromAthleteId(athleteId)).thenAnswer((_) async => <Payment>[]);
        when(() => documentsRepository.getDocumentsFromAthleteId(athleteId: athleteId)).thenAnswer((_) async => <Document>[]);
        when(() => paymentsRepository.getPaymentFormulaFromAthleteId(athleteId)).thenAnswer((_) async => paymentFormula);
      },
      build: () => athleteCubit,
      act: (cubit) => cubit.initLoading(),
      expect: () => [
        const AthleteState(
          status: AthleteStatus.loading,
          athleteId: athleteId,
          athlete: athlete
        ),
        AthleteState(
          status: AthleteStatus.loaded,
          athleteId: athleteId,
          athlete: athlete,
          parent: parent,
          medical: medical,
          payments: const [],
          documents: const [],
          paymentFormula: paymentFormula,
        ),
      ],
    );

    blocTest<AthleteCubit, AthleteState>(
      'emits [loading, failure] when initLoading fails',
      setUp: () {
        when(() => athletesRepository.getAthleteFromId(athleteId)).thenThrow(Exception('Error loading athlete'));
        when(() => athletesRepository.getParentFromAthleteId(athleteId)).thenThrow(Exception('Error loading parent'));
        when(() => medicalsRepository.getMedicalFromAthleteId(athleteId)).thenThrow(Exception('Error loading medical'));
        when(() => paymentsRepository.getPaymentsFromAthleteId(athleteId)).thenThrow(Exception('Error loading payments'));
        when(() => documentsRepository.getDocumentsFromAthleteId(athleteId: athleteId)).thenThrow(Exception('Error loading documents'));
        when(() => paymentsRepository.getPaymentFormulaFromAthleteId(athleteId)).thenThrow(Exception('Error loading payment formula'));
      },
      build: () => athleteCubit,
      act: (cubit) => cubit.initLoading(),
      expect: () => [
        const AthleteState(
          status: AthleteStatus.loading,
          athleteId: athleteId,
          athlete: athlete,
        ),
        const AthleteState(
          status: AthleteStatus.failure,
          athleteId: athleteId,
          athlete: athlete,
          error: 'Error while loading.'
        ),
      ],
    );

    blocTest<AthleteCubit, AthleteState>(
      'emits [loading, loaded] when reloadAthlete succeeds',
      setUp: () {
        when(() => athletesRepository.getAthleteFromId(athleteId)).thenAnswer((_) async => athlete);
      },
      build: () => athleteCubit,
      act: (cubit) => cubit.reloadAthlete(),
      expect: () => [
        athleteCubit.state.copyWith(status: AthleteStatus.loading),
        athleteCubit.state.copyWith(status: AthleteStatus.loaded, athlete: athlete),
      ],
    );

    blocTest<AthleteCubit, AthleteState>(
      'emits [loading, failure] when reloadAthlete fails',
      setUp: () {
        when(() => athletesRepository.getAthleteFromId(athleteId)).thenThrow(Exception('Error loading athlete'));
      },
      build: () => athleteCubit,
      act: (cubit) => cubit.reloadAthlete(),
      expect: () => [
        const AthleteState(
          status: AthleteStatus.loading,
          athleteId: athleteId,
          athlete: athlete,
        ),
        const AthleteState(
            status: AthleteStatus.failure,
            athleteId: athleteId,
            athlete: athlete,
            error: 'Error while loading athlete.'
        ),
      ],
    );

    blocTest<AthleteCubit, AthleteState>(
      'emits [loading, loaded] when reloadParent succeeds',
      setUp: () {
        when(() => athletesRepository.getParentFromAthleteId(athleteId)).thenAnswer((_) async => parent);
      },
      build: () => athleteCubit,
      act: (cubit) => cubit.reloadParent(),
      expect: () => [
        const AthleteState(
          status: AthleteStatus.loading,
          athleteId: athleteId,
          athlete: athlete,
        ),
        AthleteState(
          status: AthleteStatus.loaded,
          athleteId: athleteId,
          athlete: athlete,
          parent: parent
        ),
      ],
    );

    blocTest<AthleteCubit, AthleteState>(
      'emits [loading, failure] when reloadParent fails',
      setUp: () {
        when(() => athletesRepository.getParentFromAthleteId(athleteId)).thenThrow(Exception('Error loading parent'));
      },
      build: () => athleteCubit,
      act: (cubit) => cubit.reloadParent(),
      expect: () => [
        const AthleteState(
          status: AthleteStatus.loading,
          athleteId: athleteId,
          athlete: athlete,
        ),
        const AthleteState(
          status: AthleteStatus.failure,
          athleteId: athleteId,
          athlete: athlete,
          error: 'Error while loading parent.'
        ),
      ],
    );

    blocTest<AthleteCubit, AthleteState>(
      'emits [loading, loaded] when reloadMedical succeeds',
      setUp: () {
        when(() => medicalsRepository.getMedicalFromAthleteId(athleteId)).thenAnswer((_) async => medical);
      },
      build: () => athleteCubit,
      act: (cubit) => cubit.reloadMedical(),
      expect: () => [
        const AthleteState(
          status: AthleteStatus.loading,
          athleteId: athleteId,
          athlete: athlete,
        ),
        AthleteState(
          status: AthleteStatus.loaded,
          athleteId: athleteId,
          athlete: athlete,
          medical: medical
        ),
      ],
    );

    blocTest<AthleteCubit, AthleteState>(
      'emits [loading, failure] when reloadMedical fails',
      setUp: () {
        when(() => medicalsRepository.getMedicalFromAthleteId(athleteId)).thenThrow(Exception('Error loading medical'));
      },
      build: () => athleteCubit,
      act: (cubit) => cubit.reloadMedical(),
      expect: () => [
        const AthleteState(
          status: AthleteStatus.loading,
          athleteId: athleteId,
          athlete: athlete,
        ),
        const AthleteState(
            status: AthleteStatus.failure,
            athleteId: athleteId,
            athlete: athlete,
            error: 'Error while loading medical visit.'
        ),
      ],
    );

    blocTest<AthleteCubit, AthleteState>(
      'emits [loading, failure] when generateRichiestaVisitaMedica fails',
      setUp: () {
        when(() => documentsRepository.generateRichiestaVisitaMedica(athlete: any(named: 'athlete'), user: any(named: 'user'))).thenThrow(Exception('Error generating Visita Medica'));
      },
      build: () => athleteCubit,
      act: (cubit) => cubit.generateRichiestaVisitaMedica(),
      expect: () => [
        athleteCubit.state.copyWith(status: AthleteStatus.failure, error: 'Error generating Visita Medica.'),
      ],
    );
  });
}

import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';

part 'add_athlete_state.dart';

/// Cubit for managing the state of adding a new athlete.
class AddAthleteCubit extends Cubit<AddAthleteState> {
  /// Creates an [AddAthleteCubit].
  ///
  /// The [teamId] is required to associate the new athlete with a team.
  /// The [athletesRepository] is used to perform the actual addition of the athlete.
  AddAthleteCubit({
    required String teamId,
    required AthletesRepository athletesRepository,
  })  : _athletesRepository = athletesRepository,
        super(AddAthleteState(teamId: teamId));

  final AthletesRepository _athletesRepository;

  /// Adds a new athlete with the provided information.
  ///
  /// [name], [surname], and [taxId] are required fields.
  /// [email], [phone], [address], and [birthdate] are optional.
  ///
  /// Emits [FormzSubmissionStatus.inProgress] while adding the athlete,
  /// [FormzSubmissionStatus.success] if successful, or
  /// [FormzSubmissionStatus.failure] if an error occurs.
  Future<void> addAthlete({
    required String name,
    required String surname,
    required String taxId,
    String? email,
    String? phone,
    String? address,
    DateTime? birthdate,
  }) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _athletesRepository.addAthlete(
        teamId: state.teamId,
        name: name,
        surname: surname,
        taxCode: taxId,
        email: email,
        phone: phone,
        address: address,
        birthdate: birthdate,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure, error: 'Error adding athlete, please retry later.'));
      addError(error, stackTrace);
    }
  }
}
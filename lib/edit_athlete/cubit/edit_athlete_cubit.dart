import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';

part 'edit_athlete_state.dart';

/// `EditAthleteCubit` is responsible for handling the logic related to
/// editing and updating an athlete's information. It manages the state of
/// the form, communicates with the `AthletesRepository` to persist changes,
/// and emits state changes for the UI to react accordingly.
class EditAthleteCubit extends Cubit<EditAthleteState> {

  /// Constructs an `EditAthleteCubit` with the initial athlete data and
  /// the repository to handle updates.
  ///
  /// The constructor initializes the state with the provided athlete and
  /// keeps a reference to the `AthletesRepository` for updating the athlete.
  ///
  /// * [athlete] - The initial data of the athlete that will be edited.
  /// * [athletesRepository] - The repository that will handle updating
  ///   the athlete's information.
  EditAthleteCubit({
    required Athlete athlete,
    required AthletesRepository athletesRepository,
  })  : _athletesRepository = athletesRepository,
        super(EditAthleteState(athlete: athlete));

  /// The repository for performing athlete-related operations.
  final AthletesRepository _athletesRepository;

  /// Updates the athlete's information and emits the updated state.
  ///
  /// This method takes the updated athlete information as parameters and
  /// attempts to update the athlete using the `AthletesRepository`. It emits
  /// a `FormzSubmissionStatus.inProgress` status while the update is in
  /// progress, and either a `FormzSubmissionStatus.success` or
  /// `FormzSubmissionStatus.failure` status depending on the result.
  ///
  /// * [name] - The updated first name of the athlete.
  /// * [surname] - The updated last name of the athlete.
  /// * [taxCode] - The updated tax code of the athlete.
  /// * [email] - The updated email address of the athlete.
  /// * [phone] - The updated phone number of the athlete.
  /// * [address] - The updated address of the athlete.
  /// * [birthdate] - The updated birthdate of the athlete.
  Future<void> updateAthlete({
    String? name,
    String? surname,
    String? taxCode,
    String? email,
    String? phone,
    String? address,
    DateTime? birthdate,
  }) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      // Create an updated athlete instance with the new data.
      final updatedAthlete = state.athlete.copyWith(
        fullName: '$name $surname',
        taxCode: taxCode,
        email: email,
        phone: phone,
        birthDate: birthdate,
        fullAddress: address,
      );

      // Attempt to update the athlete in the repository.
      await _athletesRepository.updateAthlete(athlete: updatedAthlete);

      // Emit the successful state with the updated athlete.
      emit(state.copyWith(
        status: FormzSubmissionStatus.success,
        athlete: updatedAthlete,
      ));
    } catch (error, stackTrace) {
      // Emit a failure status if an error occurs.
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }
}

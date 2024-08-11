import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';

part 'edit_athlete_state.dart';

class EditAthleteCubit extends Cubit<EditAthleteState> {
  EditAthleteCubit({
    required Athlete athlete,
    required AthletesRepository athletesRepository,
  })  : _athletesRepository = athletesRepository,
        super(EditAthleteState(athlete: athlete));

  final AthletesRepository _athletesRepository;

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
      final updatedAthlete = state.athlete.copyWith(
          fullName: '$name $surname',
          taxCode: taxCode,
          email: email,
          phone: phone,
          birthDate: birthdate,
          fullAddress: address);
      await _athletesRepository.updateAthlete(athlete: updatedAthlete);
      emit(state.copyWith(
          status: FormzSubmissionStatus.success, athlete: updatedAthlete));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }
}

import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';

part 'add_athlete_state.dart';

class AddAthleteCubit extends Cubit<AddAthleteState> {
  AddAthleteCubit({
    required String teamId,
    required AthletesRepository athletesRepository,
  })  : _athletesRepository = athletesRepository,
        super(AddAthleteState(teamId: teamId));

  final AthletesRepository _athletesRepository;

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
        birthdate: birthdate
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
  }

}

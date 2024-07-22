import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:user_repository/user_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({
    required UserRepository userRepository,
    required String userId,
    this.sdengUser,
  })  : _userRepository = userRepository,
        super(ProfileState(userId: userId));

  final SdengUser? sdengUser;
  final UserRepository _userRepository;

  Future<SdengUser?> updateProfile({
    required String fullName,
    required String societyName,
    required String societyEmail,
    required String societyPhone,
    required String societyAddress,
    required String societyPiva
  }) async {
    emit(state.copyWith(status: FormzSubmissionStatus.inProgress));
    try {
      await _userRepository.updateUserData(
        userId: state.userId,
        fullName: fullName,
        societyName: societyName,
        societyEmail: societyEmail,
        societyPhone: societyPhone,
        societyAddress: societyAddress,
        societyPiva: societyPiva,
      );
      emit(state.copyWith(status: FormzSubmissionStatus.success));
    } catch (error, stackTrace) {
      emit(state.copyWith(status: FormzSubmissionStatus.failure));
      addError(error, stackTrace);
    }
    return _userRepository.sdengUser;
  }

}

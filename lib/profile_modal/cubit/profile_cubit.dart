import 'package:athletes_repository/athletes_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:form_inputs/form_inputs.dart';
import 'package:user_repository/user_repository.dart';

part 'profile_state.dart';

/// Manages the state for updating a user's profile.
///
/// The `ProfileCubit` is responsible for handling profile updates and managing
/// the state associated with these operations. It interacts with the `UserRepository`
/// to perform updates and notify listeners about the status of these operations.
class ProfileCubit extends Cubit<ProfileState> {
  /// Creates an instance of `ProfileCubit`.
  ///
  /// The [userRepository] is used to interact with the backend service for user data,
  /// while [userId] represents the ID of the user whose profile is being updated.
  /// Optionally, an existing [sdengUser] can be provided.
  ProfileCubit({
    required UserRepository userRepository,
    required String userId,
    this.sdengUser,
  })  : _userRepository = userRepository,
        super(ProfileState(userId: userId));

  /// An optional instance of [SdengUser]. If provided, it represents the
  /// current user whose profile is being managed.
  final SdengUser? sdengUser;

  /// The repository responsible for user data operations.
  final UserRepository _userRepository;

  /// Updates the user's profile with the provided details.
  ///
  /// [fullName] - The full name of the user.
  /// [societyName] - The name of the user's society.
  /// [societyEmail] - The email address of the society.
  /// [societyPhone] - The phone number of the society.
  /// [societyAddress] - The address of the society.
  /// [societyPiva] - The VAT number of the society.
  ///
  /// Emits a state with `FormzSubmissionStatus.inProgress` before starting
  /// the update operation, and updates the state to `FormzSubmissionStatus.success`
  /// upon successful completion.
  /// In case of an error, the state is updated to `FormzSubmissionStatus.failure`.
  ///
  /// Returns the updated `SdengUser` instance from the repository.
  Future<SdengUser?> updateProfile({
    required String fullName,
    required String societyName,
    required String societyEmail,
    required String societyPhone,
    required String societyAddress,
    required String societyPiva,
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

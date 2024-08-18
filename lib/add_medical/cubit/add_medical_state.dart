part of 'add_medical_cubit.dart';

/// Represents the state of adding a medical record for an athlete.
class AddMedicalState extends Equatable {
  /// Creates an instance of [AddMedicalState].
  ///
  /// The [athleteId] parameter is required to identify the athlete for whom
  /// the medical record is being added. The [status] parameter indicates the
  /// current status of the form submission, defaulting to [FormzSubmissionStatus.initial].
  /// The [error] parameter holds any error message that may occur, defaulting to an empty string.
  const AddMedicalState({
    required this.athleteId,
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  /// The ID of the athlete for whom the medical record is being added.
  final String athleteId;

  /// The current status of the form submission.
  ///
  /// This value reflects the state of the form submission process, such as initial,
  /// in progress, success, or failure.
  final FormzSubmissionStatus status;

  /// An error message if the submission fails.
  ///
  /// This is a descriptive message that provides information about what went wrong
  /// during the form submission.
  final String error;

  @override
  List<Object> get props => [athleteId, status, error];

  /// Creates a copy of this [AddMedicalState] with optional new values.
  ///
  /// This method allows for updating the state with new values while preserving
  /// the existing values for any parameters not explicitly provided.
  ///
  /// Parameters:
  /// - [athleteId]: The ID of the athlete (optional).
  /// - [status]: The form submission status (optional).
  /// - [error]: An error message (optional).
  AddMedicalState copyWith({
    String? athleteId,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return AddMedicalState(
      athleteId: athleteId ?? this.athleteId,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

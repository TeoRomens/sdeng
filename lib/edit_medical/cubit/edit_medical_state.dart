part of 'edit_medical_cubit.dart';

/// Represents the state of the medical record editing process.
///
/// This state includes the current medical record being edited, the expiration date,
/// type of the medical record, submission status, and any error message.
class EditMedicalState extends Equatable {
  /// Creates an instance of [EditMedicalState].
  /// 
  /// The [medical] parameter is required to initialize the state with the current
  /// medical record. Other parameters are optional and have default values.
  const EditMedicalState({
    required this.medical,
    this.expire = const EmptyDate.pure(),
    this.type = MedType.not_required,
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  /// The current medical record being edited.
  final Medical medical;

  /// The expiration date of the medical record.
  /// Defaults to an empty, pure date.
  final EmptyDate expire;

  /// The type of the medical record.
  final MedType type;

  /// The status of the submission process.
  /// Can be [FormzSubmissionStatus.initial], [FormzSubmissionStatus.inProgress],
  /// [FormzSubmissionStatus.success], or [FormzSubmissionStatus.failure].
  final FormzSubmissionStatus status;

  /// An error message if the submission fails.
  final String error;

  @override
  List<Object> get props => [medical, expire, type, status, error];

  /// Creates a copy of the current state with optional new values for some properties.
  /// 
  /// This method is used to produce a new state with updated properties while
  /// preserving the others.
  /// 
  /// Parameters:
  /// - [medical]: The updated medical record.
  /// - [expire]: The updated expiration date.
  /// - [type]: The updated type of the medical record.
  /// - [status]: The updated submission status.
  /// - [error]: The updated error message.
  EditMedicalState copyWith({
    Medical? medical,
    EmptyDate? expire,
    MedType? type,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return EditMedicalState(
      medical: medical ?? this.medical,
      expire: expire ?? this.expire,
      type: type ?? this.type,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

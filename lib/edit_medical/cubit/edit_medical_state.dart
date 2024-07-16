part of 'edit_medical_cubit.dart';

class EditParentState extends Equatable {
  const EditParentState({
    required this.medical,
    this.expire = const EmptyDate.pure(),
    this.type,
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  final Medical medical;
  final EmptyDate expire;
  final MedType? type;
  final FormzSubmissionStatus status;
  final String error;

  @override
  List<Object> get props => [medical, status, error];

  EditParentState copyWith({
    Medical? medical,
    EmptyDate? expire,
    MedType? type,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return EditParentState(
      medical: medical ?? this.medical,
      expire: expire ?? this.expire,
      type: type ?? this.type,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

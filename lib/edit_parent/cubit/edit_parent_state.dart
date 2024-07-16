part of 'edit_parent_cubit.dart';

class EditParentState extends Equatable {
  const EditParentState({
    required this.parent,
    this.name = '',
    this.surname = '',
    this.email = const EmptyEmail.pure(),
    this.phone = const EmptyPhoneNumber.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  final Parent parent;
  final String name;
  final String surname;
  final EmptyEmail email;
  final EmptyPhoneNumber phone;
  final FormzSubmissionStatus status;
  final String error;

  @override
  List<Object> get props => [parent, name, surname, email, phone, status, error];

  EditParentState copyWith({
    Parent? parent,
    String? name,
    String? surname,
    EmptyEmail? email,
    EmptyPhoneNumber? phone,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return EditParentState(
      parent: parent ?? this.parent,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

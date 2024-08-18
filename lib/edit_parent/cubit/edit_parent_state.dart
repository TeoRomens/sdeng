part of 'edit_parent_cubit.dart';

/// Represents the state for editing a parent entity.
///
/// This state includes the current details of the parent, validation states for
/// form inputs, and the submission status of the update operation.
class EditParentState extends Equatable {
  /// Creates an [EditParentState] instance.
  ///
  /// The [parent] parameter represents the current parent entity being edited.
  /// The [name], [surname], [email], [phone], [status], and [error] parameters
  /// represent the form's input values and submission status.
  const EditParentState({
    required this.parent,
    this.name = '',
    this.surname = '',
    this.email = const EmptyEmail.pure(),
    this.phone = const EmptyPhoneNumber.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  /// The parent entity being edited.
  final Parent parent;

  /// The name of the parent. Defaults to an empty string.
  final String name;

  /// The surname of the parent. Defaults to an empty string.
  final String surname;

  /// The email of the parent, validated using [EmptyEmail].
  final EmptyEmail email;

  /// The phone number of the parent, validated using [EmptyPhoneNumber].
  final EmptyPhoneNumber phone;

  /// The submission status of the update operation.
  final FormzSubmissionStatus status;

  /// The error message, if any, related to the update operation.
  final String error;

  @override
  List<Object> get props => [
    parent,
    name,
    surname,
    email,
    phone,
    status,
    error,
  ];

  /// Creates a copy of the current [EditParentState] with optional modifications.
  ///
  /// If a parameter is provided, it will override the corresponding value
  /// in the current state. If a parameter is not provided, the current value
  /// will be retained.
  ///
  /// [parent] - The updated parent entity.
  /// [name] - The updated name of the parent.
  /// [surname] - The updated surname of the parent.
  /// [email] - The updated email of the parent.
  /// [phone] - The updated phone number of the parent.
  /// [status] - The updated submission status.
  /// [error] - The updated error message.
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

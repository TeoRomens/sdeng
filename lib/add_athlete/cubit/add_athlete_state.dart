part of 'add_athlete_cubit.dart';

/// Represents the state for adding an athlete.
class AddAthleteState extends Equatable {
  /// Creates an instance of [AddAthleteState].
  ///
  /// The [teamId] is required, while other parameters have default values.
  const AddAthleteState({
    required this.teamId,
    this.name = const NonEmpty.pure(),
    this.surname = const NonEmpty.pure(),
    this.taxCode = const TaxCode.pure(),
    this.email = const EmptyEmail.pure(),
    this.phone = const EmptyPhoneNumber.pure(),
    this.address = '',
    this.birthdate = const EmptyDate.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  /// The ID of the team to which the athlete will be added.
  final String teamId;

  /// The name of the athlete.
  final NonEmpty name;

  /// The surname of the athlete.
  final NonEmpty surname;

  /// The tax code of the athlete.
  final TaxCode taxCode;

  /// The email address of the athlete.
  final EmptyEmail email;

  /// The phone number of the athlete.
  final EmptyPhoneNumber phone;

  /// The address of the athlete.
  final String address;

  /// The birthdate of the athlete.
  final EmptyDate birthdate;

  /// The current status of the form submission.
  final FormzSubmissionStatus status;

  /// An error message, if any.
  final String error;

  @override
  List<Object> get props => [
    teamId,
    name,
    surname,
    taxCode,
    email,
    phone,
    address,
    birthdate,
    status,
    error,
  ];

  /// Creates a copy of the current state with optional new values.
  ///
  /// The provided values will replace the current values if they are not `null`.
  AddAthleteState copyWith({
    String? teamId,
    NonEmpty? name,
    NonEmpty? surname,
    TaxCode? taxCode,
    EmptyEmail? email,
    EmptyPhoneNumber? phone,
    String? address,
    EmptyDate? birthdate,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return AddAthleteState(
      teamId: teamId ?? this.teamId,
      name: name ?? this.name,
      surname: surname ?? this.surname,
      taxCode: taxCode ?? this.taxCode,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      birthdate: birthdate ?? this.birthdate,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

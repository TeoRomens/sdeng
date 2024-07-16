part of 'add_athlete_cubit.dart';

class AddAthleteState extends Equatable {
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

  final String teamId;
  final NonEmpty name;
  final NonEmpty surname;
  final TaxCode taxCode;
  final EmptyEmail email;
  final EmptyPhoneNumber phone;
  final String address;
  final EmptyDate birthdate;
  final FormzSubmissionStatus status;
  final String error;

  @override
  List<Object> get props => [name, surname, taxCode, email, phone, address, birthdate, status, error];

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

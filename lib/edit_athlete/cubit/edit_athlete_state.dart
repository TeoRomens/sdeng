part of 'edit_athlete_cubit.dart';

/// `EditAthleteState` holds the state of the athlete edit form and manages
/// the current values of the form fields, the submission status, and any
/// potential errors that occur during form submission.
///
/// The class is immutable, and the state is updated using the `copyWith`
/// method to create a new instance with modified values.
class EditAthleteState extends Equatable {

  /// Creates an `EditAthleteState` instance with the given values.
  ///
  /// * [athlete] - The athlete being edited. This is required.
  /// * [name] - The current value of the athlete's first name.
  /// * [surname] - The current value of the athlete's surname.
  /// * [taxCode] - The current value of the athlete's tax code.
  /// * [email] - The current value of the athlete's email address.
  /// * [phone] - The current value of the athlete's phone number.
  /// * [address] - The current value of the athlete's address.
  /// * [birthdate] - The current value of the athlete's birthdate.
  /// * [status] - The submission status of the form (e.g., initial, in-progress, success, failure).
  /// * [error] - Any error message related to the form submission.
  const EditAthleteState({
    required this.athlete,
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

  /// The athlete being edited.
  final Athlete athlete;

  /// The current value of the athlete's first name.
  ///
  /// The value is validated using the `NonEmpty` input class, which ensures that it is not empty.
  final NonEmpty name;

  /// The current value of the athlete's surname.
  ///
  /// Like `name`, this is also validated using the `NonEmpty` input class.
  final NonEmpty surname;

  /// The current value of the athlete's tax code.
  ///
  /// This field is validated using the `TaxCode` input class to ensure that it meets the necessary format.
  final TaxCode taxCode;

  /// The current value of the athlete's email address.
  ///
  /// This field is validated using the `EmptyEmail` input class to ensure it is in a valid email format.
  final EmptyEmail email;

  /// The current value of the athlete's phone number.
  ///
  /// This field is validated using the `EmptyPhoneNumber` input class to ensure it is in a valid phone number format.
  final EmptyPhoneNumber phone;

  /// The current value of the athlete's address.
  ///
  /// This is a simple string field representing the athlete's address.
  final String address;

  /// The current value of the athlete's birthdate.
  ///
  /// The date is validated using the `EmptyDate` input class, ensuring it follows a valid date format.
  final EmptyDate birthdate;

  /// The current status of the form submission.
  ///
  /// This uses the `FormzSubmissionStatus` enum to track the form's status, including:
  /// * `initial` - The form is in its initial state.
  /// * `inProgress` - The form submission is in progress.
  /// * `success` - The form was submitted successfully.
  /// * `failure` - The form submission failed.
  final FormzSubmissionStatus status;

  /// The current error message, if any, related to the form submission.
  ///
  /// This field is used to display error messages to the user if the form submission fails.
  final String error;

  @override
  List<Object> get props => [
    athlete,
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

  /// Creates a copy of the current state with the specified values replaced.
  ///
  /// This method is used to create a new `EditAthleteState` instance by
  /// copying the current state and replacing one or more fields with new values.
  ///
  /// * [athlete] - The athlete being edited.
  /// * [name] - The current value of the athlete's first name.
  /// * [surname] - The current value of the athlete's surname.
  /// * [taxCode] - The current value of the athlete's tax code.
  /// * [email] - The current value of the athlete's email address.
  /// * [phone] - The current value of the athlete's phone number.
  /// * [address] - The current value of the athlete's address.
  /// * [birthdate] - The current value of the athlete's birthdate.
  /// * [status] - The submission status of the form (e.g., initial, in-progress, success, failure).
  /// * [error] - Any error message related to the form submission.
  EditAthleteState copyWith({
    Athlete? athlete,
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
    return EditAthleteState(
      athlete: athlete ?? this.athlete,
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

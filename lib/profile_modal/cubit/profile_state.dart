part of 'profile_cubit.dart';

/// Represents the state of the profile management feature.
///
/// This class holds the current state of the profile, including user details, form
/// fields, submission status, and any error messages. It is used by the `ProfileCubit`
/// to manage and track changes to the user's profile information.
class ProfileState extends Equatable {
  /// Creates a new instance of `ProfileState`.
  ///
  /// [userId] is required to identify the user whose profile is being managed.
  /// Other parameters are optional and default to their initial values.
  const ProfileState({
    required this.userId,
    this.user,
    this.fullName = const NonEmpty.pure(),
    this.societyName = const NonEmpty.pure(),
    this.societyEmail = const EmptyEmail.pure(),
    this.societyPhone = const EmptyPhoneNumber.pure(),
    this.societyAddress = const NonEmpty.pure(),
    this.societyPiva = const NonEmpty.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  /// The current user object associated with the profile.
  final SdengUser? user;

  /// The unique identifier for the user whose profile is being managed.
  final String userId;

  /// The full name of the user, represented as a non-empty field.
  final NonEmpty fullName;

  /// The name of the society associated with the user, represented as a non-empty field.
  final NonEmpty societyName;

  /// The email address of the society, represented as an empty field.
  final EmptyEmail societyEmail;

  /// The phone number of the society, represented as an empty field.
  final EmptyPhoneNumber societyPhone;

  /// The address of the society, represented as a non-empty field.
  final NonEmpty societyAddress;

  /// The VAT number of the society, represented as a non-empty field.
  final NonEmpty societyPiva;

  /// The status of the form submission.
  final FormzSubmissionStatus status;

  /// Any error message related to form submission.
  final String error;

  @override
  List<Object> get props => [
    fullName,
    societyName,
    societyEmail,
    societyPhone,
    societyAddress,
    societyPiva,
    status,
    error,
  ];

  /// Creates a copy of the current `ProfileState` with optional modifications.
  ///
  /// If a parameter is not provided, the current value of that parameter is used.
  /// This method is useful for creating updated versions of the state while preserving
  /// unchanged values.
  ProfileState copyWith({
    NonEmpty? fullName,
    NonEmpty? societyName,
    EmptyEmail? societyEmail,
    EmptyPhoneNumber? societyPhone,
    NonEmpty? societyAddress,
    NonEmpty? societyPiva,
    FormzSubmissionStatus? status,
    String? error,
  }) {
    return ProfileState(
      userId: userId,
      fullName: fullName ?? this.fullName,
      societyName: societyName ?? this.societyName,
      societyEmail: societyEmail ?? this.societyEmail,
      societyPhone: societyPhone ?? this.societyPhone,
      societyAddress: societyAddress ?? this.societyAddress,
      societyPiva: societyPiva ?? this.societyPiva,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}

part of 'profile_cubit.dart';

class ProfileState extends Equatable {
  const ProfileState({
    required this.userId,
    this.fullName = const NonEmpty.pure(),
    this.societyName = const NonEmpty.pure(),
    this.societyEmail = const EmptyEmail.pure(),
    this.societyPhone = const EmptyPhoneNumber.pure(),
    this.societyAddress = const NonEmpty.pure(),
    this.societyPiva = const NonEmpty.pure(),
    this.status = FormzSubmissionStatus.initial,
    this.error = '',
  });

  final String userId;
  final NonEmpty fullName;
  final NonEmpty societyName;
  final EmptyEmail societyEmail;
  final EmptyPhoneNumber societyPhone;
  final NonEmpty societyAddress;
  final NonEmpty societyPiva;
  final FormzSubmissionStatus status;
  final String error;

  @override
  List<Object> get props => [fullName, societyName, societyEmail, societyPhone, societyAddress, societyPiva, status, error];

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

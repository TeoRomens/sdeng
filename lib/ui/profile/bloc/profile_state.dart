part of 'profile_bloc.dart';

enum ProfileStatus {
  idle,
}

enum SelectedMenu{
  none,
  settings,
  search,
  credits,
}

class ProfileState {
  ProfileState({
    this.name = '',
    this.surname = '',
    this.email = '',
    this.confirmEmail = '',
    this.password = '',
    this.confirmPassword = '',
    this.errorMessage = '',
    this.profileStatus = ProfileStatus.idle,
    this.selectedMenu = SelectedMenu.none,
  });

  final ProfileStatus profileStatus;
  final String name;
  final String surname;
  final String email;
  final String confirmEmail;
  final String confirmPassword;
  final String password;
  final String errorMessage;
  final SelectedMenu selectedMenu;

  ProfileState copyWith({
    String? name,
    String? surname,
    String? email,
    String? confirmEmail,
    String? password,
    String? confirmPassword,
    String? errorMessage,
    ProfileStatus? profileStatus,
    SelectedMenu? selectedMenu,
  }) {
    return ProfileState(
      name: name ?? this.name,
      surname: surname ?? this.surname,
      email: email ?? this.email,
      confirmEmail: confirmEmail ?? this.confirmEmail,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      errorMessage: errorMessage ?? this.errorMessage,
      profileStatus: profileStatus ?? this.profileStatus,
      selectedMenu: selectedMenu ??  this.selectedMenu,
    );
  }
}
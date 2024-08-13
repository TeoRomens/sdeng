import 'package:athletes_repository/athletes_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/profile_modal/cubit/profile_cubit.dart';
import 'package:sdeng/profile_modal/view/profile_form.dart';
import 'package:user_repository/user_repository.dart';

/// A modal that allows users to view and edit their profile information.
///
/// This widget uses [ProfileCubit] to manage the profile state and [ProfileForm]
/// to render the form for updating profile details. It provides a route method
/// for navigation and takes in user details as parameters.
class ProfileModal extends StatelessWidget {
  /// Creates a [ProfileModal] widget.
  ///
  /// [userId] is required to identify the user whose profile is being edited.
  /// [sdengUser] is an optional parameter that provides the initial values
  /// for the profile form.
  const ProfileModal({
    required this.userId,
    this.sdengUser,
    super.key,
  });

  /// Creates a [MaterialPageRoute] for the [ProfileModal].
  ///
  /// [userId] is required for the profile management, and [sdengUser] is optional
  /// to pre-fill the form with existing data.
  static Route<void> route(String userId, {SdengUser? sdengUser}) =>
      MaterialPageRoute<void>(
        builder: (_) => ProfileModal(
          userId: userId,
          sdengUser: sdengUser,
        ),
      );

  /// The route name for the [ProfileModal].
  static const String name = '/profileModal';

  /// The ID of the user whose profile is being edited.
  final String userId;

  /// The user's current profile data, used to initialize the form.
  final SdengUser? sdengUser;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(
        userRepository: context.read<UserRepository>(),
        userId: userId,
        sdengUser: sdengUser,
      ),
      child: ProfileForm(sdengUser: sdengUser),
    );
  }
}

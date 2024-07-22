import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sdeng_api/client.dart';
import 'package:sdeng/profile_modal/cubit/profile_cubit.dart';
import 'package:sdeng/profile_modal/view/profile_form.dart';
import 'package:user_repository/user_repository.dart';

class ProfileModal extends StatelessWidget {
  const ProfileModal({
    required this.userId,
    this.sdengUser,
    super.key,
  });

  static Route<void> route(String userId, {SdengUser? sdengUser}) =>
      MaterialPageRoute<void>(
        builder: (_) => ProfileModal(
          userId: userId,
          sdengUser: sdengUser,
        ),
      );

  static const String name = '/profileModal';

  final String userId;
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


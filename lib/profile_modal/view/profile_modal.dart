import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/profile_modal/cubit/profile_cubit.dart';
import 'package:sdeng/profile_modal/view/profile_form.dart';
import 'package:user_repository/user_repository.dart';

class ProfileModal extends StatelessWidget {
  const ProfileModal({
    required this.userId,
    super.key,
  });

  static Route<void> route(String userId) =>
      MaterialPageRoute<void>(builder: (_) => ProfileModal(userId: userId,));

  static const String name = '/profileModal';

  final String userId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(
        userRepository: context.read<UserRepository>(),
        userId: userId
      ),
      child: ProfileForm(),
    );
  }
}

import 'package:authentication_client/authentication_client.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:user_repository/user_repository.dart';

part 'user_profile_state.dart';

class UserProfileBloc extends Cubit<UserProfileState> {
  UserProfileBloc({
    required UserRepository userRepository,
  })  : _userRepository = userRepository,
        super(const UserProfileState.initial());

  final UserRepository _userRepository;

}

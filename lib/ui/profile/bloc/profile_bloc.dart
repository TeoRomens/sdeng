import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:sdeng/repositories/auth_repository.dart';
import 'package:sdeng/util/message_util.dart';

part 'profile_state.dart';

class ProfileBloc extends Cubit<ProfileState> {
  ProfileBloc() : super(ProfileState());

  final _authRepository = GetIt.I.get<AuthRepository>();

  Future<void> linkGoogleAccount() async {
    try{
      MessageUtil.showLoading();
      await _authRepository.linkGoogleAccount();
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'provider-already-linked': MessageUtil.showMessage('Google is already linked');
        break;
      }
    } finally {
      MessageUtil.hideLoading();
    }
  }

  void selectMenu(SelectedMenu selectedMenu) {
    emit(state.copyWith(selectedMenu: selectedMenu));
  }

}
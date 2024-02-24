import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sdeng/repositories/repository.dart';
import 'package:sdeng/ui/pages/login_page.dart';
import 'package:sdeng/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Class to hold static method related to requiring auth.
class AuthRequired {
  /// Method to determine whether the user has
  /// the right to perform auth required action
  /// such as posting videos or viewing their own profile.
  static Future<void> action(BuildContext context, {required void Function() action}) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      Navigator.of(context).pushReplacement(LoginPage.route());
      context.showErrorSnackBar(message: 'You must be logged in to do this');
      return;
    }
    action();
  }
}
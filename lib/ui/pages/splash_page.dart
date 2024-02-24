import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:sdeng/ui/pages/login_page.dart';
import 'package:sdeng/ui/pages/tab_page.dart';
import 'package:sdeng/ui/pages/register_page.dart';
import 'package:sdeng/utils/constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Page to redirect users to the appropriate page
/// depending on the initial auth state
class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    getInitialSession();
    super.initState();
  }

  Future<void> getInitialSession() async {
    // quick and dirty way to wait for the widget to mount
    await Future.delayed(Duration.zero);

    try {
      final session = Supabase.instance.client.auth.currentSession;
      if(session == null) {
        if(mounted) Navigator.of(context).pushReplacement(LoginPage.route());
      } else {
        if(mounted) Navigator.of(context).pushReplacement(TabPage.route());
      }
    } catch (e) {
      log(e.toString());
      if(mounted) {
        context.showErrorSnackBar(
          message: 'Error occurred during session refresh');
        Navigator.of(context).pushReplacement(RegisterPage.route());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: preloader
    );
  }
}

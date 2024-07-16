import 'package:flutter/widgets.dart';
import 'package:sdeng/app/bloc/app_bloc.dart';
import 'package:sdeng/home/view/home_page.dart';
import 'package:sdeng/login/view/login_page.dart';
import 'package:sdeng/splash/splash.dart';

/// Used by FlowBuilder
List<Page<dynamic>> generateAppViewPages(
  AppStatus state,
  List<Page<dynamic>> pages,
) {
  switch (state) {

    case AppStatus.unauthenticated:
      return [LoginPage.page()];
    case AppStatus.authenticated:
      return [SplashScreen.page()];
    case AppStatus.ready:
      return [HomePage.page()];
  }
}

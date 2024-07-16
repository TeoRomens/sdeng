import 'package:app_ui/src/generated/generated.dart';
import 'package:flutter/material.dart';

/// A default app logo.
class AppLogo extends StatelessWidget {
  /// {@macro app_logo}
  const AppLogo._({required SvgGenImage logo, super.key}) : _logo = logo;

  /// The dark app logo.
  AppLogo.dark({Key? key}) : this._(key: key, logo: Assets.images.logoDark);

  /// The light app logo.
  AppLogo.light({Key? key}) : this._(key: key, logo: Assets.images.logoLight);

  /// The logo to be displayed.
  final SvgGenImage _logo;

  @override
  Widget build(BuildContext context) {
    return _logo.svg(
      width: 172,
      height: 24,
    );
  }
}

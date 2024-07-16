import 'package:app_ui/app_ui.dart' show AppSpacing;
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';

import '../view/user_profile_page.dart';

/// A user profile button which displays an [OpenProfileButton]
/// for the authenticated user.
class UserProfileButton extends StatelessWidget {
  const UserProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const OpenProfileButton();
  }
}

@visibleForTesting
class OpenProfileButton extends StatelessWidget {
  const OpenProfileButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(FeatherIcons.user),
      iconSize: 24,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      onPressed: () => Navigator.of(context).push(UserProfilePage.route()),
      tooltip: 'Open profile',
    );
  }
}

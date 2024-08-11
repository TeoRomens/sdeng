import 'package:app_ui/app_ui.dart' show AppSpacing;
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class UserProfileButton extends StatelessWidget {
  const UserProfileButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(FeatherIcons.user),
      iconSize: 24,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      onPressed: onPressed,
      tooltip: 'Open profile',
    );
  }
}
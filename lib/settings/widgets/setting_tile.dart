import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  const SettingTile({
    required this.title,
    this.leading,
    this.trailing,
    this.onTap,
    super.key,
  });

  static const _leadingWidth = AppSpacing.xxlg + AppSpacing.md;

  final String title;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasLeading = leading != null;

    return ListTile(
        leading: SizedBox(
          width: hasLeading ? _leadingWidth : 0,
          child: leading,
        ),
        trailing: trailing,
        visualDensity: const VisualDensity(
          vertical: VisualDensity.minimumDensity,
        ),
        contentPadding: EdgeInsets.fromLTRB(
          hasLeading ? AppSpacing.sm : AppSpacing.xlg,
          AppSpacing.xs,
          AppSpacing.lg,
          AppSpacing.xs,
        ),
        horizontalTitleGap: 0,
        minLeadingWidth: hasLeading ? _leadingWidth : 0,
        onTap: onTap,
        title: Text(title),
        titleTextStyle: Theme.of(context).textTheme.labelLarge
    );
  }
}
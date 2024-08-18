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
    return Card(
      margin: EdgeInsets.zero,
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE4E7EC), width: 0.5),),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        visualDensity: VisualDensity.compact,
        horizontalTitleGap: 0,
        minLeadingWidth: hasLeading ? _leadingWidth : 0,
        leading: SizedBox(
          width: hasLeading ? _leadingWidth : 0,
          child: leading,
        ),
        title: Text(title),
        trailing: trailing,
        titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
            color: Colors.black,
            height: 1.6,),
        subtitleTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
          color: Color(0xFF475467),
        ),
        onTap: onTap,
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class MedicalTile extends StatelessWidget {
  const MedicalTile(
      {super.key,
      required this.title,
      required this.num,
      required this.leading,
      required this.onTap});

  final String title;
  final int num;
  final Widget leading;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFFE4E7EC), width: 0.5)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        horizontalTitleGap: 16,
        visualDensity: VisualDensity.compact,
        leading: leading,
        title: Text(title),
        subtitle: Text('$num Players'),
        titleTextStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Inter',
            color: Colors.black,
            height: 1.6),
        subtitleTextStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Inter',
          color: Color(0xFF475467),
        ),
        trailing: const Icon(FeatherIcons.chevronRight),
        onTap: onTap,
      ),
    );
  }
}

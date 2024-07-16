import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class TeamTile extends StatelessWidget{
  const TeamTile({super.key,
    this.name,
    this.numAthletes,
    this.onTap,
    this.trailing,
  });

  final String? name;
  final int? numAthletes;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      visualDensity: VisualDensity.compact,
      leading: ClipOval(
        child: Assets.images.logo1.svg(height: 40)
      ),
      title: Text(name ?? 'null'),
      titleTextStyle: Theme.of(context).textTheme.headlineSmall,
      subtitle: Text('$numAthletes Players'),
      subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
      trailing: const Icon(FeatherIcons.chevronRight, color: AppColors.black,),
      onTap: onTap,
    );
  }
}
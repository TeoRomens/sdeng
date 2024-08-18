import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_sdeng_api/client.dart';

/// A widget that displays a tile containing medical information for an athlete.
///
/// This tile is typically used in a list and provides a summary of an athlete's
/// medical details, including their full name and the expiration date of their
/// medical record.
///
/// The tile can be tapped to trigger an action, and it can also display a
/// custom trailing widget.
class AthleteMedicalTile extends StatelessWidget {
  /// Creates an [AthleteMedicalTile] instance.
  ///
  /// The [medical] parameter is required and provides the medical information
  /// to be displayed. The [onTap] callback and [trailing] widget are optional.
  const AthleteMedicalTile({
    required this.medical,
    this.onTap,
    this.trailing,
    super.key,
  });

  /// The medical information of the athlete.
  ///
  /// This data is used to populate the content of the tile, such as the athlete's
  /// full name and the expiration date of their medical record.
  final Medical medical;

  /// An optional widget displayed at the end of the tile.
  ///
  /// If no widget is provided, a default chevron icon is displayed.
  final Widget? trailing;

  /// An optional callback that is triggered when the tile is tapped.
  ///
  /// This can be used to navigate to a detail page or perform other actions
  /// related to the athlete's medical information.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.xs,
      ),
      leading: ClipOval(child: Assets.images.logo3.svg(height: 40)),
      title: Text(medical.fullName),
      titleTextStyle:
      Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 19),
      subtitle: Text(medical.expire?.dMY ?? 'null'),
      subtitleTextStyle: Theme.of(context).textTheme.bodySmall,
      trailing: trailing ??
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: Icon(FeatherIcons.chevronRight),
          ),
      onTap: onTap,
    );
  }
}

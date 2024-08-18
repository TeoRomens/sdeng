import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_sdeng_api/client.dart';

/// A widget that displays a tile containing information about an athlete.
///
/// This tile is typically used in a list and provides a summary of an athlete's
/// details, including their full name and tax code.
///
/// The tile can be tapped to trigger an action, and it can also display a
/// custom trailing widget.
class AthleteTile extends StatelessWidget {
  /// Creates an [AthleteTile] instance.
  ///
  /// The [athlete] parameter is required and provides the athlete's information
  /// to be displayed. The [onTap] callback and [trailing] widget are optional.
  const AthleteTile({
    required this.athlete,
    this.onTap,
    this.trailing,
    super.key,
  });

  /// The athlete's information.
  ///
  /// This data is used to populate the content of the tile, such as the athlete's
  /// full name and tax code.
  final Athlete athlete;

  /// An optional widget displayed at the end of the tile.
  ///
  /// If no widget is provided, a default chevron icon is displayed.
  final Widget? trailing;

  /// An optional callback that is triggered when the tile is tapped.
  ///
  /// This can be used to navigate to a detail page or perform other actions
  /// related to the athlete.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
      contentPadding: const EdgeInsets.symmetric(
        vertical: AppSpacing.xs,
      ),
      leading: ClipOval(child: Assets.images.logo3.svg(height: 40)),
      title: Text(athlete.fullName),
      titleTextStyle:
      Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 19),
      subtitle: Text(athlete.taxCode),
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

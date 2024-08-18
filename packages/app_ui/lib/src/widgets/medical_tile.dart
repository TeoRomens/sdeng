import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

/// A customizable tile widget for displaying medical information.
///
/// The `MedicalTile` widget displays a card with a leading widget
/// (e.g., an icon), a title, and a subtitle showing the number of players.
/// The tile is tappable, with a customizable action on tap.
///
/// This widget is useful in scenarios where you need to present
/// medical-related data in a list or grid format.
///
/// [title]: The main text displayed in the tile.
/// [num]: The number of players displayed as the subtitle.
/// [leading]: The widget displayed at the start of the tile.
/// [onTap]: The callback function triggered when the tile is tapped.
class MedicalTile extends StatelessWidget {
  /// Default constructor
  const MedicalTile({
    required this.title,
    required this.num,
    required this.leading,
    required this.onTap,
    super.key,
  });

  /// The title text displayed in the tile.
  final String title;

  /// The number of players displayed in the subtitle.
  final int num;

  /// The leading widget displayed at the start of the tile.
  final Widget leading;

  /// The callback function triggered when the tile is tapped.
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
        side: const BorderSide(color: Color(0xFFE4E7EC), width: 0.5),
      ),
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
          height: 1.6,
        ),
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

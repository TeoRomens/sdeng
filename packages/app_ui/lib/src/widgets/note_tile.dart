import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sdeng_api/client.dart';

/// A widget that displays a note with its author, content, and creation date.
class NoteTile extends StatelessWidget {
  /// Creates a [NoteTile] widget.
  ///
  /// The [note] parameter is required and represents the note to be displayed.
  const NoteTile({
    required this.note,
    super.key,
  });

  /// The note to be displayed in the tile.
  final Note note;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: AppSpacing.sm,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md + AppSpacing.xxs,
        vertical: AppSpacing.sm + AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xffe5e8eb)),
        boxShadow: const [
          BoxShadow(
            blurRadius: 2,
            offset: Offset(0, 1),
            color: AppColors.shadow,
          ),
        ],
      ),
      width: double.maxFinite,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            note.author,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Text(
            note.content,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text(
              note.createdAt.dMY,
              style: const TextStyle(
                color: AppColors.onBackground,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

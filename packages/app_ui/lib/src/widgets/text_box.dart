import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:flutter/material.dart';

/// A customizable info card.
class TextBox extends StatelessWidget {

  /// {@macro info_card}
  const TextBox({
    required this.title, required this.content, super.key,
  });

  /// The title text
  final String title;
  /// The content text
  final String? content;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ),
          const SizedBox(height: 2),
          if(content != null)
            Text(content!,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
                color: Color(0xFF475467),
                height: 1.3,
              ),
            ),
        ],
      ),
    );
  }
}

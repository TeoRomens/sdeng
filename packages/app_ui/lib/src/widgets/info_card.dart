import 'package:flutter/material.dart';

/// A customizable info card.
class InfoCard extends StatelessWidget {

  /// {@macro info_card}
  const InfoCard({
    required this.title, required this.content, super.key,
  });

  /// The title text
  final String title;
  /// The content text
  final String content;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: const Color(0xFFF9FAFB),
      surfaceTintColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
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
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                fontFamily: 'Inter',
                color: Color(0xFF475467),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

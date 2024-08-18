import 'package:flutter/material.dart';

/// A card widget that displays information about an athlete.
///
/// The `AthleteCard` widget displays a card with a title, content, an optional
/// image, and an optional action button. It is designed to present information
/// in a structured and visually appealing way.
///
/// This widget is useful for scenarios where you need to showcase
/// athlete details, such as in sports apps, fitness trackers, or profiles.
///
/// [title]: The main text displayed as the card's header.
/// [content]: The primary content of the card, typically descriptive text or widgets.
/// [image]: An optional image displayed on the right side of the card.
/// [action]: An optional action button or widget displayed below the content.
class AthleteCard extends StatelessWidget {
  /// Default constructor
  const AthleteCard({
    required this.title,
    required this.content,
    this.image,
    this.action,
    super.key,
  });

  /// The title text displayed at the top of the card.
  final String title;

  /// The primary content of the card, typically descriptive text or widgets.
  final Widget content;

  /// An optional image displayed on the right side of the card.
  final Widget? image;

  /// An optional action button or widget displayed below the content.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      color: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(
          color: Color(0xFFE4E7EC),
          width: 0.5,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Title row
            Row(
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    letterSpacing: -0.02,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Content and image row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content and action column
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    content,
                    const SizedBox(height: 6),
                    action ?? const SizedBox.shrink(),
                  ],
                ),
                // Optional image
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: image ?? const SizedBox(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

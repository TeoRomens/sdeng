import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

/// A card widget that displays basic information about an athlete.
///
/// The `AthleteInfoCard` widget presents an athlete's name and tax code
/// within a visually appealing card. It includes an avatar icon as a
/// placeholder for the athlete's profile picture.
///
/// This widget is ideal for use in athlete profiles, team rosters, or
/// any scenario where you need to display essential details about an athlete.
///
/// [name]: The name of the athlete displayed prominently.
/// [taxCode]: The athlete's tax code displayed below the name.
class AthleteInfoCard extends StatelessWidget {
  ///Default constructor
  const AthleteInfoCard({
    required this.name,
    required this.taxCode,
    super.key,
  });

  /// The name of the athlete.
  final String name;

  /// The tax code of the athlete.
  final String taxCode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 16,
      ),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFEAECF0),
          width: 0.8,
        ),
      ),
      child: Row(
        children: [
          // Circular container with a user icon as a placeholder for the athlete's image
          Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFFEAECF0),
              ),
              color: AppColors.white,
            ),
            child: const Icon(
              FeatherIcons.user,
              size: 40,
            ),
          ),
          const SizedBox(
            width: 16,
          ),
          // Athlete's name and tax code
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Athlete's name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 24,
                    color: Color(0xFF101828),
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.2,
                    height: 0,
                  ),
                  maxLines: 2,
                ),
                // Athlete's tax code
                Text(
                  taxCode,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF475467),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

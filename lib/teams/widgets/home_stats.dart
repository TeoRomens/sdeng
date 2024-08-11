import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class HomeStats extends StatelessWidget {
  const HomeStats({
    super.key,
    required this.numTeam,
    required this.numAthletes,
  });

  final int numTeam;
  final int numAthletes;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(color: AppColors.blueGrey.withOpacity(0.1)),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                FeatherIcons.shield,
                color: AppColors.darkAqua,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.md),
              const Text(
                'Teams',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppColors.darkAqua,
                ),
              ),
              const Spacer(),
              Text(
                numTeam.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.darkAqua,
                ),
              )
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                FeatherIcons.users,
                color: AppColors.darkAqua,
                size: 18,
              ),
              const SizedBox(width: AppSpacing.md),
              const Text(
                'Athletes',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: AppColors.darkAqua,
                ),
              ),
              const Spacer(),
              Text(
                numAthletes.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: AppColors.darkAqua,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

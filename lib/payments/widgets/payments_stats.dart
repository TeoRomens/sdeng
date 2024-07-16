import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class PaymentsStats extends StatelessWidget{
  const PaymentsStats({super.key,
    required this.cashed,
    required this.remaining,
    required this.total
  });

  final int cashed;
  final int remaining;
  final int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 30),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          color: AppColors.blueGrey.withOpacity(0.1)
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(FeatherIcons.home, color: AppColors.darkAqua, size: 18,),
              const SizedBox(width: AppSpacing.md),
              const Text('Cashed', style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.darkAqua,
              ),),
              const Spacer(),
              Text(cashed.toString(), style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.darkAqua,
              ),)
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(FeatherIcons.clock, color: AppColors.darkAqua, size: 18,),
              const SizedBox(width: AppSpacing.md),
              const Text('Remaining', style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.darkAqua,
              ),),
              const Spacer(),
              Text(remaining.toString(), style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.darkAqua,
              ),)
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(FeatherIcons.dollarSign, color: AppColors.darkAqua, size: 18,),
              const SizedBox(width: AppSpacing.md),
              const Text('Total', style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: AppColors.darkAqua,
              ),),
              const Spacer(),
              Text(total.toString(), style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.darkAqua,
              ),)
            ],
          )
        ],
      ),
    );
  }
}
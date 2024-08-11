import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template app_button}
/// Button with text displayed in the application.
/// {@endtemplate}
class PrimaryButton extends StatelessWidget {
  /// {@macro app_button}
  const PrimaryButton({
    this.child,
    this.onPressed,
    this.icon,
    this.text,
    super.key,
  });

  final VoidCallback? onPressed;
  final IconData? icon;
  final Widget? child;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(70, 48),
        elevation: 0.1,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        backgroundColor: AppColors.primary,
        surfaceTintColor: Colors.white,
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 18,
              color: AppColors.white,
            ),
            const SizedBox(width: 5),
          ],
          child ??
              Text(
                text ?? 'Button',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
        ],
      ),
    );
  }
}

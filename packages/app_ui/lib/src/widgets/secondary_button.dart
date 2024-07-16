import 'package:flutter/material.dart';

class SecondaryButton extends StatelessWidget {

  const SecondaryButton({
    required this.text,
    this.onPressed,
    this.icon,
    super.key,
  });

  final VoidCallback? onPressed;
  final IconData? icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 0.2,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        overlayColor: Colors.white,
        visualDensity: VisualDensity.compact,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(
            color: Color(0xFFD0D5DD),
            width: 0.6,
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 16,
              color: const Color(0xFF344054),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF344054),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}


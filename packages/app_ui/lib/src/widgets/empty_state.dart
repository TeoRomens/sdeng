import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

/// A standard empty state widget.
class EmptyState extends StatelessWidget {
  /// {@macro empty_state}
  const EmptyState({
    required this.actionText,
    required this.onPressed,
    super.key,
  });

  final String actionText;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Center(
      heightFactor: 1.2,
      child: Column(
        children: [
          Container(
            width: 90,
            height: 90,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFF9FAFB), Color(0xFFEDF0F3)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(
              Icons.search_sharp,
              size: 40,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No result found',
            style: TextStyle(
                fontSize: 18,
                letterSpacing: -0.2,
                color: Color(0xFF101828),
                fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          const Text(
            "The loading doesn't provided results,",
            style: TextStyle(
                fontSize: 15,
                fontFamily: 'Inter',
                color: Color(0xFF475467),
                fontWeight: FontWeight.w400),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryButton(
                onPressed: onPressed,
                text: actionText,
                icon: FeatherIcons.plus,
              )
            ],
          ),
        ],
      ),
    );
  }
}

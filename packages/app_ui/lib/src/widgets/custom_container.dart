import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// A custom container widget that displays an icon, text, and an optional button.
class CustomContainer extends StatelessWidget {
  /// Default constructor.
  ///
  /// The [icon] parameter is required and represents the icon to be displayed in the
  /// container. The [text] parameter is also required and represents the main text
  /// displayed alongside the icon. The [onPressed] callback is optional and will be
  /// used for the button action if provided. The [buttonText] parameter is optional
  /// and specifies the text to be displayed on the button. The default value is 'Button'.
  const CustomContainer({
    required this.icon,
    required this.text,
    this.onPressed,
    this.buttonText = 'Button',
    super.key,
  });

  /// The icon to be displayed in the container.
  final IconData icon;

  /// The text to be displayed in the container.
  final String text;

  /// The callback function that is triggered when the button is pressed.
  /// If null, the button is not displayed.
  final VoidCallback? onPressed;

  /// The text to be displayed on the button.
  /// Defaults to 'Button' if not provided.
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: EdgeInsets.symmetric(
        vertical: onPressed != null ? 5 : 12,
        horizontal: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF101828), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
                color: Color(0xFF101828),
              ),
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.fade,
            ),
          ),
          if (onPressed != null)
            SizedBox(
              width: 60,
              height: 36,
              child: SecondaryButton(
                onPressed: onPressed,
                text: buttonText,
              ),
            ),
        ],
      ),
    );
  }
}

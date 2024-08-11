import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

/// Button with plus and text displayed in the application.
class AppTextButton extends StatelessWidget {
  /// {@macro app_text_button}
  const AppTextButton({
    required this.text,
    this.onPressed,
    Color? foregroundColor,
    Color? disabledForegroundColor,
    BorderSide? borderSide,
    double? elevation,
    TextStyle? textStyle,
    Size? maximumSize,
    Size? minimumSize,
    EdgeInsets? padding,
    super.key,
  })  : _borderSide = borderSide,
        _foregroundColor = foregroundColor ?? AppColors.transparent,
        _disabledForegroundColor =
            disabledForegroundColor ?? AppColors.disabledForeground,
        _elevation = elevation ?? 0,
        _textStyle = textStyle,
        _maximumSize = maximumSize ?? _defaultMaximumSize,
        _minimumSize = minimumSize ?? _defaultMinimumSize,
        _padding = padding ?? _defaultPadding;

  /// The maximum size of the button.
  static const _defaultMaximumSize = Size(double.maxFinite, 40);

  /// The minimum size of the button.
  static const _defaultMinimumSize = Size(0, 40);

  /// The padding of the the button.
  static const _defaultPadding = EdgeInsets.zero;

  /// [VoidCallback] called when button is pressed.
  /// Button is disabled when null.
  final VoidCallback? onPressed;

  /// Color of the text, icons etc.
  ///
  /// Defaults to [AppColors.black].
  final Color _foregroundColor;

  /// Color of the disabled text, icons etc.
  ///
  /// Defaults to [AppColors.disabledForeground].
  final Color _disabledForegroundColor;

  /// A border of the button.
  final BorderSide? _borderSide;

  /// Elevation of the button.
  final double _elevation;

  /// [TextStyle] of the button text.
  ///
  /// Defaults to [TextTheme.labelLarge].
  final TextStyle? _textStyle;

  /// The maximum size of the button.
  ///
  /// Defaults to [_defaultMaximumSize].
  final Size _maximumSize;

  /// The minimum size of the button.
  ///
  /// Defaults to [_defaultMinimumSize].
  final Size _minimumSize;

  /// The padding of the button.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsets? _padding;

  /// Text displayed on the button.
  final String text;

  @override
  Widget build(BuildContext context) {
    final textStyle = _textStyle ?? Theme.of(context).textTheme.labelLarge;

    return TextButton(
      onPressed: onPressed,
      style: ButtonStyle(
        maximumSize: WidgetStateProperty.all(_maximumSize),
        padding: WidgetStateProperty.all(_padding ?? EdgeInsets.zero),
        minimumSize: WidgetStateProperty.all(_minimumSize),
        textStyle: WidgetStateProperty.all(textStyle),
        backgroundColor: WidgetStateProperty.all(AppColors.transparent),
        elevation: WidgetStateProperty.all(_elevation),
        foregroundColor: onPressed == null
            ? WidgetStateProperty.all(_disabledForegroundColor)
            : WidgetStateProperty.all(_foregroundColor),
        surfaceTintColor: WidgetStateProperty.all(AppColors.transparent),
        side: WidgetStateProperty.all(_borderSide),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            width: AppSpacing.sm,
          ),
          const CircleAvatar(
            radius: 10,
            backgroundColor: AppColors.primary,
            child: Icon(FeatherIcons.plus, color: Colors.white, size: 15),
          ),
          const SizedBox(
            width: AppSpacing.sm,
          ),
          Text(
            text,
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
          const SizedBox(
            width: AppSpacing.sm,
          ),
        ],
      ),
    );
  }
}

import 'package:app_ui/app_ui.dart';
import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// {@template app_text_form_field}
/// A text field component based on material [TextFormField] widget with a
/// fixed, left-aligned label text displayed above the text field.
/// {@endtemplate}
class AppTextFormField extends StatelessWidget {
  /// {@macro app_text_form_field}
  const AppTextFormField({
    super.key,
    this.label,
    this.bottomText,
    this.initialValue,
    this.autoFillHints,
    this.controller,
    this.inputFormatters,
    this.autocorrect = true,
    this.readOnly = false,
    this.hintText,
    this.errorText,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.validator,
    this.obscure = false,
    this.maxLines,
    this.maxLength,
  });

  /// Label text
  final String? label;

  /// Bottom text
  final String? bottomText;

  /// A value to initialize the field to.
  final String? initialValue;

  /// List of auto fill hints.
  final Iterable<String>? autoFillHints;

  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final TextEditingController? controller;

  /// Optional input validation and formatting overrides.
  final List<TextInputFormatter>? inputFormatters;

  /// Whether to enable autocorrect.
  /// Defaults to true.
  final bool autocorrect;

  /// Whether the text field should be read-only.
  /// Defaults to false.
  final bool readOnly;

  /// The max lines of the field.
  final int? maxLines;

  /// The max number of characters of the field.
  final int? maxLength;

  /// Text that suggests what sort of input the field accepts.
  final String? hintText;

  /// Text that appears below the field.
  final String? errorText;

  /// A widget that appears before the editable part of the text field.
  final Widget? prefix;

  /// A widget that appears after the editable part of the text field.
  final Widget? suffix;

  /// The type of keyboard to use for editing the text.
  /// Defaults to [TextInputType.text] if maxLines is one and
  /// [TextInputType.multiline] otherwise.
  final TextInputType? keyboardType;

  /// Called when the user inserts or deletes texts in the text field.
  final ValueChanged<String>? onChanged;

  /// {@macro flutter.widgets.editableText.onSubmitted}
  final ValueChanged<String>? onSubmitted;

  /// Called when the text field has been tapped.
  final VoidCallback? onTap;

  /// Called when form.validate has been called.
  final String? Function(String?)? validator;

  /// True to obscure the text or not
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.sm,
              bottom: AppSpacing.sm,
            ),
            child: Text(
              label!,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        TextFormField(
          key: key,
          initialValue: initialValue,
          controller: controller,
          inputFormatters: inputFormatters,
          keyboardType: keyboardType,
          autocorrect: autocorrect,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          readOnly: readOnly,
          autofillHints: autoFillHints,
          cursorColor: AppColors.primary,
          style: Theme.of(context).textTheme.bodyLarge,
          onFieldSubmitted: onSubmitted,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF667085),
                ),
            errorText: errorText,
            prefixIcon: prefix,
            suffixIcon: suffix,
            suffixIconConstraints: const BoxConstraints.tightFor(
              width: 32,
              height: 32,
            ),
            prefixIconConstraints: const BoxConstraints.tightFor(
              width: 46,
            ),
            errorMaxLines: 2,
          ),
          maxLines: maxLines ?? 1,
          maxLength: maxLength,
          validator: validator,
          onChanged: onChanged,
          onTap: onTap,
          obscureText: obscure,
          textInputAction: TextInputAction.next,
          onTapOutside: (_) => FocusManager.instance.primaryFocus?.unfocus(),
        ),
        if (bottomText != null)
          Padding(
            padding: const EdgeInsets.only(
              top: AppSpacing.sm,
            ),
            child: Text(bottomText!,
                style: Theme.of(context).textTheme.labelSmall,),
          ),
      ],
    );
  }
}

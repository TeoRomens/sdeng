import 'package:app_ui/src/spacing/app_spacing.dart';
import 'package:app_ui/src/widgets/app_logo.dart';
import 'package:flutter/material.dart';

/// Simple box for loading states
class LoadingBox extends StatelessWidget {
  /// Default constructor
  const LoadingBox({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppLogo.light(),
            const SizedBox(
              height: AppSpacing.md,
            ),
            const SizedBox.square(
              dimension: AppSpacing.xlg,
              child: CircularProgressIndicator.adaptive(
                strokeCap: StrokeCap.round,
                strokeWidth: 2,
              ),
            )
          ,],
        ),
      ),
    );
  }
}

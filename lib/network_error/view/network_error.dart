import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';

/// {@template network_error}
/// A network error alert.
/// {@endtemplate}
class NetworkError extends StatelessWidget {
  /// {@macro network_error}
  const NetworkError({super.key, this.onRetry});

  /// An optional callback which is invoked when the retry button is pressed.
  final VoidCallback? onRetry;

  static Page<void> page({VoidCallback? onRetry}) => MaterialPage<void>(
          child: NetworkError(
        onRetry: onRetry,
      ));

  /// Route constructor to display the widget inside a [Scaffold].
  static Route<void> route({VoidCallback? onRetry}) {
    return MaterialPageRoute<void>(
      builder: (_) => NetworkError(onRetry: onRetry),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.primary,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppLogo.dark(),
          const SizedBox(height: AppSpacing.xlg),
          const Icon(
            Icons.wifi_off_outlined,
            size: 40,
            color: AppColors.white,
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            'Connection error',
            style: theme.textTheme.titleLarge?.copyWith(color: AppColors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.lg),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxxlg),
            child: PrimaryButton(
              onPressed: onRetry,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    flex: 0,
                    child: Icon(Icons.refresh,
                        size: UITextStyle.bodyLarge.fontSize),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Flexible(
                    child: Text(
                      'Retry',
                      style: UITextStyle.bodyLarge,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.xlg),
        ],
      ),
    );
  }
}

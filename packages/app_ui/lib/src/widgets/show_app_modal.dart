import 'package:flutter/material.dart';

/// Modal which is styled for the app.
Future<T?> showAppModal<T>({
  required BuildContext context,
  required Widget content,
  RouteSettings? routeSettings,
  BoxConstraints? constraints,
  double? elevation,
  Color? barrierColor,
  bool isDismissible = true,
  bool enableDrag = true,
  AnimationController? transitionAnimationController,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => content,
    routeSettings: routeSettings,
    constraints: constraints,
    isScrollControlled: true,
    useSafeArea: true,
    barrierColor: barrierColor,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    transitionAnimationController: transitionAnimationController,
    elevation: elevation,
  );
}

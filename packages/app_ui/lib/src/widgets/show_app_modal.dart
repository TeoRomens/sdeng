import 'package:flutter/material.dart';
import 'package:side_sheet/side_sheet.dart'; // Assuming you have a SideSheet package

/// Modal which is styled for the app.
Future<dynamic> showAppModal<T>({
  required BuildContext context,
  required Widget content,
  RouteSettings? routeSettings,
  BoxConstraints? constraints,
  double? elevation,
  Color? barrierColor,
  bool isDismissible = true,
  bool enableDrag = true,
  AnimationController? transitionAnimationController,
  double? width, // Add width parameter for SideSheet
}) {
  final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

  if (isPortrait) {
    return showModalBottomSheet<T>(
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
  } else {
    return SideSheet.right(
      barrierDismissible: isDismissible,
      context: context,
      body: content,
      width: width ?? 500,
    );
  }
}

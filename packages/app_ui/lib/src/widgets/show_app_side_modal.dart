import 'package:flutter/material.dart';
import 'package:side_sheet/side_sheet.dart';

/// Side modal which is styled for the app.
Future<dynamic> showAppSideModal<T>({
  required BuildContext context,
  required Widget content,
  RouteSettings? routeSettings,
  BoxConstraints? constraints,
  double? width,
  Color? barrierColor,
}) {
  return SideSheet.right(
    context: context,
    body: content,
    width: width ?? 500,
  );
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sdeng/globals/dimension.dart';

class ResponsiveHelper {
  final Size deviceSize;

  ResponsiveHelper({required BuildContext context})
      : deviceSize = MediaQuery.of(context).size;

  T value<T>({
    required T mobile,
    required T desktop,
  }) => isMobile ? mobile : desktop;

  bool get isMobile => deviceSize.width <= WIDTH_MOBILE;
}

class ResponsiveWidget extends StatelessWidget {
  final Widget mobile;
  final Widget desktop;

  const ResponsiveWidget({
    Key? key,
    required this.mobile,
    required this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (MediaQuery.of(context).size.width <= WIDTH_MOBILE) {
          return mobile;
        } else {
          return desktop;
        }
      },
    );
  }
}
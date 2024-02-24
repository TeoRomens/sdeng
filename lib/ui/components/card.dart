import 'package:flutter/material.dart';
import 'package:sdeng/utils/constants.dart';

class SdengCard extends StatelessWidget {
  const SdengCard({super.key, required this.child, this.padding});

  final Widget child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: const Color(0xffe5e8eb)
          ),
          boxShadow: const [
            BoxShadow(
                blurRadius: 2,
                offset: Offset(0, 1),
                color: shadowColor
            )
          ]
      ),
      width: double.maxFinite,
      child: child
    );
  }
}